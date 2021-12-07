import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/blocs/app_state_bloc.dart';
import 'package:qr_scanner/providers/bloc_provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AppStateBloc? get appStateBloc => BlocProvider.of<AppStateBloc>(context);
  Barcode? result;
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
                if (result != null)
                  Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                else
                  const Text('Scan a code'),
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
                                child: const Text('Pause',
                                    style: TextStyle(fontSize: 20)),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  await controller?.resumeCamera();
                                  setState(() {
                                    isRun = true;
                                  });
                                },
                                child: const Text('Resume',
                                    style: TextStyle(fontSize: 20)),
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
                                    style: TextStyle(fontSize: 20));
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
                                    style: TextStyle(fontSize: 20),
                                  );
                                } else {
                                  return const Text('Loading');
                                }
                              },
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
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
