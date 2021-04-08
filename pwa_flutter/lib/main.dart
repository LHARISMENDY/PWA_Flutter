import 'package:flutter/material.dart';
import 'package:pwa_flutter/webcam.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRCode & Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
        title: 'QRCode & Barcode Scanner',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                IconButton(
                  iconSize: MediaQuery.of(context).size.width / 3,
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => WebcamDialog(
                      setScanResult: (result) => setState(
                        () => scanResult = result,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Code : $scanResult',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
