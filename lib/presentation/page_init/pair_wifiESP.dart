import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:spds/presentation/common/timer_dialog.dart';
import 'provider/pair_wifi.dart';

import 'package:spds/presentation/page_init/save_device.dart';

class WifiScanPage extends ConsumerStatefulWidget {
  const WifiScanPage({super.key});

  @override
  ConsumerState<WifiScanPage> createState() => _WifiScanPageState();
}

class _WifiScanPageState extends ConsumerState<WifiScanPage> {
  List<WiFiAccessPoint> accessPoints = [];

  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();

  String selectedSSID = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scanWifi();
  }

  List<WiFiAccessPoint> _deduplicate(List<WiFiAccessPoint> results) {
    final Map<String, WiFiAccessPoint> unique = {};

    for (final ap in results) {
      if (ap.ssid.isEmpty) continue;
      if (ap.ssid.toUpperCase().contains("VIXMO")) continue;

      if (!unique.containsKey(ap.ssid) ||
          ap.level > unique[ap.ssid]!.level) {
        unique[ap.ssid] = ap;
      }
    }

    final list = unique.values.toList();
    list.sort((a, b) => b.level.compareTo(a.level));
    return list;
  }

  Future<void> _scanWifi() async {
    setState(() => isLoading = true);

    final can = await WiFiScan.instance.canStartScan();

    if (can == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
      await Future.delayed(const Duration(milliseconds: 600));

      final results = await WiFiScan.instance.getScannedResults();

      setState(() {
        accessPoints = _deduplicate(results);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pairWifiProvider, (prev, next) async {
      next.maybeWhen(
        loading: () {
          AppDialog.showErrorDialog(
            isForover: true,
            durasi: 0,
            context: context, 
            message: "Connecting...",
          );
        },
        success: (_) async {
          if (Navigator.canPop(context)) Navigator.pop(context);

          await AppDialog.showErrorDialog(
            isForover: false,
            durasi: 5,
            context: context,
            message: "Connected!",
            onClosed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => saveDevice(),
                ),
              );
            },
          );
        },
        error: (e) async {
          if (Navigator.canPop(context)) Navigator.pop(context);

          await AppDialog.showErrorDialog(
            isForover: false,
            durasi: 5,
            context: context,
            message: "Failed to connect. Please check your password and try again.",
            // message: e.message,
          );
        },
orElse: () async {},  
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          children: [
              const Text(
                "Please select router Wifi and submit the correct password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),

          Expanded(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : RefreshIndicator(
          onRefresh: _scanWifi,
          child: ListView.builder(
            itemCount: accessPoints.length,
            itemBuilder: (_, i) {
              final wifi = accessPoints[i];
              final isSelected = selectedSSID == wifi.ssid;

              return ListTile(
                trailing: const Icon(Icons.wifi),
                title: Text(wifi.ssid),
                tileColor:
                    isSelected ? Colors.blue.withOpacity(0.5) : null,
                onTap: () {
                  setState(() {
                    selectedSSID = wifi.ssid;
                    ssidController.text = wifi.ssid;
                    passwordController.clear();
                  });

                  FocusScope.of(context)
                      .requestFocus(passwordFocus);
                },
              );
            },
          ),
        ),
),
            TextField(controller: ssidController, readOnly: true),
            const SizedBox(height: 10),
            TextField(controller: passwordController),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ref.read(pairWifiProvider.notifier).pairWifi(
                      ssidController.text,
                      passwordController.text,
                    );
              },
              child: const Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}