import 'package:flutter/material.dart';
import 'package:qr_scanner/blocs/app_state_bloc.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  AppStateBloc? get appStateBloc => BlocProvider.of<AppStateBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to\nQR Scanner App',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
          IconButton(
            highlightColor: Colors.blue,
            icon: const Icon(Icons.arrow_forward),
            onPressed: _changeAppState,
          ),
        ],
      ),
    );
  }

  void _changeAppState() {
    appStateBloc!.changeAppState(AppState.authorized);
  }
}
