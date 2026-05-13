import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/common/message_dialog.dart';
import 'package:spds/presentation/header/header.dart';
import 'package:spds/data/model/topic_mqtt.dart';
import 'package:spds/core/mqtt/mqtt_provider.dart';
import 'provider/provider.dart';

class RenamePage extends ConsumerStatefulWidget {
  final int index;
  final String initialName;
  final int initialType;
  final String initialAsset;
  final String initialLocation;
  final int initialMaxAmps;
  final bool initialCutoff;
  final bool initialPushNotification;

  const RenamePage({
    super.key,
    required this.index,
    required this.initialName,
    required this.initialType,
    required this.initialAsset,
    required this.initialLocation,
    required this.initialMaxAmps,
    required this.initialCutoff,
    required this.initialPushNotification,
  });

  @override
  ConsumerState<RenamePage> createState() => _RenamePageState();
}

class _RenamePageState extends ConsumerState<RenamePage> {
  late TextEditingController nameCtrl;
  late TextEditingController assetCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController maxAmpsCtrl;
  bool autoCutoff = false;
  bool pushNotification = false;
  String? espId;
  late int selectedType;

  final types = const [
    _TypeOption(typeValue: 1, label: 'Lampu'),
    _TypeOption(typeValue: 2, label: 'AC'),
    _TypeOption(typeValue: 3, label: 'Stop Kontak'),
    _TypeOption(typeValue: 4, label: 'Pompa'),
    _TypeOption(typeValue: 5, label: 'Kulkas'),
    _TypeOption(typeValue: 0, label: 'Any'),
  ];

  @override
  void initState() {
    super.initState();
    loadEsp();
    nameCtrl = TextEditingController(text: widget.initialName);
    assetCtrl = TextEditingController(text: widget.initialAsset);
    locationCtrl = TextEditingController(text: widget.initialLocation);
    maxAmpsCtrl = TextEditingController(text: widget.initialMaxAmps.toString());

    selectedType = widget.initialType;
    autoCutoff = widget.initialCutoff;
    pushNotification = widget.initialPushNotification;
  }

  Future<void> loadEsp() async {
    espId = await LocalSession.loadSessiondevice();
    setState(() {});
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    assetCtrl.dispose();
    locationCtrl.dispose();
    maxAmpsCtrl.dispose();

    super.dispose();
  }

  void updateLoad() {
    ref
        .read(loadParam.notifier)
        .updateLoad(
          widget.index + 1,
          selectedType,
          nameCtrl.text.trim(),
          assetCtrl.text.trim(),
          locationCtrl.text.trim(),
          int.tryParse(maxAmpsCtrl.text) ?? widget.initialMaxAmps,
          autoCutoff,
          pushNotification,
        );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget textInput({
    required TextEditingController controller,
    required String hintText,
    TextStyle? hintStyle,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget typeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: types.map((option) {
          final active = selectedType == option.typeValue;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedType = option.typeValue;
              });
            },
            child: Container(
              width: 170,
              height: 45,
              decoration: BoxDecoration(
                color: active ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  option.label,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget updateButton(bool isLoading) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: isLoading ? null : updateLoad,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loadParam);
    final topics = MqttTopics.fromEspId(espId ?? "");
    ref.listen(loadParam, (prev, next) {
      if (prev == next) return;

      next.maybeWhen(
        success: (_) {
          if (!mounted) return;
          ref.read(mqttProvider)?.publish(topics.pubConfig, "update");
          print("published to ${topics.pubConfig}");
          Navigator.pop(context, true);
        },
        error: (e) {
          if (!mounted) return;

          showDialog(
            context: context,
            builder: (_) => ErrorMessageDialog(
              titleText: LocaleKeys.failedToUpdate.tr(),
              contentText: e.toString(),
              onRetry: () {
                Navigator.pop(context);
                // ref.read(loadParam.notifier).updateLoad(
                //   widget.index + 1,
                //   selectedType,
                //   nameCtrl.text,
                //   assetCtrl.text,
                //   locationCtrl.text,
                //   int.tryParse(maxAmpsCtrl.text) ??
                //   widget.initialMaxAmps,
                //   autoCutoff,
                //   pushNotification
                // );
              },
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),

              const SizedBox(height: 20),

              sectionTitle(LocaleKeys.deviceType.tr()),

              const SizedBox(height: 10),

              typeSelector(),

              const SizedBox(height: 20),

              sectionTitle('Max Amps'),

              textInput(
                controller: maxAmpsCtrl,
                hintText: 'Max Amps per Load',
                hintStyle: const TextStyle(color: Colors.white54),
                keyboardType: TextInputType.number,
              ),

              sectionTitle('Max Amps Action'),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: autoCutoff,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                autoCutoff = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Auto cutoff',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: pushNotification,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                pushNotification = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Push Notification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              sectionTitle(LocaleKeys.deviceName.tr()),

              textInput(controller: nameCtrl, hintText: 'Nama Device'),

              sectionTitle(LocaleKeys.assetNumber.tr()),

              textInput(controller: assetCtrl, hintText: 'Asset Number'),

              sectionTitle(LocaleKeys.loadLocation.tr()),

              textInput(controller: locationCtrl, hintText: 'Location'),

              const SizedBox(height: 20),

              updateButton(state.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeOption {
  final int typeValue;
  final String label;

  const _TypeOption({required this.typeValue, required this.label});
}
