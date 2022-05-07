import 'package:flutter/material.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    Key? key,
    this.backDropPath,
  }) : super(key: key);

  final String? backDropPath;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
        },
        child: Image.network(
          backDropPath ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, e, s) => const Center(
            child: Text('No preview found'),
          ),
        ),
      ),
    );
  }
}
