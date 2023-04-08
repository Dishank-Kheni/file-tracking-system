import 'package:flutter/material.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scanner_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerView extends GetWidget<ScannerController> {
  const ScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: controller.qrKey,
        onQRViewCreated: controller.onQRViewCreated,
      ),
    );
  }
}
