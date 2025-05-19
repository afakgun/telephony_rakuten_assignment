part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ONBOARDING = _Paths.ONBOARDING;
  static const WELCOME = _Paths.WELCOME;
  static const CONFIRMATION = _Paths.CONFIRMATION;
  static const HOME = _Paths.HOME;
  static const YOUTUBE = _Paths.YOUTUBE;
}

abstract class _Paths {
  _Paths._();
  static const ONBOARDING = '/onboarding';
  static const WELCOME = '/welcome';
  static const CONFIRMATION = '/confirmation';
  static const HOME = '/home';
  static const YOUTUBE = '/youtube';
}
