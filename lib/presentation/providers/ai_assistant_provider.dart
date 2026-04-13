import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/ai_service.dart';

/// AI助手状态
class AIAssistantState {
  final List<TopicSuggestion> topics;
  final bool isLoading;
  final String? error;
  final AIAssistantMode mode;
  final bool isExpanded;

  const AIAssistantState({
    this.topics = const [],
    this.isLoading = false,
    this.error,
    this.mode = AIAssistantMode.normal,
    this.isExpanded = false,
  });

  AIAssistantState copyWith({
    List<TopicSuggestion>? topics,
    bool? isLoading,
    String? error,
    AIAssistantMode? mode,
    bool? isExpanded,
  }) {
    return AIAssistantState(
      topics: topics ?? this.topics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      mode: mode ?? this.mode,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// AI助手状态管理
class AIAssistantNotifier extends StateNotifier<AIAssistantState> {
  final AIService _aiService;

  AIAssistantNotifier() : _aiService = AIService(), super(const AIAssistantState());

  /// 生成话题建议
  Future<void> generateTopics({
    required List<String> userHobbies,
    required List<String> matchHobbies,
    List<ChatMessage>? chatHistory,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final topics = await _aiService.generateTopics(
        userHobbies: userHobbies,
        matchHobbies: matchHobbies,
        chatHistory: chatHistory,
        mode: state.mode,
      );

      state = state.copyWith(
        topics: topics,
        isLoading: false,
        isExpanded: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '生成话题失败，请重试',
      );
    }
  }

  /// 切换助手模式
  void switchMode(AIAssistantMode mode) {
    if (state.mode == mode) return;
    state = state.copyWith(
      mode: mode,
      topics: [],
      isExpanded: false,
    );
  }

  /// 展开/收起话题面板
  void toggleExpanded() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  /// 收起话题面板
  void collapse() {
    state = state.copyWith(isExpanded: false);
  }

  /// 展开话题面板
  void expand() {
    state = state.copyWith(isExpanded: true);
  }

  /// 清空话题
  void clearTopics() {
    state = state.copyWith(topics: []);
  }

  /// 使用话题（点击后自动收起）
  void useTopic() {
    state = state.copyWith(isExpanded: false);
  }
}

/// AI助手Provider
final aiAssistantProvider =
    StateNotifierProvider<AIAssistantNotifier, AIAssistantState>((ref) {
  return AIAssistantNotifier();
});

/// 当前话题列表Provider
final aiTopicsProvider = Provider<List<TopicSuggestion>>((ref) {
  return ref.watch(aiAssistantProvider).topics;
});

/// AI助手是否加载中
final aiLoadingProvider = Provider<bool>((ref) {
  return ref.watch(aiAssistantProvider).isLoading;
});

/// AI助手是否展开
final aiExpandedProvider = Provider<bool>((ref) {
  return ref.watch(aiAssistantProvider).isExpanded;
});

/// AI助手当前模式
final aiModeProvider = Provider<AIAssistantMode>((ref) {
  return ref.watch(aiAssistantProvider).mode;
});
