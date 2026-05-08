import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:spds/presentation/common/timer_dialog.dart';
import 'provider/pair_wifi.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/presentation/page_init/save_device.dart';
import 'package:spds/presentation/main_page/main_page.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:spds/presentation/common/loading_dialog.dart';
import 'package:spds/presentation/common/circular_progress_indicator.dart';

class WifiScanPage extends ConsumerStatefulWidget {
  final bool isResetWifi; 
  const WifiScanPage({super.key, required this.isResetWifi});

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
     WiFiForIoTPlugin.forceWifiUsage(true);
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
        loading: () async {
          
          //  TimerDialog.timerdialog(
            
          //   durasi: 0,
          //   context: context, 
          //   message: LocaleKeys.connecting.tr(),
          // );
        },
        success: (_) async {
          if (Navigator.canPop(context)) Navigator.pop(context);
             await WiFiForIoTPlugin.forceWifiUsage(false);
          await TimerDialog.timerdialog(
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            durasi: 5,
            context: context,
            message: LocaleKeys.connected.tr(),
            onClosed: () {
           
              Navigator.pushReplacement(
                context,
                widget.isResetWifi
                    ? MaterialPageRoute(builder: (_) => HomePage())
                    :
                MaterialPageRoute(
                  builder: (_) => saveDevice(),
                ),
              );
            },
          );
        },
        error: (e) async {
          if (Navigator.canPop(context)) Navigator.pop(context);

          await TimerDialog.timerdialog(
            icon: Icons.error_outline,
            iconColor: Colors.red,
            durasi: 5,
            context: context,
            message: LocaleKeys.failedConnectWifi.tr(),
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
               Text(
                  LocaleKeys.connectWifi.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),

          Expanded(
  child: isLoading
      ? const Center(child: EngganoCircularProgressIndicator())
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
              child:  Text(LocaleKeys.connect.tr()),
            ),
          ],
        ),
      ),
    );
  }
}