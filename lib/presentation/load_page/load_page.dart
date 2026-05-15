import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/mqtt/mqtt_provider.dart';
import 'package:spds/data/model/all_data.dart';
import 'package:spds/data/model/topic_mqtt.dart';
import 'package:spds/presentation/header/provider/provider.dart';
import 'package:spds/presentation/load_page/provider/load_param.dart';
import 'package:spds/presentation/load_page/widget/load_card.dart';
import 'package:spds/presentation/load_page/provider/provider_mqtt.dart';
import 'package:spds/presentation/load_page/provider/provider_database.dart';
import 'package:spds/presentation/header/header.dart';
import 'package:spds/presentation/edit/editLoad/edit_page.dart';

class LoadPage extends ConsumerStatefulWidget {
  const LoadPage({super.key});

  @override
  ConsumerState<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends ConsumerState<LoadPage> {
  ProviderSubscription<List<LoadParam>>? _loadSubscription;

  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();

    _loadSubscription = ref.listenManual<List<LoadParam>>(loadProvider, (
      _,
      next,
    ) {
      // if (_userInteracting) return;
      ref.read(loadControlProvider.notifier).syncFromMqtt(next);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _loadSubscription?.close();
    super.dispose();
  }

  void _publishPhase(int load, String phase) {
    final mqtt = ref.read(mqttProvider);
    final esp = ref.read(currentEspProvider);

    if (mqtt == null || esp == null || esp.isEmpty) return;

    final topics = MqttTopics.fromEspId(esp);

    _userInteracting = true;
    mqtt.publish(topics.pubPhase, '{"load": $load, "phase": "$phase"}');

    Future.delayed(const Duration(milliseconds: 2000), () {
      _userInteracting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loads = ref.watch(loadCardProvider);
    final controls = ref.watch(loadControlProvider);
    final status = ref.watch(statusProvider);
    final mode = ref.watch(modeProvider);
    final isConnected = (status?.status ?? 0) == 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: loads.length,
              itemBuilder: (context, i) {
                final item = loads[i];
                final control = controls.firstWhere(
                  (e) => e.load == i,
                  orElse: () => LoadControlState(load: i),
                );
                final controlNotifier = ref.read(loadControlProvider.notifier);
                final loadNotifier = ref.read(loadProvider.notifier);

                final isManual = (mode?.mode ?? 0) == 1;

                final canChangePhase = isConnected && isManual;

                final canToggle = canChangePhase && control.selectedPhase != null;

                return LoadCard(
                  subtit: item.name,
                  assetNum: item.assetNum,
                  deviceType: item.type,
                  location: item.location,
                  isOn: control.isSendEnabled,
                  isActive: canToggle,
                  activePhase: control.selectedPhase ?? item.phase,
                  arus: item.arus,
                  maxAmps: item.maxAmps,
                  onToggle: canToggle
                      ? (v) {
                          controlNotifier.setSendEnabled(i, v);

                          if (v) {
                            final selected = control.selectedPhase;

                            if (selected == null || selected == 'N') {
                              controlNotifier.setSendEnabled(i, false);
                              return;
                            }

                            _publishPhase(i + 1, selected);
                            loadNotifier.update(i, phase: selected);
                            return;
                          }

                          _publishPhase(i + 1, 'N');
                          loadNotifier.update(i, clearPhase: true);
                        }
                      : (_) {},

                  // onPhaseChanged: (p) {
                  //   final nextPhase = p.toUpperCase();
                  //   final currentPhase = control.selectedPhase?.toUpperCase();

                  //   if (nextPhase == currentPhase) return;

                  //   controlNotifier.setPhase(i, nextPhase);

                  //   _publishPhase(i + 1, 'N');
                  //   loadNotifier.update(i, clearPhase: true);
                  // },
                  onPhaseChanged: canChangePhase
                      ? (p) {
                          final nextPhase = p.toUpperCase();
                          final currentPhase = control.selectedPhase
                              ?.toUpperCase();

                          if (nextPhase == currentPhase) return;

                          if (control.isSendEnabled &&
                              currentPhase != null &&
                              currentPhase != 'N') {
                            _publishPhase(i + 1, 'N');
                            controlNotifier.setSendEnabled(i, false);
                            loadNotifier.update(i, clearPhase: true);
                          }

                          controlNotifier.setPhase(i, nextPhase);
                        }
                      : (_) {},

                  onRename: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RenamePage(
                          index: i,
                          initialType: item.type,
                          initialName: item.name,
                          initialAsset: item.assetNum,
                          initialLocation: item.location,
                          initialMaxAmps: item.maxAmps,
                          initialCutoff: item.cutoff,
                          initialPushNotification: item.pushNotification,
                        ),
                      ),
                    );

                    if (updated == true) {
                      await ref.read(loadDatabaseProvider.notifier).fetch();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
