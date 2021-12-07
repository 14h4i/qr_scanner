import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/blocs/app_state_bloc.dart';
import 'package:qr_scanner/modules/scanner/blocs/scanner_bloc.dart';
import 'package:qr_scanner/modules/scanner/widgets/qr_card.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';
import 'package:qr_scanner/providers/log_provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AppStateBloc? get appStateBloc => BlocProvider.of<AppStateBloc>(context);
  ScannerBloc? get scannerBloc => BlocProvider.of<ScannerBloc>(context);
  LogProvider get logger => const LogProvider('⚡️ QR Scanner');
  QRViewController? controller;
  late bool isRun;

  @override
  void initState() {
    super.initState();

    isRun = false;
  }

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
      body: Column(
        children: [
          Expanded(flex: 1, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: isRun
                            ? ElevatedButton(
                                onPressed: () async {
                                  await controller?.pauseCamera();
                                  setState(() {
                                    isRun = false;
                                  });
                                },
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  await controller?.resumeCamera();
                                  setState(() {
                                    isRun = true;
                                  });
                                },
                                child: const Text(
                                  'Start',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data != true
                                      ? 'On Flash'
                                      : 'Off Flash',
                                  style: const TextStyle(fontSize: 18),
                                );
                              },
                            )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    describeEnum(snapshot.data!) == 'back'
                                        ? 'To Front'
                                        : 'To Back',
                                    style: const TextStyle(fontSize: 18),
                                  );
                                } else {
                                  return const Text('Loading');
                                }
                              },
                            )),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: StreamBuilder<List<String>?>(
                    stream: scannerBloc!.listQrStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Some Error'),
                        );
                      }
                      if (snapshot.hasData) {
                        final listQr = snapshot.data;
                        return ListView.builder(
                            itemCount: listQr!.length,
                            itemBuilder: (context, index) {
                              return QrCard(value: listQr[index]);
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: scannerBloc!.clearAllQr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.pauseCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      scannerBloc!.saveQr(scanData.code);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    logger.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _changeAppState() {
    appStateBloc!.changeAppState(AppState.unAuthorized);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
