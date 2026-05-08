import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:spds/data/datasource/remote/supabase/device_supabase.dart';
import 'package:spds/data/datasource/remote/supabase/share_dev_supabase.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:spds/presentation/monitoring_wrapper/wrapper.dart';
// import 'package:kp_spds/presentation/home_page/providers/homePage.dart';
import 'package:spds/presentation/common/custom_widget_dialog.dart';
// import 'package:kp_spds/presentation/main_page/main_page.dart';

import 'package:spds/presentation/edit/editphase/editphase.dart';
import 'package:spds/presentation/common/confirmation_alert_dialog.dart';

class DeviceNum extends ConsumerWidget {
  final String name;
  final String hwid;
  final VoidCallback onDeleted;
  final bool isShared;
  final bool isSharedDevice;

  const DeviceNum({
    super.key,
    required this.name,
    required this.hwid,
    required this.isShared,
    required this.isSharedDevice,
    required this.onDeleted,
  });

  void _selectDevice(BuildContext context) async {
    await LocalSession.saveSessiondevice(hwidqr: hwid);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

void _showQR(BuildContext context) {
  final qrData = "$hwid\nVIXMO-SPDS";

  showDialog(
    context: context,
    builder: (_) => CustomDialog(
      title: "Share Device QR",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: QrImageView(
              data: qrData,
              backgroundColor: Colors.white,
              // foregroundColor: Colors.white,
              version: QrVersions.auto,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hwid,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}


  // Future<void> _deleteDevice(
  //     BuildContext context, WidgetRef ref) async {
  //   final confirm = await showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(LocaleKeys.delete.tr()),
  //       content: Text(
  //        LocaleKeys.disconnectDevice.tr()
         
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text(LocaleKeys.cancel.tr()),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(context, true),
  //             // await ref.read(deviceProvider.notifier).getDevices();
                 
  //           child: Text(LocaleKeys.delete.tr()),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirm != true) return;

  //   try {
  //     if (isSharedDevice) {
  //       await SharedevSupabase().deleteSharedDevice(hwid: hwid);
  //     } else {
  //       await DeviceSupabase().deleteHWID(userdevice: hwid);
  //     }      

  //     if (!context.mounted) return;

  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text(LocaleKeys.success.tr())),
  //     // );

  //     onDeleted(); 
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }



   Future<void> _deleteDevices(
      BuildContext context, WidgetRef ref) async {
      showDialog(
      context: context,
      builder: (context) => ConfirmationAlertDialog(
        title: LocaleKeys.areYouSureYouWantTo.tr(args: [
          LocaleKeys.delete.tr(
            args: [LocaleKeys.device.tr()],
          ),
        ]),
        description: LocaleKeys.deleteDevivedesc.tr(),
        onConfirm: () async {
          Navigator.pop(context);
          try {
            if (isSharedDevice) {
              await SharedevSupabase().deleteSharedDevice(hwid: hwid);
            } else {
              await DeviceSupabase().deleteHWID(userdevice: hwid);
            }
          onDeleted(); 
            if (!context.mounted) return;

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(LocaleKeys.success.tr())),
            // );

            
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _selectDevice(context),
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.memory, color: Colors.white, size: 30),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hwid,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            if (!isSharedDevice) ...[
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 30),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Editphase(deviceId: hwid),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code, color: Colors.white, size: 30),
                onPressed: () => _showQR(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                onPressed: () => _deleteDevices(context, ref),
              ),
            ] else
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                onPressed: () => _deleteDevices(context, ref),
              ),
          ],
        ),
      ),
    );
  }
}