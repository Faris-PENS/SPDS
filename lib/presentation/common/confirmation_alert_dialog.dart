import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spds/core/gen/locale_keys.g.dart';

enum DialogButtonType { primary, error }

class ConfirmationAlertDialog extends StatelessWidget {
  const ConfirmationAlertDialog({
    super.key,
    required this.title,
    this.description,
    this.cancelText,
    this.confirmText,
    this.buttonColor,
    this.buttonType = DialogButtonType.primary,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String? description;
  final String? confirmText;
  final String? cancelText;
  final Color? buttonColor;
  final DialogButtonType buttonType;
  final Function()? onConfirm;
  final Function()? onCancel;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ]
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                    child: Text(
                      cancelText ?? LocaleKeys.cancel.tr(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buttonType == DialogButtonType.primary
                      ? ElevatedButton(
                          onPressed: onConfirm,
                          child: Text(
                            confirmText ?? LocaleKeys.enter.tr(),
                          ),
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          onPressed: onConfirm,
                          child: Text(
                            confirmText ?? LocaleKeys.confirm.tr(),
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
