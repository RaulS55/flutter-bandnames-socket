// ignore_for_file: constant_identifier_names

import 'package:band_names/src/pages/home_page.dart';
import 'package:flutter/widgets.dart';

abstract class Pages {
  static const String INITIAL = Routes.HOME;
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.HOME: (_) => const HomePage(),
  };
}

abstract class Routes {
  static const HOME = "home";
}
