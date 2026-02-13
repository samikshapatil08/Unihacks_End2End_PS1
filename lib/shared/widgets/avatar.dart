import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double size;

  const AppAvatar({
    super.key,
    required this.name,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').map((e) => e[0]).take(2).join();
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}