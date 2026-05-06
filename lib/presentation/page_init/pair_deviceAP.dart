import 'package:flutter/material.dart';
import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/presentation/page_init/pair_wifiESP.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectDevicePage extends StatefulWidget {
  final bool isResetWifi;
  
  const ConnectDevicePage({super.key, required this.isResetWifi});

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage>
    with WidgetsBindingObserver {
  late String deviceSSID = "";
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHwid();
    cekuserwifi();
  }

    Future<void> _loadHwid() async {
    final getHwid = await LocalSession.loadSessiondevice();
    if (!mounted) return;

    setState(() {
      deviceSSID = "VIXMO-SPDS-$getHwid";
      isLoading = false;
    });
  }

  Future<void> cekuserwifi() async {
    
    final info = NetworkInfo();

    String? wifiName = await info.getWifiName();
    print(  "wifi name: $wifiName");
    if (wifiName == null) {
      setingwifi();
      print("wifi no");
      return;
    }

    wifiName = wifiName.replaceAll('"', '');
    if (wifiName == deviceSSID) {
      if (!mounted) return;
       Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (_) => WifiScanPage(isResetWifi: widget.isResetWifi),
                      ),
                    );
    } else {  
          setingwifi();  
    }
  }

  void setingwifi() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      const intent = AndroidIntent(
        action: 'android.settings.WIFI_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cekuserwifi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // width: ,
          height: 700,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            children: [
            Text(LocaleKeys.pairAP.tr(), textAlign: TextAlign.center, style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Container(height: 1, color: Colors.white),
              const SizedBox(height: 28),
               Text(LocaleKeys.connectAP.tr(),
                textAlign: TextAlign.center,
               style: Theme.of(context).textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      deviceSSID ,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
