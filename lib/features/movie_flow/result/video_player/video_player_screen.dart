import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  final String videoId;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      params: const YoutubePlayerParams(
        // Defining custom playlist
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      debugPrint('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      debugPrint('Exited Fullscreen');
    };
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: YoutubePlayerControllerProvider(
        controller: _controller,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Center(
            child: YoutubeValueBuilder(
              controller: _controller,
              builder: (context, value) {
                return AnimatedCrossFade(
                  firstChild: const YoutubePlayerIFrame(),
                  secondChild: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        width: double.infinity,
                        image: NetworkImage(
                          YoutubePlayerController.getThumbnail(
                            videoId: widget.videoId,
                            quality: ThumbnailQuality.max,
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                  crossFadeState: value.isReady
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
