import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget compact;
  final Widget wide;

  const ResponsiveBuilder({
    super.key,
    required this.compact,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return wide;
        }
        return compact;
      },
    );
  }
}