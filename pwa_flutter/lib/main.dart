import 'package:flutter/material.dart';
import 'package:ai_barcode/ai_barcode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PWA Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter PWA'),
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
  ScannerController _scannerController;
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
              iconSize: 50,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.red,
              ),
              onPressed: () => _scannerController.startCamera(),
            ),
            Container(
              color: Colors.black26,
              width: 300,
              height: 300,
              child: PlatformAiBarcodeScannerWidget(
                platformScannerController: _scannerController,
              ),
            ),
            Text(
              _scannerController.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
