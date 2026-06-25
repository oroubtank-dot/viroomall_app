// lib/features/product/presentation/widgets/product_details/product_video_section.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class ProductVideoSection extends StatefulWidget {
  final String? videoUrl;

  const ProductVideoSection({super.key, this.videoUrl});

  @override
  State<ProductVideoSection> createState() => _ProductVideoSectionState();
}

class _ProductVideoSectionState extends State<ProductVideoSection> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) return;

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      );
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الفيديو: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _togglePlay,
          child: GlassContainer(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ✅ الفيديو أو الصورة الثابتة
                  _isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: VirooColors.glassDark,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: VirooColors.amberPrimary,
                            ),
                          ),
                        ),

                  // ✅ زر التشغيل في المنتصف
                  if (!_isPlaying)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: VirooColors.amberPrimary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: VirooColors.amberPrimary.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                  // ✅ شريط التقدم
                  if (_isInitialized)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        color: Colors.white.withValues(alpha: 0.1),
                        child: ClipRRect(
                          child: LinearProgressIndicator(
                            value: _controller!.value.position.inMilliseconds /
                                _controller!.value.duration.inMilliseconds,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              VirooColors.amberPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.videocam_rounded,
              color: VirooColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 6),
            const Text(
              'فيديو المنتج',
              style: TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
            const Spacer(),
            if (_isInitialized)
              Text(
                '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                style: const TextStyle(
                  color: VirooColors.textTertiary,
                  fontSize: 10,
                  fontFamily: 'Cairo',
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _togglePlay() {
    if (!_isInitialized) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}