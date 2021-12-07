import 'package:flutter/material.dart';
import 'package:qr_scanner/modules/scanner/pages/scanner_page.dart';
import 'package:qr_scanner/modules/welcome/pages/welcome_page.dart';
import 'package:qr_scanner/route/route_name.dart';

class Routes {
  static Route authorizedRoute(RouteSettings settings) {
    print(settings.name);

    switch (settings.name) {
      case '/':
        return _buildRoute(
          settings,
          const ScannerPage(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route unAuthorizedRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case '/':
        return _buildRoute(
          settings,
          const WelcomePage(),
        );
      case RouteName.welcomePage:
        return _buildRoute(
          settings,
          const WelcomePage(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Coming soon'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}
