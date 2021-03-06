import 'package:flutter/material.dart';
import 'package:qr_scanner/modules/scanner/blocs/scanner_bloc.dart';
import 'package:qr_scanner/modules/scanner/pages/scanner_page.dart';
import 'package:qr_scanner/modules/welcome/pages/welcome_page.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/route/route_name.dart';

class Routes {
  static Route authorizedRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(
          settings,
          BlocProvider(
            bloc: ScannerBloc()..getListQr,
            child: const ScannerPage(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route unAuthorizedRoute(RouteSettings settings) {
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
