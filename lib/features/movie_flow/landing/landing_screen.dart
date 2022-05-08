import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final call = ref.read(movieFlowControllerProvider.notifier);
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: () => Navigator.pop(context)),
        actions: [ThemeIconButton(onPressed: () => call.changeTheme(context))],
      ),
      body: Column(
        children: [
          Text(
            'Let\'s Find a Movie!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: SvgPicture.asset(
              brightness == Brightness.dark ? movieNightRed : movieNightBlue,
            ),
          ),
          Button(
            onPressed: call.nextPage,
            text: 'Get Started',
          ),
        ],
      ),
    );
  }
}
