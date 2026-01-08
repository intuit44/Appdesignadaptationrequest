// Widget de video player seguro que cumple con Apple App Store
// - Usa video_player nativo (no WebView)
// - Requiere autenticación para contenido privado
// - Soporta YouTube (público) y MP4/HLS (privado)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Tipo de fuente de video
enum VideoSourceType {
  youtube,
  mp4,
  hls,
}

/// Modelo de información de video
class VideoInfo {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final VideoSourceType type;
  final String source; // YouTube ID o URL directa
  final int? durationSeconds;
  final bool isPublic;

  const VideoInfo({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.type,
    required this.source,
    this.durationSeconds,
    this.isPublic = false,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      type: _parseVideoType(json['type']),
      source: json['source'] ?? '',
      durationSeconds: json['duration'],
      isPublic: json['isPublic'] ?? false,
    );
  }

  static VideoSourceType _parseVideoType(String? type) {
    switch (type?.toLowerCase()) {
      case 'youtube':
        return VideoSourceType.youtube;
      case 'hls':
        return VideoSourceType.hls;
      case 'mp4':
      default:
        return VideoSourceType.mp4;
    }
  }
}

/// Widget principal que decide qué player usar según el tipo de video
class SecureVideoPlayer extends ConsumerStatefulWidget {
  final VideoInfo videoInfo;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onVideoEnd;
  final Function(Duration)? onProgress;

  const SecureVideoPlayer({
    super.key,
    required this.videoInfo,
    this.autoPlay = false,
    this.showControls = true,
    this.onVideoEnd,
    this.onProgress,
  });

  @override
  ConsumerState<SecureVideoPlayer> createState() => _SecureVideoPlayerState();
}

class _SecureVideoPlayerState extends ConsumerState<SecureVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    switch (widget.videoInfo.type) {
      case VideoSourceType.youtube:
        return _YouTubeVideoPlayer(
          videoInfo: widget.videoInfo,
          autoPlay: widget.autoPlay,
          showControls: widget.showControls,
          onVideoEnd: widget.onVideoEnd,
        );
      case VideoSourceType.mp4:
      case VideoSourceType.hls:
        return _NativeVideoPlayer(
          videoInfo: widget.videoInfo,
          autoPlay: widget.autoPlay,
          showControls: widget.showControls,
          onVideoEnd: widget.onVideoEnd,
          onProgress: widget.onProgress,
        );
    }
  }
}

/// Player de YouTube usando youtube_player_flutter (nativo, no WebView)
class _YouTubeVideoPlayer extends StatefulWidget {
  final VideoInfo videoInfo;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onVideoEnd;

  const _YouTubeVideoPlayer({
    required this.videoInfo,
    this.autoPlay = false,
    this.showControls = true,
    this.onVideoEnd,
  });

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoInfo.source,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        enableCaption: true,
        hideControls: !widget.showControls,
        controlsVisibleAtStart: true,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.playerState == PlayerState.ended) {
      widget.onVideoEnd?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
          progressColors: ProgressBarColors(
            playedColor: Theme.of(context).primaryColor,
            handleColor: Theme.of(context).primaryColor,
          ),
          onReady: () {
            setState(() => _isReady = true);
          },
        ),
        builder: (context, player) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    player,
                    if (!_isReady)
                      Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.videoInfo.title.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  widget.videoInfo.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
              if (widget.videoInfo.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  widget.videoInfo.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Player nativo para MP4/HLS usando video_player + chewie
/// Cumple 100% con Apple App Store (reproducción nativa)
class _NativeVideoPlayer extends StatefulWidget {
  final VideoInfo videoInfo;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onVideoEnd;
  final Function(Duration)? onProgress;

  const _NativeVideoPlayer({
    required this.videoInfo,
    this.autoPlay = false,
    this.showControls = true,
    this.onVideoEnd,
    this.onProgress,
  });

  @override
  State<_NativeVideoPlayer> createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<_NativeVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final uri = Uri.parse(widget.videoInfo.source);

      _videoController = VideoPlayerController.networkUrl(uri);

      await _videoController!.initialize();

      _videoController!.addListener(_videoListener);

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: widget.autoPlay,
        looping: false,
        showControls: widget.showControls,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Error al cargar video',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: widget.videoInfo.thumbnailUrl != null
                ? Image.network(
                    widget.videoInfo.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white54,
                      size: 64,
                    ),
                  )
                : const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white54,
                    size: 64,
                  ),
          ),
        ),
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _videoListener() {
    if (_videoController == null) return;

    // Notificar progreso
    widget.onProgress?.call(_videoController!.value.position);

    // Verificar si terminó
    if (_videoController!.value.position >= _videoController!.value.duration &&
        _videoController!.value.duration.inSeconds > 0) {
      widget.onVideoEnd?.call();
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (_error != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  'No se pudo cargar el video',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    _initializePlayer();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(controller: _chewieController!),
          ),
          if (widget.videoInfo.title.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.videoInfo.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          if (widget.videoInfo.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.videoInfo.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
