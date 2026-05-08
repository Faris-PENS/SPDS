import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/page_init/provider/newdevice.dart';
import 'package:spds/data/datasource/local/session.dart';
// import 'package:spds/presentation/monitoring_wrapper/wrapper.dart';
import 'package:spds/presentation/main_page/main_page.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/presentation/common/circular_progress_indicator.dart ';


class saveDevice extends ConsumerStatefulWidget {
  const saveDevice({super.key});

  @override
  ConsumerState<saveDevice> createState() => _saveDeviceState();
}



class _saveDeviceState extends ConsumerState<saveDevice> {
  final devicelocatuion = TextEditingController();
  final maxampsR = TextEditingController();
  final maxampsS = TextEditingController();
  final maxampsT = TextEditingController();
  final maxampsUPS = TextEditingController();

  final session = LocalSession.loadSessiondevice();


  Widget _input(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newDeviceProvider);
    ref.listen(newDeviceProvider, (prev, next) {
      if (prev == next) return;
      next.maybeWhen(
        success: (_) {
          if (!mounted) return;
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  HomePage()),
          );
        },
        error: (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${LocaleKeys.failedToRegister.tr()}: $e")),
          );
        },
        orElse: () {},
      );
    
    });
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
                    LocaleKeys.edit.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 20),
                const Text(
                  "Device Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _input(devicelocatuion, "Device Location"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MAX AMPS PHASE R",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsR, "Max Amps Phase R"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MAX AMPS PHASE S",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsS, "Max Amps Phase S"),
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
                          const Text(
                            "MAX AMPS PHASE T",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsT, "Max Amps Phase T"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MAX AMPS UPS",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _input(maxampsUPS, "Max Amps UPS"),
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
                   onPressed: () async {
                   if (state.isLoading) return;

                  final deviceId = await LocalSession.loadSessiondevice();

                    if (deviceId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(LocaleKeys.deviceNotFound.tr())),
                );
                    return;
                  }
                   ref.read(newDeviceProvider.notifier).registerDevices(
                    deviceId,
                    devicelocatuion.text,
                    double.tryParse(maxampsR.text) ?? 0,
                    double.tryParse(maxampsS.text) ?? 0,
                    double.tryParse(maxampsT.text) ?? 0,
                    double.tryParse(maxampsUPS.text) ?? 0,
                );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isLoading ? const EngganoCircularProgressIndicator(color: Colors.white,) 
                    : Text(
                     LocaleKeys.update.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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