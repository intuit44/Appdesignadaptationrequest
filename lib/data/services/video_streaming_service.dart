// Servicio de Video Streaming para Fibro Academy
// Conecta con Firebase Cloud Functions para acceso seguro a videos
// Cumple con políticas de Apple App Store

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/video/secure_video_player.dart';

/// Estado del acceso a video
class VideoAccessState {
  final bool success;
  final String? error;
  final String? errorMessage;
  final String accessLevel; // 'public', 'preview', 'full'
  final List<VideoInfo> videos;
  final List<VideoInfo> publicVideos;
  final Map<String, dynamic>? courseInfo;
  final DateTime? expiresAt;

  const VideoAccessState({
    required this.success,
    this.error,
    this.errorMessage,
    this.accessLevel = 'public',
    this.videos = const [],
    this.publicVideos = const [],
    this.courseInfo,
    this.expiresAt,
  });

  factory VideoAccessState.loading() => const VideoAccessState(
        success: false,
        accessLevel: 'loading',
      );

  factory VideoAccessState.error(String message) => VideoAccessState(
        success: false,
        error: 'error',
        errorMessage: message,
      );

  bool get isLoading => accessLevel == 'loading';
  bool get hasFullAccess => accessLevel == 'full';
  bool get needsAuthentication => error == 'authentication_required';
  bool get needsPurchase => error == 'access_denied';
}

/// Servicio de video streaming
class VideoStreamingService {
  static VideoStreamingService? _instance;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  VideoStreamingService._()
      : _functions = FirebaseFunctions.instance,
        _auth = FirebaseAuth.instance;

  static VideoStreamingService get instance {
    _instance ??= VideoStreamingService._();
    return _instance!;
  }

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  /// ID del usuario actual
  String? get currentUserId => _auth.currentUser?.uid;

  /// Obtiene acceso seguro a videos de un curso
  Future<VideoAccessState> getSecureVideoAccess({
    required String courseId,
    String? videoId,
  }) async {
    try {
      final callable = _functions.httpsCallable('getSecureVideoAccess');

      final result = await callable.call<Map<String, dynamic>>({
        'courseId': courseId,
        'videoId': videoId,
      });

      final data = result.data;

      if (data['success'] == true) {
        final videos = <VideoInfo>[];
        if (data['videos'] != null) {
          for (final v in data['videos'] as List) {
            videos.add(VideoInfo.fromJson(v as Map<String, dynamic>));
          }
        }
        if (data['video'] != null) {
          videos.add(VideoInfo.fromJson(data['video'] as Map<String, dynamic>));
        }

        return VideoAccessState(
          success: true,
          accessLevel: data['accessLevel'] ?? 'full',
          videos: videos,
          courseInfo: data['course'] as Map<String, dynamic>?,
          expiresAt: data['expiresAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(data['expiresAt'] as int)
              : null,
        );
      } else {
        final publicVideos = <VideoInfo>[];
        if (data['publicVideos'] != null) {
          for (final v in data['publicVideos'] as List) {
            publicVideos.add(VideoInfo.fromJson(v as Map<String, dynamic>));
          }
        }

        return VideoAccessState(
          success: false,
          error: data['error'] as String?,
          errorMessage: data['message'] as String?,
          publicVideos: publicVideos,
          courseInfo: data['course'] as Map<String, dynamic>?,
        );
      }
    } catch (e) {
      debugPrint('VideoStreamingService.getSecureVideoAccess error: $e');
      return VideoAccessState.error(
        'Error al verificar acceso: ${e.toString()}',
      );
    }
  }

  /// Obtiene lista de videos públicos/promocionales
  Future<List<VideoInfo>> getPublicVideos() async {
    try {
      final callable = _functions.httpsCallable('getPublicVideos');
      final result = await callable.call<Map<String, dynamic>>({});

      final data = result.data;
      final videos = <VideoInfo>[];

      if (data['success'] == true && data['videos'] != null) {
        for (final v in data['videos'] as List) {
          videos.add(VideoInfo.fromJson(v as Map<String, dynamic>));
        }
      }

      return videos;
    } catch (e) {
      debugPrint('VideoStreamingService.getPublicVideos error: $e');
      return [];
    }
  }

  /// Marca un video como visto (guarda en SharedPreferences)
  Future<void> markVideoAsWatched(String courseId, String videoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'watched_videos_$courseId';
      final watched = prefs.getStringList(key) ?? [];
      if (!watched.contains(videoId)) {
        watched.add(videoId);
        await prefs.setStringList(key, watched);
      }
    } catch (e) {
      debugPrint('Error marcando video como visto: $e');
    }
  }

  /// Obtiene lista de videos vistos de un curso
  Future<List<String>> getWatchedVideos(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('watched_videos_$courseId') ?? [];
    } catch (e) {
      return [];
    }
  }
}

// ==================== Riverpod Providers ====================

/// Provider del servicio de video
final videoStreamingServiceProvider = Provider<VideoStreamingService>((ref) {
  return VideoStreamingService.instance;
});

/// Provider para videos públicos
final publicVideosProvider = FutureProvider<List<VideoInfo>>((ref) async {
  final service = ref.watch(videoStreamingServiceProvider);
  return service.getPublicVideos();
});

/// Provider para acceso a videos de un curso específico
final courseVideoAccessProvider =
    FutureProvider.family<VideoAccessState, String>(
  (ref, courseId) async {
    final service = ref.watch(videoStreamingServiceProvider);
    return service.getSecureVideoAccess(courseId: courseId);
  },
);

/// Provider para verificar si el usuario está autenticado (para mostrar contenido)
final videoAuthStateProvider = StreamProvider<bool>((ref) {
  return FirebaseAuth.instance.authStateChanges().map((user) => user != null);
});
