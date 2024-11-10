import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gig_buddy/src/route/router.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      settingsController.themeMode == Brightness.dark
          ? 'assets/svg/logo/logo.svg'
          : 'assets/svg/logo/logo_light.svg',
      height: 84,
      colorFilter: Brightness.dark == Theme.of(context).brightness
          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
          : null,
    );
  }
}
