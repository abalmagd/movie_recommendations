import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/widgets/button.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  static route({bool fullScreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const VideoPlayerScreen(),
        fullscreenDialog: fullScreenDialog,
      );

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Center(
          child: Button(
            onPressed: () {},
            text: 'Test',
          ),
        ),
      ),
    );
  }
}
