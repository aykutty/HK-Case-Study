import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController scannerController = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

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
          if (_scanned || capture.barcodes.isEmpty) return;

          final String? code = capture.barcodes.first.rawValue;

          if (code == null || code.isEmpty) return;

          _scanned = true;
          scannerController.stop();

          Get.back(result: code);
        },
      ),
    );
  }
}
