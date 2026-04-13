import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// AI话题助手服务
/// 使用豆包API生成深入话题建议
class AIService {
  static const String _baseUrl = 'https://ark.cn-beijing.volces.com/api/v3';
  static const String _model = 'doubao-pro-32k-241115';

  // TODO: 从环境变量或配置文件读取
  static const String _apiKey = 'YOUR_DOUBAO_API_KEY';

  /// 生成深入话题建议
  ///
  /// [userHobbies] - 当前用户的爱好列表
  /// [matchHobbies] - 匹配对象的爱好列表
  /// [chatHistory] - 最近的聊天记录（可选）
  /// [mode] - 助手模式：normal(正常) / dating(约会)
  Future<List<TopicSuggestion>> generateTopics({
    required List<String> userHobbies,
    required List<String> matchHobbies,
    List<ChatMessage>? chatHistory,
    AIAssistantMode mode = AIAssistantMode.normal,
  }) async {
    try {
      // 如果没有API Key，返回模拟数据
      if (_apiKey == 'YOUR_DOUBAO_API_KEY') {
        return _getMockTopics(mode, userHobbies, matchHobbies);
      }

      final prompt = _buildPrompt(
        userHobbies: userHobbies,
        matchHobbies: matchHobbies,
        chatHistory: chatHistory,
        mode: mode,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(mode),
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.8,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return _parseTopics(content);
      } else {
        throw Exception('API调用失败: ${response.statusCode}');
      }
    } catch (e) {
      // 出错时返回模拟数据
      return _getMockTopics(mode, userHobbies, matchHobbies);
    }
  }

  /// 获取系统提示词
  String _getSystemPrompt(AIAssistantMode mode) {
    if (mode == AIAssistantMode.dating) {
      return '''你是一位约会助手，帮助用户策划线下约会。
根据双方共同的爱好，推荐合适的约会地点和活动建议。
输出格式：每个建议包含「场景」和「具体建议」两部分。''';
    }
    return '''你是一位社交话题助手，帮助用户开启深入有趣的对话。
根据双方的爱好重叠，生成有深度的话题建议。
话题应该：
1. 基于共同爱好，但深入挖掘
2. 避免陈词滥调
3. 引导分享个人经历和观点
4. 适合发展成有意义的对话
输出格式：每个话题包含「话题」和「开场白」两部分。''';
  }

  /// 构建用户提示词
  String _buildPrompt({
    required List<String> userHobbies,
    required List<String> matchHobbies,
    List<ChatMessage>? chatHistory,
    required AIAssistantMode mode,
  }) {
    // 找出共同爱好
    final commonHobbies = userHobbies.where((h) => matchHobbies.contains(h)).toList();

    final buffer = StringBuffer();
    buffer.writeln('我的爱好：${userHobbies.join('、')}');
    buffer.writeln('对方的爱好：${matchHobbies.join('、')}');

    if (commonHobbies.isNotEmpty) {
      buffer.writeln('共同爱好：${commonHobbies.join('、')}');
    }

    if (chatHistory != null && chatHistory.isNotEmpty) {
      buffer.writeln('\n最近的聊天：');
      for (final msg in chatHistory.take(5)) {
        buffer.writeln('${msg.isMe ? '我' : '对方'}: ${msg.content}');
      }
    }

    if (mode == AIAssistantMode.dating) {
      buffer.writeln('\n请基于我们的共同爱好，推荐3个约会场景和活动建议。');
    } else {
      buffer.writeln('\n请基于我们的共同爱好，生成3个深入的聊天话题。每个话题包含：');
      buffer.writeln('1. 话题标题（简洁有力）');
      buffer.writeln('2. 开场白（自然的提问方式）');
    }

    return buffer.toString();
  }

  /// 解析API返回的话题
  List<TopicSuggestion> _parseTopics(String content) {
    final topics = <TopicSuggestion>[];
    final lines = content.split('\n');

    String? currentTitle;
    String? currentDescription;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // 匹配话题标题（支持多种格式）
      if (trimmed.startsWith(RegExp(r'^\d+[:\.．、\s]'))) {
        // 保存上一个话题
        if (currentTitle != null && currentDescription != null) {
          topics.add(TopicSuggestion(
            title: currentTitle,
            description: currentDescription,
          ));
        }
        // 提取新标题
        currentTitle = trimmed.replaceFirst(RegExp(r'^\d+[:\.．、\s]+'), '');
        currentDescription = null;
      } else if (trimmed.startsWith('话题') || trimmed.startsWith('场景')) {
        if (currentTitle != null && currentDescription != null) {
          topics.add(TopicSuggestion(
            title: currentTitle,
            description: currentDescription,
          ));
        }
        currentTitle = trimmed.substring(trimmed.indexOf('：') + 1).trim();
        currentDescription = null;
      } else if (trimmed.startsWith('开场白') ||
                 trimmed.startsWith('具体建议') ||
                 trimmed.startsWith('建议')) {
        currentDescription = trimmed.substring(trimmed.indexOf('：') + 1).trim();
      } else if (currentDescription == null && currentTitle != null) {
        // 可能是描述行
        currentDescription = trimmed;
      }
    }

    // 添加最后一个话题
    if (currentTitle != null && currentDescription != null) {
      topics.add(TopicSuggestion(
        title: currentTitle,
        description: currentDescription,
      ));
    }

    return topics.isEmpty ? _getMockTopics(AIAssistantMode.normal, [], []) : topics;
  }

  /// 获取模拟话题数据
  List<TopicSuggestion> _getMockTopics(
    AIAssistantMode mode,
    List<String> userHobbies,
    List<String> matchHobbies,
  ) {
    // 找出共同爱好
    final commonHobbies = userHobbies.where((h) => matchHobbies.contains(h)).toList();
    final hobby = commonHobbies.isNotEmpty
        ? commonHobbies[Random().nextInt(commonHobbies.length)]
        : '兴趣爱好';

    if (mode == AIAssistantMode.dating) {
      return [
        TopicSuggestion(
          title: '🎨 艺术漫步',
          description: '一起去城市美术馆看展，然后在附近的咖啡馆聊聊各自最喜欢的艺术家。',
          type: TopicType.date,
        ),
        TopicSuggestion(
          title: '🎵 音乐之夜',
          description: '找个有现场音乐的酒吧或爵士俱乐部，边听边聊音乐品味。',
          type: TopicType.date,
        ),
        TopicSuggestion(
          title: '🍜 美食探索',
          description: '一起去尝试一家新开的特色餐厅，分享彼此的美食故事。',
          type: TopicType.date,
        ),
      ];
    }

    // 正常模式的话题
    final allTopics = [
      TopicSuggestion(
        title: '$hobby背后的初心',
        description: '你是什么时候开始喜欢上$hobby的？是什么契机让你入坑的？',
      ),
      TopicSuggestion(
        title: '最难忘的$hobby经历',
        description: '在$hobby的过程中，有没有哪个瞬间让你印象特别深刻？',
      ),
      TopicSuggestion(
        title: '$hobby带来的改变',
        description: '你觉得$hobby对你的生活或性格有什么影响吗？',
      ),
      TopicSuggestion(
        title: '理想中的$hobby时光',
        description: '如果可以完美安排一天来做$hobby，你会怎么度过？',
      ),
      TopicSuggestion(
        title: '$hobby的隐藏技能',
        description: '在$hobby的过程中，你学到了哪些意外的技能或知识？',
      ),
      TopicSuggestion(
        title: '分享一件$hobby相关的珍藏',
        description: '有没有一件和$hobby相关的物品对你来说特别有意义？',
      ),
    ];

    // 随机返回3个
    allTopics.shuffle();
    return allTopics.take(3).toList();
  }
}

/// AI助手模式
enum AIAssistantMode {
  normal,  // 正常话题建议
  dating,  // 约会模式
}

/// 话题建议
class TopicSuggestion {
  final String title;
  final String description;
  final TopicType type;

  const TopicSuggestion({
    required this.title,
    required this.description,
    this.type = TopicType.conversation,
  });
}

/// 话题类型
enum TopicType {
  conversation,  // 聊天话题
  date,          // 约会建议
}

/// 聊天消息
class ChatMessage {
  final String id;
  final String content;
  final bool isMe;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isMe,
    required this.timestamp,
  });
}
