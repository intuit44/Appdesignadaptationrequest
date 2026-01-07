import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Servicio para interactuar con el Chatbot de Gemini a través de Cloud Functions
/// Proporciona respuestas en tiempo real con datos de WooCommerce y Agent CRM
class GeminiChatService {
  final Dio _dio;
  static GeminiChatService? _instance;

  // Historial de conversación para contexto
  List<Map<String, String>> _conversationHistory = [];

  GeminiChatService._()
      : _dio = Dio(BaseOptions(
          baseUrl: dotenv.env['FIREBASE_FUNCTIONS_URL'] ??
              'https://us-central1-eng-gate-453810-h3.cloudfunctions.net',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  static GeminiChatService get instance {
    _instance ??= GeminiChatService._();
    return _instance!;
  }

  /// Envía un mensaje al chatbot y recibe respuesta
  Future<ChatResponse> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {
          'data': {
            'message': message,
            'conversationHistory': _conversationHistory,
          },
        },
      );

      if (response.data != null && response.data['result'] != null) {
        final result = response.data['result'];

        // Actualizar historial
        if (result['conversationHistory'] != null) {
          _conversationHistory = List<Map<String, String>>.from(
            (result['conversationHistory'] as List).map(
              (item) => Map<String, String>.from(item),
            ),
          );
        }

        return ChatResponse(
          success: result['success'] ?? false,
          message: result['response'] ?? 'No se pudo obtener respuesta',
        );
      }

      return ChatResponse(
        success: false,
        message: 'Error en la respuesta del servidor',
      );
    } on DioException catch (e) {
      debugPrint('GeminiChatService error: ${e.message}');
      return ChatResponse(
        success: false,
        message: _getErrorMessage(e),
      );
    } catch (e) {
      debugPrint('GeminiChatService unexpected error: $e');
      return ChatResponse(
        success: false,
        message: 'Error inesperado. Por favor, intenta de nuevo.',
      );
    }
  }

  /// Limpia el historial de conversación
  void clearHistory() {
    _conversationHistory = [];
  }

  /// Obtiene el historial actual
  List<Map<String, String>> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  /// Mensaje de error amigable
  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La conexión tardó demasiado. Verifica tu internet e intenta de nuevo.';
      case DioExceptionType.connectionError:
        return 'No se pudo conectar al servidor. Verifica tu conexión a internet.';
      default:
        return 'Error de conexión. Por favor, intenta de nuevo.';
    }
  }
}

/// Respuesta del chatbot
class ChatResponse {
  final bool success;
  final String message;

  ChatResponse({
    required this.success,
    required this.message,
  });
}

/// Estado del chat
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Mensaje individual del chat
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Provider del servicio de chat
final geminiChatServiceProvider = Provider<GeminiChatService>((ref) {
  return GeminiChatService.instance;
});

/// Provider del estado del chat
final chatStateProvider =
    StateNotifierProvider<ChatStateNotifier, ChatState>((ref) {
  return ChatStateNotifier(ref.read(geminiChatServiceProvider));
});

/// Notifier para manejar el estado del chat
class ChatStateNotifier extends StateNotifier<ChatState> {
  final GeminiChatService _chatService;

  ChatStateNotifier(this._chatService) : super(ChatState());

  /// Envía un mensaje
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Agregar mensaje del usuario
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Obtener respuesta
    final response = await _chatService.sendMessage(message);

    // Agregar respuesta del bot
    final botMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: response.message,
      isUser: false,
    );

    state = state.copyWith(
      messages: [...state.messages, botMessage],
      isLoading: false,
      error: response.success ? null : response.message,
    );
  }

  /// Limpia el chat
  void clearChat() {
    _chatService.clearHistory();
    state = ChatState();
  }

  /// Agrega mensaje de bienvenida
  void addWelcomeMessage() {
    if (state.messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        id: 'welcome',
        content: '¡Hola! 👋 Soy el asistente virtual de Fibro Academy USA. '
            'Puedo ayudarte con información sobre:\n\n'
            '• 📚 Cursos y talleres de estética\n'
            '• 🧴 Productos profesionales\n'
            '• 📅 Próximos eventos y fechas\n'
            '• 📍 Ubicación y contacto\n\n'
            '¿En qué puedo ayudarte hoy?',
        isUser: false,
      );

      state = state.copyWith(messages: [welcomeMessage]);
    }
  }
}
