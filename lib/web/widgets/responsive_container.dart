import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool usePadding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1000,
    this.usePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: usePadding ? AppSpacing.l : 0,
          ),
          child: child,
        ),
      ),
    );
  }
}