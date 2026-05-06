import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/presentation/header/header.dart';
import 'provider/provider.dart';
import 'widget/rename_form_widgets.dart';
import '../../common/message_dialog.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RenamePage extends ConsumerStatefulWidget {
  final int index;
  final String initialName;
  final int initialType; 
  final String initialAsset;
  final String initialLocation;
  final int initialMaxAmps;
  const RenamePage({
    super.key,
    required this.index,
    required this.initialName,
    required this.initialType,
    required this.initialAsset,
    required this.initialLocation,
    required this.initialMaxAmps,
  });

  @override
  ConsumerState<RenamePage> createState() => _RenamePageState();
}

class _RenamePageState extends ConsumerState<RenamePage> {
  late TextEditingController nameCtrl;
  late TextEditingController assetCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController maxAmpsCtrl;

  late int selectedType;


  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.initialName);
    assetCtrl = TextEditingController(text: widget.initialAsset);
    locationCtrl = TextEditingController(text: widget.initialLocation);
    maxAmpsCtrl = TextEditingController(text: widget.initialMaxAmps.toString());
    selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loadParam);
    final ctrl = ref.read(loadParam.notifier);
    ref.listen(loadParam, (prev, next) {
      if (prev == next) return;

      next.maybeWhen(
        success: (_) {
          if (!mounted) return;
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
                ctrl.updateLoad(
                  widget.index + 1,
                  selectedType,
                  nameCtrl.text,
                  assetCtrl.text,
                  locationCtrl.text,
                  int.tryParse(maxAmpsCtrl.text) ?? widget.initialMaxAmps,
                );
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

           RenameSectionTitle(
            title: LocaleKeys.deviceType.tr(),
            color: Colors.white,
          ),

          const SizedBox(height: 10),

          RenameTypeSelector(
            selectedType: selectedType,
            onTypeChanged: (type) => setState(() => selectedType = type),
          ),

          const SizedBox(height: 20),

          const RenameSectionTitle(
            title: 'Max Amps',
            color: Colors.white,
          ),

          RenameTextInput(
            controller: maxAmpsCtrl,
            hintText: 'Max Amps per Load',
            hintStyle: const TextStyle(color: Colors.white54),
          ),

           RenameSectionTitle(
            title: LocaleKeys.deviceName.tr(),
            color: Colors.white,
          ),

          RenameTextInput(
            controller: nameCtrl,
            hintText: 'Nama device',
          ),

           RenameSectionTitle(
            title: LocaleKeys.assetNumber.tr(),
            color: Colors.white,
          ),

          RenameTextInput(
            controller: assetCtrl,
            hintText: 'Asset Number',
          ),

           RenameSectionTitle(
            title: LocaleKeys.loadLocation.tr(),
            color: Colors.white,
          ),

          RenameTextInput(
            controller: locationCtrl,
            hintText: 'Location',
          ),

          const SizedBox(height: 20),

         Center(
  child: RenameUpdateButton(
    isLoading: state.isLoading,
    onPressed: () {
      ctrl.updateLoad(
        widget.index + 1,
        selectedType,
        nameCtrl.text,
        assetCtrl.text,
        locationCtrl.text,
        int.tryParse(maxAmpsCtrl.text) ?? widget.initialMaxAmps,
      );
    },
  ),
),
        ],
      ),
    ),
  ),
);
  }
}