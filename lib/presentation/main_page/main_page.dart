import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/main_page/provider/share_dev_provider.dart';
import 'package:spds/presentation/main_page/provider/device_provider.dart';
import 'widget/device_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceProvider.notifier).getDevices();
      ref.read(sharedDeviceProvider.notifier).getShared();
    });
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
                "Selamat Datang",
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
                      "Devices",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    SizedBox(height: height * 0.01),

                    SizedBox(
                      height: height * 0.25, 
                      child: deviceState.maybeWhen(
                        loading: () => const Center(
                            child: CircularProgressIndicator()),
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
                            thumbVisibility: true,
                             thumbColor: Colors.white,
                             radius: const Radius.circular(8),
                            child: Padding(padding: 
                            const EdgeInsets.only(right: 12), 
                            child: ListView.builder( 
                              shrinkWrap: true,               
                               itemCount: data.length > 4 ? 4 : data.length,
                              itemBuilder: (context, index) {
                                final d = data[index];
                                return DeviceNum(
                                  name: d['tempat'] ?? '-',
                                  hwid: d['HWID'] ?? '-',
                                  isShared: false,
                                  isSharedDevice: false,
                                  onDeleted: ()  { ref.read(deviceProvider.notifier).getDevices();},
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
                      "Shared Devices",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    SizedBox(height: height * 0.01),

                    SizedBox(
                      height: height * 0.30,
                      child: sharedState.maybeWhen(
                        loading: () => const Center(
                            child: CircularProgressIndicator()),
                        error: (e) => Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                        success: (data) {
                          if (data.isEmpty) {
                            return const Center(
                                child: Text("Tidak ada shared device"));
                          }

                          return RawScrollbar(
                            thumbVisibility: true,
                            thumbColor: Colors.white,
                            child: Padding(padding: 
                            const EdgeInsets.only(right: 12), 
                            child: ListView.builder(
                             shrinkWrap: true,
                             itemCount: data.length > 4 ? 4 : data.length,
                              itemBuilder: (context, index) {
                                final d = data[index];
                                return DeviceNum(
                                  name: d['tempat'] ?? '-',
                                  hwid: d['HWID'] ?? '-',
                                  isShared: false,
                                  isSharedDevice: true,
                                  onDeleted: () async{
                                    await ref.read(sharedDeviceProvider.notifier).getShared();},
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
                vertical: height * 0.08,
              ),
              child: SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("+ Tambahkan Perangkat"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}