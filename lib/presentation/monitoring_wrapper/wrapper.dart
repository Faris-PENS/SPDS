import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spds/data/datasource/remote/mqtt/mqtt_set_dev.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/presentation/load_page/provider/load_param.dart';
import 'package:spds/presentation/load_page/provider/provider_mqtt.dart';
import 'package:spds/presentation/load_page/provider/provider_database.dart';
import 'package:spds/presentation/header/provider/provider.dart';
import 'package:spds/presentation/current/current_page.dart';
// import 'package:spds/presentation/header/header.dart';
import 'package:spds/presentation/load_page/load_page.dart';
import 'package:spds/presentation/current/provider/provider.dart';
import 'widget/navbar.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  bool _initialized = false;

  late SetDevice setdev;

  @override
  void initState() {
    super.initState();

    setdev = SetDevice(ref);

    _initMain();
  }

  Future<void> _initMain() async {
    if (_initialized) return;

    await ref.read(loadDatabaseProvider.notifier).fetch();

    final esp = await LocalSession.loadSessiondevice();
    if (esp == null) {
      debugPrint("MQTT: no device");
      return;
    }

    final clientid = await LocalSession.loadSessionuser();
    if (clientid == null) {
      debugPrint("MQTT: no user session");
      return;
    }

    await setdev.setdev(
      hwid: esp,
      clientid: clientid,
      isReset: () {
        debugPrint("RESET CALLED");
        ref.read(loadProvider.notifier).reset();
        ref.read(loadControlProvider.notifier).reset();
        ref.read(modeProvider.notifier).reset();
        ref.read(statusProvider.notifier).reset();
        ref.read(phaseCurrentProvider.notifier).reset();
        ref.read(balanceableProvider.notifier).reset();
      },
    );

    _initialized = true;
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [LoadPage(), CurrentPage()], // Add CurrentPage() to the children list
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        page: 1,
      ),
    );
  }
}
