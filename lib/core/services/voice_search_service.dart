import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:permission_handler/permission_handler.dart';

/// Estado del servicio de búsqueda por voz
class VoiceSearchState {
  final bool isListening;
  final bool isAvailable;
  final String recognizedText;
  final String? error;
  final double soundLevel;
  final List<LocaleName> locales;

  const VoiceSearchState({
    this.isListening = false,
    this.isAvailable = false,
    this.recognizedText = '',
    this.error,
    this.soundLevel = 0.0,
    this.locales = const [],
  });

  VoiceSearchState copyWith({
    bool? isListening,
    bool? isAvailable,
    String? recognizedText,
    String? error,
    double? soundLevel,
    List<LocaleName>? locales,
  }) {
    return VoiceSearchState(
      isListening: isListening ?? this.isListening,
      isAvailable: isAvailable ?? this.isAvailable,
      recognizedText: recognizedText ?? this.recognizedText,
      error: error,
      soundLevel: soundLevel ?? this.soundLevel,
      locales: locales ?? this.locales,
    );
  }
}

/// Servicio de búsqueda por voz usando speech_to_text
class VoiceSearchService extends StateNotifier<VoiceSearchState> {
  final SpeechToText _speechToText = SpeechToText();

  VoiceSearchService() : super(const VoiceSearchState());

  /// Inicializa el servicio de reconocimiento de voz
  Future<bool> initialize() async {
    try {
      // Verificar y solicitar permisos
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        state = state.copyWith(
          isAvailable: false,
          error: 'Permiso de micrófono denegado',
        );
        return false;
      }

      // Inicializar speech_to_text
      final available = await _speechToText.initialize(
        onError: _onError,
        onStatus: _onStatus,
        debugLogging: false,
      );

      if (available) {
        final locales = await _speechToText.locales();
        state = state.copyWith(
          isAvailable: true,
          locales: locales,
          error: null,
        );
      } else {
        state = state.copyWith(
          isAvailable: false,
          error: 'Reconocimiento de voz no disponible en este dispositivo',
        );
      }

      return available;
    } catch (e) {
      state = state.copyWith(
        isAvailable: false,
        error: 'Error al inicializar: $e',
      );
      return false;
    }
  }

  /// Inicia la escucha de voz
  Future<void> startListening({
    String localeId = 'es_ES',
    Function(String)? onResult,
  }) async {
    if (!state.isAvailable) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    state = state.copyWith(
      isListening: true,
      recognizedText: '',
      error: null,
    );

    try {
      await _speechToText.listen(
        onResult: (result) => _onResult(result, onResult),
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        onSoundLevelChange: _onSoundLevelChange,
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isListening: false,
        error: 'Error al iniciar escucha: $e',
      );
    }
  }

  /// Detiene la escucha de voz
  Future<void> stopListening() async {
    await _speechToText.stop();
    state = state.copyWith(isListening: false);
  }

  /// Cancela la escucha de voz
  Future<void> cancelListening() async {
    await _speechToText.cancel();
    state = state.copyWith(
      isListening: false,
      recognizedText: '',
    );
  }

  void _onResult(SpeechRecognitionResult result, Function(String)? onResult) {
    state = state.copyWith(
      recognizedText: result.recognizedWords,
      isListening: !result.finalResult,
    );

    if (result.finalResult && onResult != null) {
      onResult(result.recognizedWords);
    }
  }

  void _onError(SpeechRecognitionError error) {
    String errorMessage;
    switch (error.errorMsg) {
      case 'error_no_match':
        errorMessage = 'No se reconoció ninguna palabra';
        break;
      case 'error_speech_timeout':
        errorMessage = 'Tiempo de espera agotado';
        break;
      case 'error_audio':
        errorMessage = 'Error de audio';
        break;
      case 'error_network':
        errorMessage = 'Error de red';
        break;
      case 'error_permission':
        errorMessage = 'Permiso de micrófono denegado';
        break;
      default:
        errorMessage = 'Error: ${error.errorMsg}';
    }

    state = state.copyWith(
      isListening: false,
      error: errorMessage,
    );
  }

  void _onStatus(String status) {
    if (status == 'notListening' || status == 'done') {
      state = state.copyWith(isListening: false);
    }
  }

  void _onSoundLevelChange(double level) {
    state = state.copyWith(soundLevel: level);
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}

/// Provider para el servicio de búsqueda por voz
final voiceSearchProvider =
    StateNotifierProvider<VoiceSearchService, VoiceSearchState>((ref) {
  return VoiceSearchService();
});

/// Widget de diálogo para búsqueda por voz
class VoiceSearchDialog extends ConsumerStatefulWidget {
  final Function(String) onResult;
  final String hintText;

  const VoiceSearchDialog({
    super.key,
    required this.onResult,
    this.hintText = 'Di lo que quieres buscar...',
  });

  @override
  ConsumerState<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends ConsumerState<VoiceSearchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Iniciar escucha automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    ref.read(voiceSearchProvider.notifier).startListening(
          localeId: 'es_US',
          onResult: (text) {
            if (text.isNotEmpty) {
              Navigator.of(context).pop();
              widget.onResult(text);
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceSearchProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono animado del micrófono
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: voiceState.isListening ? _scaleAnimation.value : 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: voiceState.isListening
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      voiceState.isListening ? Icons.mic : Icons.mic_none,
                      size: 40,
                      color: voiceState.isListening ? Colors.red : Colors.grey,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Indicador de nivel de sonido
            if (voiceState.isListening)
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.shade200,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      ((voiceState.soundLevel + 10) / 20).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Texto reconocido o hint
            Text(
              voiceState.recognizedText.isNotEmpty
                  ? voiceState.recognizedText
                  : widget.hintText,
              style: TextStyle(
                fontSize: 16,
                color: voiceState.recognizedText.isNotEmpty
                    ? Colors.black87
                    : Colors.grey,
                fontWeight: voiceState.recognizedText.isNotEmpty
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Error si existe
            if (voiceState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  voiceState.error!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(voiceSearchProvider.notifier).cancelListening();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                if (!voiceState.isListening && voiceState.error != null)
                  ElevatedButton(
                    onPressed: _startListening,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text('Reintentar'),
                  ),
                if (voiceState.isListening)
                  ElevatedButton(
                    onPressed: () {
                      ref.read(voiceSearchProvider.notifier).stopListening();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Detener'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
