import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/bottomModal.dart';

class ScanMeScreen extends StatefulWidget {
  @override
  _ScanMeScreenState createState() => _ScanMeScreenState();
}

class _ScanMeScreenState extends State<ScanMeScreen> {
  MobileScannerController scannerController = MobileScannerController();
  String? qrText;
  String? member_id = '';
  OwnerLoginAPI? ownerLoginAPI;

  @override
  void initState() {
    super.initState();
    readDataLocally();
    _ensureCameraPermission();
  }

  readDataLocally() async {
    ownerLoginAPI = await OwnerLoginAPI.readDataLocally();
    if (ownerLoginAPI != null && ownerLoginAPI!.participantData != null) {
      setState(() {
        member_id = ownerLoginAPI!.participantData!.memberId.toString();
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _ensureCameraPermission() async {
    var status = await Permission.camera.request();

    if (status.isPermanentlyDenied) {
      await _showPermissionDeniedDialog();
    }
  }

  Future<void> _showPermissionDeniedDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text(
          "To scan QR codes, camera access is required. Please enable it in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: AppThemes.getBackground(),
        elevation: 1,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Container(
          color: Colors.grey[100],
          child: Stack(
            children: [
              MobileScanner(
                controller: scannerController,
                onDetect: (BarcodeCapture barcodeCapture) {
                  final barcode = barcodeCapture.barcodes.first;
                  if (barcode.rawValue != null) {
                    setState(() {
                      qrText = barcode.rawValue;
                      log('QR Text: $qrText anddddd $member_id');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url:
                                'https://sports.forcempower.com/about_details/scan_qr_for_prize.php?player_id=$member_id&prize_id=$qrText',
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
              // Blue corner overlay like Google Pay
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: CustomPaint(
                    painter: BlueCornerPainter(),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/giftbox.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                    url:
                                        'https://sports.forcempower.com/about_details/my_prize_list.php?player_id=$member_id')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'My Prizes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (qrText == null)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Align the QR code within the frame to scan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.flash_on),
                        label: const Text('Toggle Flash'),
                        onPressed: () {
                          scannerController.toggleTorch();
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}

class BlueCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double length = 20;

    // Top-left corner
    canvas.drawLine(Offset(0, 0), Offset(length, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, length), paint);

    // Top-right corner
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - length, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - length), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - length, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - length), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
