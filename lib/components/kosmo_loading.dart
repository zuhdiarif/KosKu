import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';

class KosmoLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const KosmoLoading({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? KosmoTheme.primary,
        ),
      ),
    );
  }
}
