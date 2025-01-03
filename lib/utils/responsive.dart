import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const Responsive(
      {super.key, required this.mobile, required this.web, this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1200) {
        return web;
      } else if (constraints.maxWidth >= 800) {
        Widget? resTablet = tablet;
        if (resTablet != null) {
          return resTablet;
        } else {
          return web;
        }
      } else {
        return mobile;
      }
    });
  }
}
