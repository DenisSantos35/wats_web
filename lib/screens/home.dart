import 'package:flutter/material.dart';
import 'package:wats_web/screens/home_mobile.dart';
import 'package:wats_web/screens/home_tablet.dart';
import 'package:wats_web/screens/home_web.dart';
import 'package:wats_web/utils/responsive.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: HomeMobile(),
      web: HomeWeb(),
      tablet: HomeTablet(),
    );
  }
}
