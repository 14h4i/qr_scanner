import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/utils/prefs_key.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListQrBloc extends BlocBase {
  final _listQrCtrl = BehaviorSubject<List<String>?>();
  Stream<List<String>?> get listQrStream =>
      _listQrCtrl.stream.map(transformData);

  Future<void> getListQr() async {
    final prefs = await SharedPreferences.getInstance();
    final listQr = prefs.getStringList(PrefsKey.listQr) ?? [];
    _listQrCtrl.sink.add(listQr);
  }

  List<String> transformData(List<String>? list) {
    if (list == null || list.isEmpty) {
      return [];
    }

    var result = <String>[];

    for (final cmt in list) {
      result = [cmt, ...result];
    }

    return result;
  }

  @override
  void dispose() {
    _listQrCtrl.close();
  }
}
