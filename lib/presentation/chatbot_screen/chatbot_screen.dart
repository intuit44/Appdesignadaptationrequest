import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/services/gemini_chat_service.dart';

/// Pantalla del Chatbot con Gemini AI
/// Proporciona asistencia en tiempo real con datos de productos y cursos
class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Agregar mensaje de bienvenida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatStateProvider.notifier).addWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _focusNode.unfocus();

    await ref.read(chatStateProvider.notifier).sendMessage(message);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);

    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState()
                : _buildMessagesList(chatState),
          ),
          // Input de mensaje
          _buildMessageInput(chatState.isLoading),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: appTheme.deepOrange400,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 24.h,
            ),
          ),
          SizedBox(width: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asistente Fibro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Siempre disponible',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12.fSize,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            ref.read(chatStateProvider.notifier).clearChat();
            ref.read(chatStateProvider.notifier).addWelcomeMessage();
          },
          tooltip: 'Nueva conversación',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.h,
            color: appTheme.gray400,
          ),
          SizedBox(height: 16.h),
          Text(
            'Inicia una conversación',
            style: TextStyle(
              fontSize: 16.fSize,
              color: appTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatState chatState) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.h),
      itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == chatState.messages.length && chatState.isLoading) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(chatState.messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: appTheme.deepOrange400,
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20.h,
              ),
            ),
            SizedBox(width: 8.h),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser ? appTheme.deepOrange400 : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 16.h : 4.h),
                  topRight: Radius.circular(isUser ? 4.h : 16.h),
                  bottomLeft: Radius.circular(16.h),
                  bottomRight: Radius.circular(16.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: isUser ? Colors.white : appTheme.gray900,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8.h),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: appTheme.deepOrange400,
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 20.h,
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4.h),
                _buildDot(1),
                SizedBox(width: 4.h),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color:
                appTheme.deepOrange400.withValues(alpha: 0.3 + (value * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(bool isLoading) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quick actions
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: appTheme.deepOrange400,
              ),
              onPressed: _showQuickActions,
            ),
            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.gray100,
                  borderRadius: BorderRadius.circular(24.h),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu mensaje...',
                    hintStyle: TextStyle(
                      color: appTheme.gray400,
                      fontSize: 14.fSize,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 8.h),
            // Send button
            Container(
              decoration: BoxDecoration(
                color: isLoading ? appTheme.gray300 : appTheme.deepOrange400,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isLoading ? Icons.hourglass_empty : Icons.send,
                  color: Colors.white,
                ),
                onPressed: isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preguntas frecuentes',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.gray900,
              ),
            ),
            SizedBox(height: 16.h),
            _buildQuickActionItem(
              '¿Qué cursos tienen disponibles?',
              Icons.school_outlined,
            ),
            _buildQuickActionItem(
              '¿Cuáles son los precios de los productos?',
              Icons.shopping_bag_outlined,
            ),
            _buildQuickActionItem(
              '¿Dónde están ubicados?',
              Icons.location_on_outlined,
            ),
            _buildQuickActionItem(
              '¿Tienen eventos próximamente?',
              Icons.event_outlined,
            ),
            _buildQuickActionItem(
              '¿Cómo me puedo certificar?',
              Icons.workspace_premium_outlined,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(String question, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _messageController.text = question;
        _sendMessage();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: appTheme.deepOrange400, size: 24.h),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: appTheme.gray700,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: appTheme.gray400),
          ],
        ),
      ),
    );
  }
}
