import 'package:flutter/material.dart';

class KosmoShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const KosmoShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<KosmoShimmer> createState() => _KosmoShimmerState();
}

class _KosmoShimmerState extends State<KosmoShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              Colors.grey.withValues(alpha: 0.15),
              Colors.grey.withValues(alpha: 0.35),
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}
