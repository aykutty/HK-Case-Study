import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanPage extends StatelessWidget {
  QrScanPage({super.key});

  final MobileScannerController scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 22, 95),
        title: const Text('QR Okut', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (BarcodeCapture capture) {
          if (capture.barcodes.isEmpty) return;

          final String? code = capture.barcodes.first.rawValue;

          if (code == null || code.isEmpty) return;

          scannerController.stop();

          Get.back(result: code);
        },
      ),
    );
  }
}
