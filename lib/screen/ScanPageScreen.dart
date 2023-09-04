import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scan/scan.dart';
import 'package:vialticecmr/screen/AuthScreen.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

class ScanPage extends StatelessWidget {
  ScanController controller = ScanController();
  MyVariables myService = MyVariables();

  ScanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            ScanView(
                controller: controller,
                scanAreaScale: .7,
                scanLineColor: Colors.green,
                onCapture: (data) {
                  controller.pause();
                  var dataJson = json.decode(data);

                  myService.baseUrl(dataJson['url']);
                  myService.baseName(dataJson['base']);
                  SQLHelper.setLastBase(data);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                      (route) => false);
                }),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text("Mode torche"),
                    onPressed: () {
                      controller.toggleTorchMode();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Pause"),
                    onPressed: () {
                      controller.pause();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Reprendre"),
                    onPressed: () {
                      controller.resume();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
