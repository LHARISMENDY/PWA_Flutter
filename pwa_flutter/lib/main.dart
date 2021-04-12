import 'package:flutter/material.dart';
import 'package:pwa_flutter/modules/scanner/view.dart';
import 'package:pwa_flutter/theme/app_colors.dart';
import 'package:pwa_flutter/theme/app_text_style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Roboto',
      ),
      title: 'QRCode & Barcode Scanner',
      home: MyHomePage(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Let's get Started !",
                    style: AppTextStyle.title,
                  ),
                ),
                Text(
                  'Tap the icon to start scanning\nPlease give access your Camera',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.body,
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      border: Border.all(
                        width: 8,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: IconButton(
                      iconSize: 300,
                      icon: Icon(
                        Icons.flip,
                        color: AppColors.titleColor,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ScannerView(),
                        ),
                      ),
                    ),
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
