import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwa_flutter/web_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner QRCode & Barcode',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
        title: 'Scanner QRCode & Barcode',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scanResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            IconButton(
              iconSize: MediaQuery.of(context).size.width / 3,
              icon: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.red,
              ),
              onPressed: () => setState(
                () => _scanCode(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Code : '),
                OutlinedButton(
                  child: Text(
                    '$scanResult',
                  ),
                  onPressed:
                      scanResult.isNotEmpty && scanResult.contains('https')
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebScreen(scanResult),
                                ),
                              )
                          : () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _scanCode() async {
    try {
      String scanResult = await BarcodeScanner.scan();
      setState(
        () => this.scanResult = scanResult,
      );
    } on PlatformException catch (error) {
      if (error.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.scanResult =
              'Votre appareil n\'a pas autorisé l\'accés à la caméra';
        });
      } else {
        setState(
          () => this.scanResult = 'Error: $error',
        );
      }
    }
  }
}
