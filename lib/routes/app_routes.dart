// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
}

// pendeklarasian routes dari masing masing screen
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news-detail';
}