import 'package:qr_scanner/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearQrBloc {
  Future<void> clearAllQr() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefsKey.listQr);
  }
}
