import 'package:flutter/material.dart';

class AuthFormCard extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AuthFormCard({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: child,
          ),
        ),
      ),
    );
  }
}
