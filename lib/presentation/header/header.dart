import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'provider/provider.dart';
import 'package:spds/data/model/all_data.dart';
import 'package:spds/data/model/topic_mqtt.dart';
import 'package:spds/core/mqtt/mqtt_provider.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({super.key});

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  String? esp;

  @override
  void initState() {
    super.initState();
    loadEsp();
    debugPrint("INIT STATE JALAN");
  }

  Future<void> loadEsp() async {
    esp = await LocalSession.loadSessiondevice();
    setState(() {});
  }

  bool get isConnected {
    final status = ref.read(statusProvider);
    return (status?.status ?? 0) == 1;
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeProvider);
    final statusProv = ref.watch(statusProvider);

    final isAuto = (mode?.mode ?? 0) == 1;
    final status = statusProv?.status ?? 0;

    final mqtt = ref.read(mqttProvider);

    final topics = MqttTopics.fromEspId(esp ?? "");

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          bottom: 12,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white, width: 0.5),
          ),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VIXMO 3 PHASE-$esp",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status == 1 ? "CONNECTED" : "DISCONNECTED",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              IgnorePointer(
                ignoring: !isConnected,
                child: Opacity(
                  opacity: isConnected ? 1.0 : 0.4,
                  child: GestureDetector(
                    onTap: isConnected
                        ? () {
                            final newMode = isAuto ? 0 : 1;

                            ref
                                .read(modeProvider.notifier)
                                .update(ModeData(newMode));

                            mqtt?.publish(
                              topics.pubMode,
                              '{"MODE": $newMode}',
                            );
                          }
                        : null,
                    child: Container(
                      height: 36,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAuto ? "MANUAL" : "AUTO",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}