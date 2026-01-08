// Pantalla de Video de Curso
// Integra el sistema de video streaming con autenticación
// Cumple con Apple App Store policies

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/video_streaming_service.dart';
import '../../widgets/video/secure_video_player.dart';

/// Pantalla que muestra videos de un curso con verificación de acceso
class CourseVideoScreen extends ConsumerWidget {
  final String courseId;
  final String courseName;

  const CourseVideoScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAccessAsync = ref.watch(courseVideoAccessProvider(courseId));

    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        elevation: 0,
      ),
      body: videoAccessAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verificando acceso...'),
            ],
          ),
        ),
        error: (error, stack) =>
            _buildErrorState(context, ref, error.toString()),
        data: (accessState) {
          if (accessState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Usuario necesita autenticarse
          if (accessState.needsAuthentication) {
            return _buildAuthRequiredState(context, ref, accessState);
          }

          // Usuario no tiene acceso al curso
          if (accessState.needsPurchase) {
            return _buildPurchaseRequiredState(context, ref, accessState);
          }

          // Usuario tiene acceso completo
          if (accessState.hasFullAccess && accessState.videos.isNotEmpty) {
            return _buildVideoListState(context, ref, accessState);
          }

          // Mostrar videos públicos como fallback
          if (accessState.publicVideos.isNotEmpty) {
            return _buildPublicVideosState(context, ref, accessState);
          }

          return _buildNoContentState(context);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar videos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.invalidate(courseVideoAccessProvider(courseId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRequiredState(
    BuildContext context,
    WidgetRef ref,
    VideoAccessState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensaje de autenticación requerida
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.lock_outline,
                    size: 48, color: Colors.orange.shade700),
                const SizedBox(height: 12),
                Text(
                  'Contenido Exclusivo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ??
                      'Inicia sesión para ver el contenido completo del curso',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a pantalla de login
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Videos de muestra
          if (state.publicVideos.isNotEmpty) ...[
            Text(
              'Videos de Muestra',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...state.publicVideos.map(
              (video) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SecureVideoPlayer(
                  videoInfo: video,
                  autoPlay: false,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPurchaseRequiredState(
    BuildContext context,
    WidgetRef ref,
    VideoAccessState state,
  ) {
    final courseInfo = state.courseInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensaje de compra requerida
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  courseInfo?['name'] ?? courseName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ??
                      'Adquiere este curso para acceder al contenido completo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (courseInfo?['price'] != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    courseInfo!['price'],
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      _openCourseCheckout(context, courseId, courseInfo),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Adquirir Curso'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Videos de muestra
          if (state.publicVideos.isNotEmpty) ...[
            Text(
              'Vista Previa del Curso',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mira estos videos de muestra para conocer más sobre el curso',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            ...state.publicVideos.map(
              (video) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SecureVideoPlayer(
                  videoInfo: video,
                  autoPlay: false,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoListState(
    BuildContext context,
    WidgetRef ref,
    VideoAccessState state,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.videos.length,
      itemBuilder: (context, index) {
        final video = state.videos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                Text(
                  'Videos del Curso',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tienes acceso completo a ${state.videos.length} videos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
              ],
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SecureVideoPlayer(
                      videoInfo: video,
                      autoPlay: false,
                      onVideoEnd: () => _onVideoCompleted(
                        context,
                        ref,
                        video.id,
                        index,
                        state.videos.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Video ${index + 1} de ${state.videos.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ),
                          if (video.durationSeconds != null)
                            Text(
                              _formatDuration(video.durationSeconds!),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPublicVideosState(
    BuildContext context,
    WidgetRef ref,
    VideoAccessState state,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.publicVideos.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Videos Disponibles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contenido público de Fibro Academy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        final video = state.publicVideos[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SecureVideoPlayer(
            videoInfo: video,
            autoPlay: false,
          ),
        );
      },
    );
  }

  Widget _buildNoContentState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.video_library_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay videos disponibles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'El contenido de este curso estará disponible próximamente',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Abre el checkout de WooCommerce para comprar el curso
  void _openCourseCheckout(
    BuildContext context,
    String courseId,
    Map<String, dynamic>? courseInfo,
  ) {
    final productId = courseInfo?['woocommerce_id'] ?? courseId;
    final checkoutUrl =
        'https://fibroacademyusa.com/checkout/?add-to-cart=$productId';

    Navigator.of(context).pushNamed(
      '/webview',
      arguments: {
        'url': checkoutUrl,
        'title': 'Comprar Curso',
      },
    );
  }

  /// Marca video como visto y auto-reproduce el siguiente
  void _onVideoCompleted(
    BuildContext context,
    WidgetRef ref,
    String videoId,
    int currentIndex,
    int totalVideos,
  ) {
    // Marcar video como completado
    ref
        .read(videoStreamingServiceProvider)
        .markVideoAsWatched(courseId, videoId);

    // Auto-reproducir siguiente si existe
    if (currentIndex < totalVideos - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video ${currentIndex + 2} cargando...'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Último video del curso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Felicidades! Has completado todos los videos'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
