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

  void listener() {}

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        disableDragSeek: true,
        // hideControls: true,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ),
        child: Center(
          child: YoutubePlayer(
            controller: _controller,
            topActions: [
              BackButton(
                onPressed: () {
                  if (_controller.value.isFullScreen) {
                    _controller.toggleFullScreenMode();
                  }
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ],
            bottomActions: [
              const SizedBox(width: 14.0),
              CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: Theme.of(context).colorScheme.primary,
                  handleColor: Colors.white,
                ),
              ),
              RemainingDuration(),
            ],
            showVideoProgressIndicator: true,
          ),
        ),
      ),
    );
  }
}
