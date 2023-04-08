import 'dart:ui';

import 'package:flutter/material.dart';

class BgBlur extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  const BgBlur({
    Key? key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
          tileMode: TileMode.mirror,
        ),
        child: child,
      ),
    );
  }
}
