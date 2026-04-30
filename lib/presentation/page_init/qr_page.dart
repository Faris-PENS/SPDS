import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/main_page/main_page.dart';
import '../common/message_dialog.dart';
import 'provider/sharedevice.dart';
import 'provider/newdevice.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/presentation/page_init/pair_deviceAP.dart';

class QrScanPage extends ConsumerStatefulWidget {
  final bool isForShareDevice;

  const QrScanPage({super.key, required this.isForShareDevice});

  @override
  ConsumerState<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends ConsumerState<QrScanPage>
    with WidgetsBindingObserver {
  bool _scanned = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.start();
      setState(() => _scanned = false);
    }
  }

  void _resetScan() {
    _controller.start();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _scanned = false);
    });
  }

  Future<void> handletype(String raw) async {
    final lines = raw.split('\n');
    String? hwid;
    String? cc;

    for (final line in lines) {
      if (line.contains('HWID')) {
        hwid = line;
      } else if (line.contains('VIXMO-SPDS')) {
        cc = line;
      }
    }

    print("hwid: $hwid, cc: $cc");

    if (hwid == null || cc == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => ErrorMessageDialog(
          titleText: "Invalid QR Code",
          contentText: "The scanned QR code is not valid for this application.",
          buttonText: "RETRY",
          onRetry: () {
            _resetScan();
             Navigator.pop(context);
          },
        ),
      );
      return;
    }

    if (widget.isForShareDevice) {
      final notifier = ref.read(shareDeviceProvider.notifier);
      await notifier.isRegistered(hwid);
      print(  "hwiwadawdawdawd: $hwid");
      final state = ref.read(shareDeviceProvider);
      await state.maybeWhen(
        success: (_) async {
          await notifier.isShared(hwid!);
          final newState = ref.read(shareDeviceProvider);
          newState.maybeWhen(
            success: (_) {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (_) => ErrorMessageDialog(
                  titleText: "Error",
                  contentText: "Already registed!",
                  buttonText: "RETRY",
                  onRetry: () {
                    _resetScan();
                    Navigator.pop(context);
                  },
                ),
              );
            },
            error: (_) {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (_) => MessageDialog(
                  titleText: "Success",
                  contentText: "Device shared successfully!",
                  buttonText: "OK",
                  showCloseButton: false,
                  onButtonTap: () {
                     _resetScan();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                    
                  },
                ),
              );
            },
            orElse: () => 
            showDialog(
              context: context,
              builder: (_) => ErrorMessageDialog(
                titleText: "Error",
                contentText: "Failed to share device.",
                buttonText: "OK",
                onRetry: () {
                  _resetScan();
                },
              ),
            ),
          );
        },
        error: (_) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (_) => ErrorMessageDialog(
              titleText: "Error",
              contentText: "Device belum didaftarkan.",
              buttonText: "RETRY",
              onRetry: () {
                _resetScan();
                Navigator.pop(context);
              },
            ),
          );
        },
        orElse: () async {},
      );
    }
    else {
        final notifier = ref.read(newDeviceProvider.notifier);
        await notifier.isRegistered(hwid);

        final state = ref.read(newDeviceProvider);
        await state.maybeWhen
        (success: (_) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (_) => ErrorMessageDialog(
              titleText: "Error",
              contentText: "Already registed by another user, please reset your device.",
              buttonText: "RETRY",
              onRetry: () {
                _resetScan();
                Navigator.pop(context);
              },
            ),
          );
        },
        error: (_) {

            if (!mounted) return;
              LocalSession.saveSessiondevice(hwidqr: hwid!);
               Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConnectDevicePage(),
                    ),
                  );
        }, orElse: () async {
          if (!mounted) return;
   
        });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) async {
              if (_scanned) return;

              _scanned = true;
              await _controller.stop();

              final raw = capture.barcodes.isNotEmpty
                  ? capture.barcodes.first.rawValue
                  : null;
              if (raw == null) {
                _resetScan();
                return;
              }
              await handletype(raw);
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Text(
              "Scan QR Code Device",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}