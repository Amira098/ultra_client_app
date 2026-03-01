
import 'package:flutter/material.dart';
import 'package:ultra_client/core/routes/routes.dart';
import '../../features/auth1/presentation/view/splash_screen.dart';


import '../../features/home_screen/presentation/view/map_screen.dart';
import 'animation_routes.dart';

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      // case Routes.splashScreen:
      // return AnimationRoute(page:const SplashScreen());
      // case Routes.splashScreen2:
      // return AnimationRoute(page:StartScreen());
      // case Routes.verifiedBadgeAnimatio:
      // return AnimationRoute(page:VerifiedBadgeAnimation());
      // case Routes.homeMapScreen:
      // return AnimationRoute(page:HomeMapScreen());
      // case Routes.verifyCodeScreen:
      //   if (arg is String) {
      //     return AnimationRoute(page: VerifyCodeScreen(phoneNumber: arg));
      //   } else {
      //     return AnimationRoute(page: const UndefinedRoute());
      //   }
      //
      case Routes.onboardingScreen:
      return AnimationRoute(page:SplashScreen());
       case Routes.mainScreen:
      return AnimationRoute(page:MapScreen());

         default:
        return AnimationRoute(page: MapScreen());
    }
  }
}
