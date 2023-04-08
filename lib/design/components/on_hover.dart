import 'package:flutter/material.dart';

class OnHover extends StatefulWidget {
  final void Function()? onTap;
  final Widget Function(bool isHovered, void Function(bool) onHover) builder;
  const OnHover({Key? key, required this.builder, this.onTap})
      : super(key: key);
  @override
  OnHoverState createState() => OnHoverState();
}

class OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: FocusableActionDetector(
        mouseCursor: isHovered && widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: onHover,
        child: widget.builder(isHovered, onHover),
      ),
    );
  }

  void onHover(onHover) {
    setState(() {
      isHovered = onHover;
    });
  }
}
