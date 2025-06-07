import 'package:flutter/material.dart';

class ScrollIfOverflowText extends StatefulWidget {
  const ScrollIfOverflowText({
    required this.text,
    super.key,
    this.style,
    this.duration = const Duration(seconds: 3),
  });

  final String text;
  final TextStyle? style;
  final Duration duration;

  @override
  State<ScrollIfOverflowText> createState() => _ScrollIfOverflowTextState();
}

class _ScrollIfOverflowTextState extends State<ScrollIfOverflowText> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollIfNeeded());
  }

  void scrollIfNeeded() {
    final maxScroll = scrollController.position.maxScrollExtent;
    if (maxScroll > 0) {
      scrollController.animateTo(
        maxScroll,
        duration: widget.duration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );
  }
}
