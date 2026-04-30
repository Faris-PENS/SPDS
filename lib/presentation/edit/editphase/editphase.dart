import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'provider/provider.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/presentation/main_page/main_page.dart';

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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
            MaterialPageRoute(builder: (_) =>  HomePage()),
          );
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        },
        orElse: () {},
      );
    });

    if (_loadingData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
                const Center(
                  child: Text(
                    "Setting your Device",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                const Text("Device Location", style: TextStyle(color: Colors.white),),
                const SizedBox(height: 10),
                _input(devicelocatuion, "Device Location"),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("MAX AMPS R", style: TextStyle(color: Colors.white),),
                          _input(maxampsR, "R"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("MAX AMPS S", style: TextStyle(color: Colors.white),),
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
                          const Text("MAX AMPS T", style: TextStyle(color: Colors.white),),
                          _input(maxampsT, "T"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("MAX AMPS UPS", style: TextStyle(color: Colors.white),),
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
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("UPDATE"),
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