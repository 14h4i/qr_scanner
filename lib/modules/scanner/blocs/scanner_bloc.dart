import 'package:qr_scanner/modules/scanner/blocs/clear_qr_bloc.dart';
import 'package:qr_scanner/modules/scanner/blocs/list_qr_bloc.dart';
import 'package:qr_scanner/modules/scanner/blocs/save_qr_bloc.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/providers/log_provider.dart';

class ScannerBloc extends BlocBase {
  LogProvider get logger => const LogProvider('⚡️ ScannerBloc');
  final ListQrBloc _listQrBloc;
  final SaveQrBloc _saveQrBloc;
  final ClearQrBloc _clearQrBloc;

  ScannerBloc()
      : _listQrBloc = ListQrBloc(),
        _saveQrBloc = SaveQrBloc(),
        _clearQrBloc = ClearQrBloc();

  Stream<List<String>?> get listQrStream => _listQrBloc.listQrStream;

  Future<void> get getListQr async => _listQrBloc.getListQr();

  Future<void> saveQr(String? value) async {
    await _saveQrBloc.saveQr(value);
    _listQrBloc.getListQr();
  }

  Future<void> clearAllQr() async {
    await _clearQrBloc.clearAllQr();
    _listQrBloc.getListQr();
  }

  @override
  void dispose() {}
}
