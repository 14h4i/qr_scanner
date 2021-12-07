import 'package:qr_scanner/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveQrBloc {
  Future<void> saveQr(String? value) async {
    if (value != null) {
      final prefs = await SharedPreferences.getInstance();
      final listQr = prefs.getStringList(PrefsKey.listQr) ?? [];
      if (!listQr.contains(value)) {
        listQr.add(value);
        prefs.setStringList(PrefsKey.listQr, listQr);
      }
    }
  }
}
