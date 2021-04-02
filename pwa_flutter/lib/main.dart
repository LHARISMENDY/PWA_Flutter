import 'package:flutter/material.dart';
import 'package:camcode/cam_code_scanner.dart';

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
                () => openScanner(context),
              ),
            ),
            Text(
              'Code : $scanResult',
            ),
          ],
        ),
      ),
    );
  }

  void openScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CamCodeScanner(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        refreshDelayMillis: 800,
        onBarcodeResult: (barcode) {
          setState(() {
            scanResult = barcode;
            Navigator.pop(context);
          });
        },
      ),
    );
  }
}
