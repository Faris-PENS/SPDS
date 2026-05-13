import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'provider/provider.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/presentation/main_page/main_page.dart';
import 'package:spds/presentation/page_init/init_device.dart';
import 'package:spds/presentation/common/circular_progress_indicator.dart';

class Editphase extends ConsumerStatefulWidget {
  final String deviceId;

  const Editphase({super.key, required this.deviceId});

  @override
  ConsumerState<Editphase> createState() => _EditphaseState();
}

class _EditphaseState extends ConsumerState<Editphase> {
  final devicelocatuion = TextEditingController();
  final maxampsR = TextEditingController();
  final maxampsS = TextEditingController();
  final maxampsT = TextEditingController();
  final maxampsUPS = TextEditingController();

  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    LocalSession.saveSessiondevice(hwidqr: widget.deviceId);

    final data = await ref.read(updateProvider.notifier).fetchDevice();

    if (data != null) {
      devicelocatuion.text = data['tempat'] ?? '';
      maxampsR.text = (data['ampsR'] ?? '').toString();
      maxampsS.text = (data['ampsS'] ?? '').toString();
      maxampsT.text = (data['ampsT'] ?? '').toString();
      maxampsUPS.text = (data['ampsU'] ?? '').toString();
    }

    setState(() {
      _loadingData = false;
    });
  }

  Widget _input(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
        // filled: true,
        // fillColor: Colors.grey.shade200,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateProvider);

    ref.listen(updateProvider, (prev, next) {
      next.maybeWhen(
        success: (_) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        },
        error: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
        },
        orElse: () {
          print("aaaa");
        },
      );
    });

    if (_loadingData) {
      return const Scaffold(
        body: Center(child: EngganoCircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    LocaleKeys.settingsYourDevice.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                Text(
                  LocaleKeys.deviceLocation.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _input(devicelocatuion, LocaleKeys.deviceLocation.tr()),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAX AMPS R",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsR, "R"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAX AMPS S",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsS, "S"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAX AMPS T",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsT, "T"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAX AMPS UPS",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsUPS, "UPS"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InitPage(isResetWifi: true),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.changeWifi.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await ref
                                .read(updateProvider.notifier)
                                .editphase(
                                  widget.deviceId,
                                  devicelocatuion.text,
                                  double.tryParse(maxampsR.text) ?? 0,
                                  double.tryParse(maxampsS.text) ?? 0,
                                  double.tryParse(maxampsT.text) ?? 0,
                                  double.tryParse(maxampsUPS.text) ?? 0,
                                );
                          },
                    child: state.isLoading
                        ? const EngganoCircularProgressIndicator()
                        : Text(LocaleKeys.update.tr(), style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
