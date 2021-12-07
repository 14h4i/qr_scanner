import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/providers/log_provider.dart';
import 'package:qr_scanner/utils/prefs_key.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppState { loading, unAuthorized, authorized }

class AppStateBloc implements BlocBase {
  final _appState = BehaviorSubject<AppState>.seeded(AppState.loading);

  Stream<AppState> get appState => _appState.stream;

  AppState get appStateValue => _appState.stream.value;

  AppState get initState => AppState.loading;

  String langCode = 'en';

  LogProvider get logger => const LogProvider('⚡️ AppStateBloc');

  AppStateBloc() {
    launchApp();
  }

  Future<void> launchApp() async {
    final prefs = await SharedPreferences.getInstance();
    final authorLevel = prefs.getInt(PrefsKey.authorLevel) ?? 0;
    logger.log('authorLevel $authorLevel');
    //langCode = prefs.getString('langCode') ?? 'vi';

    switch (authorLevel) {
      case 2:
        await changeAppState(AppState.authorized);
        break;
      default:
        await changeAppState(AppState.unAuthorized);
    }
  }

  Future<void> changeAppState(AppState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PrefsKey.authorLevel, state.index);
    logger.log('changeAppState $state');

    _appState.sink.add(state);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    await changeAppState(AppState.unAuthorized);
  }

  @override
  void dispose() {
    _appState.close();
  }
}
