import 'package:flutter/material.dart';
import 'package:practice_assignment/data/pet_service_data.dart';
import 'package:practice_assignment/presentation/screens/home_screen.dart';
import 'package:practice_assignment/presentation/screens/service_listing_screen.dart';
import 'package:practice_assignment/presentation/screens/splash_screen.dart';
import '../../presentation/screens/pet_centre_detail_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case RoutesName.serviceListingScreen:
        final args = settings.arguments;
        if (args is Map<String, dynamic> && args.containsKey('category')) {
          final category = args['category'] as String;
          return MaterialPageRoute(builder: (_) => ServiceListingScreen(category: category));
        } else {
          return _errorRoute('Invalid arguments for ${settings.name}');
        }

      case RoutesName.petdetailScreen:
        final args = settings.arguments;
        if (args is Map<String, dynamic> && args.containsKey('centerData')) {
          final centerData = args['centerData'] as PetService;
          return MaterialPageRoute(builder: (_) => PetCenterDetailScreen(centerData: centerData));
        } else {
          return _errorRoute('Invalid arguments for ${settings.name}');
        }

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
