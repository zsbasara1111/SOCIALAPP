import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/ai_service.dart';
import '../../providers/ai_assistant_provider.dart';
import '../../providers/red_heart_provider.dart';
import '../../widgets/chat/ai_assistant_button.dart';
import '../../widgets/chat/topic_suggestions_panel.dart';

/// 聊天详情页面
class ChatDetailPage extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String? avatar;

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.userName,
    this.avatar,
  });

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // TODO: 从服务器加载聊天记录
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          content: '你好呀～看到你的资料觉得很有缘！',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        ChatMessage(
          id: '2',
          content: '嗨！很高兴认识你 😊',
          isMe: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
        ),
        ChatMessage(
          id: '3',
          content: '看到你也喜欢摄影，平时都拍什么主题比较多？',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ]);
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // TODO: 发送到服务器
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.textPrimary,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头像
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.8),
                    AppTheme.accent.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: widget.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        widget.avatar!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.userName.substring(0, 1),
                        style: AppTheme.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: AppTheme.spaceSm),
            // 用户名
            Text(
              widget.userName,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            // 红心互点标记
            Consumer(
              builder: (context, ref, child) {
                final isMutual = ref.watch(
                  isMutualHeartProvider(widget.userId),
                );
                if (!isMutual) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE91E63),
                          Color(0xFFFF6B9D),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 10,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '红心',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // 更多选项
          IconButton(
            onPressed: () {
              // TODO: 显示更多选项（查看资料、屏蔽等）
            },
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // AI助手区域
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceLg,
              vertical: AppTheme.spaceMd,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.surfaceVariant,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AI助手头部
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // AI按钮
                    AIAssistantButton(
                      onTap: () {
                        ref.read(aiAssistantProvider.notifier).toggleExpanded();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spaceMd),

                // 话题建议面板
                TopicSuggestionsPanel(
                  onTopicTap: (topic) {
                    // 将话题填入输入框并聚焦
                    _messageController.text = topic;
                    _messageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: topic.length),
                    );
                    // 通过延迟确保面板收起后再聚焦输入框
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (mounted) {
                        FocusScope.of(context).requestFocus(_inputFocusNode);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // 消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),

          // 输入框
          _buildInputArea(),
        ],
      ),
    );
  }

  /// 构建消息项
  Widget _buildMessageItem(ChatMessage message) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceLg,
                vertical: AppTheme.spaceMd,
              ),
              decoration: BoxDecoration(
                gradient: isMe
                    ? LinearGradient(
                        colors: [
                          AppTheme.primary,
                          AppTheme.accent,
                        ],
                      )
                    : null,
                color: isMe ? null : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg).copyWith(
                  bottomRight: isMe ? const Radius.circular(4) : null,
                  bottomLeft: !isMe ? const Radius.circular(4) : null,
                ),
              ),
              child: Text(
                message.content,
                style: AppTheme.bodyLarge.copyWith(
                  color: isMe ? Colors.white : AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: AppTheme.labelSmall.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.surfaceVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 语音按钮
            IconButton(
              onPressed: () {
                // TODO: 语音输入
              },
              icon: Icon(
                Icons.mic,
                color: AppTheme.textSecondary,
              ),
            ),

            // 输入框
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _inputFocusNode,
                  decoration: InputDecoration(
                    hintText: '输入消息...',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceMd,
                    ),
                  ),
                  style: AppTheme.bodyMedium,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            // 表情按钮
            IconButton(
              onPressed: () {
                // TODO: 表情面板
              },
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: AppTheme.textSecondary,
              ),
            ),

            // 发送按钮
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary,
                      AppTheme.accent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

