import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_scanner/blocs/app_state_bloc.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/route/route_name.dart';
import 'package:qr_scanner/route/routes.dart';
import 'package:qr_scanner/src/settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appStateBloc = AppStateBloc();
  static final GlobalKey<State> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: appStateBloc,
      child: StreamBuilder<AppState>(
        stream: appStateBloc.appState,
        initialData: appStateBloc.initState,
        builder: (context, snapshot) {
          if (snapshot.data == AppState.loading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Container(
                color: Colors.white,
              ),
            );
          }
          if (snapshot.data == AppState.unAuthorized) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: RouteName.welcomePage,
              key: const ValueKey('UnAuthorized'),
              themeMode: ThemeMode.light,
              onGenerateRoute: Routes.unAuthorizedRoute,
              builder: _builder,
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            key: key,
            themeMode: ThemeMode.light,
            onGenerateRoute: Routes.authorizedRoute,
            builder: _builder,
            navigatorKey: MyApp.navigatorKey,
          );
        },
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    final data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: 1),
      child: child!,
    );
  }
}
