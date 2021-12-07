import 'package:flutter/material.dart';
import 'package:qr_scanner/blocs/app_state_bloc.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  AppStateBloc? get appStateBloc => BlocProvider.of<AppStateBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _changeAppState,
          )
        ],
      ),
      body: const Center(
        child: Text('Scanner'),
      ),
    );
  }

  void _changeAppState() {
    appStateBloc!.changeAppState(AppState.unAuthorized);
  }
}
