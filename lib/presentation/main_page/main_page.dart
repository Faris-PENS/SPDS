import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/main_page/provider/share_dev_provider.dart';
import 'package:spds/presentation/main_page/provider/device_provider.dart';
import 'widget/device_card.dart';
import 'package:spds/presentation/page_init/init_device.dart';
import 'package:spds/presentation/page_init/qr_page.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:spds/presentation/common/circular_progress_indicator.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _deviceScroll = ScrollController();
  final ScrollController _sharedScroll = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WiFiForIoTPlugin.forceWifiUsage(false);
      ref.read(deviceProvider.notifier).getDevices();
      ref.read(sharedDeviceProvider.notifier).getShared();
    });
  }

  @override
  void dispose() {
    _deviceScroll.dispose();
    _sharedScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceState = ref.watch(deviceProvider);
    final sharedState = ref.watch(sharedDeviceProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: Text(
                LocaleKeys.welcome.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(deviceProvider.notifier).getDevices();
                  await ref.read(sharedDeviceProvider.notifier).getShared();
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  children: [
                    Text(
                      LocaleKeys.device.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: height * 0.01),
                    SizedBox(
                      height: height * 0.25,
                      child: deviceState.maybeWhen(
                        loading: () =>
                            const Center(child: EngganoCircularProgressIndicator()),
                        error: (e) => Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                        success: (data) {
                          if (data.isEmpty) {
                            return const Center(
                                child: Text("Belum ada device"));
                          }

                          return RawScrollbar(
                            controller: _deviceScroll,
                            thumbVisibility: true,
                            thumbColor: Colors.white,
                            radius: const Radius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ListView.builder(
                                controller: _deviceScroll,
                                shrinkWrap: true,
                                itemCount:
                                    data.length > 4 ? 4 : data.length,
                                itemBuilder: (context, index) {
                                  final d = data[index];
                                  return DeviceNum(
                                    name: d['tempat'] ?? '-',
                                    hwid: d['HWID'] ?? '-',
                                    isShared: false,
                                    isSharedDevice: false,
                                    onDeleted: () async {
                                      await ref.read(deviceProvider.notifier).getDevices();
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        orElse: () => const SizedBox(),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      LocaleKeys.sharedDevices.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: height * 0.01),
                    SizedBox(
                      height: height * 0.30,
                      child: sharedState.maybeWhen(
                        loading: () =>
                            const Center(child: EngganoCircularProgressIndicator()),
                        error: (e) => Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                        success: (data) {
                          if (data.isEmpty) {
                            return  Center(
                                child: Text(LocaleKeys.noSharedDevices.tr()));
                          }

                          return RawScrollbar(
                            controller: _sharedScroll,
                            thumbVisibility: true,
                            thumbColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ListView.builder(
                                controller: _sharedScroll,
                                shrinkWrap: true,
                                itemCount:
                                    data.length > 4 ? 4 : data.length,
                                itemBuilder: (context, index) {
                                  final d = data[index];
                                  return DeviceNum(
                                    name: d['tempat'] ?? '-',
                                    hwid: d['HWID'] ?? '-',
                                    isShared: false,
                                    isSharedDevice: true,
                                    onDeleted: () async {
                                      await ref.read(sharedDeviceProvider.notifier).getShared();  },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        orElse: () => const SizedBox(),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.10,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InitPage(isResetWifi: false,)),
                    );
                  },
                  child: Text(
                    LocaleKeys.addNewDevice.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.10,
                vertical: height * 0.02,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const QrScanPage(isForShareDevice: true),
                      ),
                    );
                  },
                  child: Text(
                    LocaleKeys.addNewSharedDevice.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}