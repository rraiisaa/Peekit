// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const NEWS_SCREEN = _Paths.NEWS_SCREEN;
  static const NOTIFICATION_SCREEN = _Paths.NOTIFICATION_SCREEN;
  static const SEARCH_SCREEN = _Paths.SEARCH_SCREEN;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
}

// pendeklarasian routes dari masing masing screen
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const NEWS_SCREEN = '/news-screen';
  static const NOTIFICATION_SCREEN = '/notification-screen';
  static const SEARCH_SCREEN = '/search';
  static const NEWS_DETAIL = '/news-detail';
}