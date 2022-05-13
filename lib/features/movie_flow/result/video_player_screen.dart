import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
      flags: const YoutubePlayerFlags(
        forceHD: true,
        hideThumbnail: true,
        disableDragSeek: true,
        useHybridComposition: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.value.isFullScreen) {
          _controller.toggleFullScreenMode();
        }
        Navigator.of(context).pop();
        return true;
      },
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Center(
              child: YoutubePlayer(
                bottomActions: null,
                showVideoProgressIndicator: false,
                controller: _controller,
                bufferIndicator: const CircularProgressIndicator(),
                progressColors: ProgressBarColors(
                  playedColor: Theme.of(context).colorScheme.primary,
                  handleColor: Colors.white,
                ),
                onEnded: (_) => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
