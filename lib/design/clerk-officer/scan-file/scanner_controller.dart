import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      Get.back(result: {'data': scanData.code});
      controller.dispose();
      // log(scanData.code.toString());
    });
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
