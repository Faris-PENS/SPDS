import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:spds/core/gen/assets.gen.dart';

class MessageDialog extends StatelessWidget {
  final String? titleText;
  final String? contentText;
  final ImageProvider? imageProvider;
  final String? buttonText;
  final String? secondButtonText;
  final bool showCloseButton;
  final bool showSecondButton;
  final VoidCallback? onButtonTap;
  final VoidCallback? onSecondButtonTap;

  const MessageDialog({
    super.key,
    this.titleText,
    this.contentText,
    this.imageProvider,
    this.buttonText,
    this.secondButtonText,
    this.showCloseButton = false,
    this.showSecondButton = false,
    this.onButtonTap,
    this.onSecondButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child: Image(
                    image:
                        imageProvider ?? Assets.images.successful.image().image,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleText ?? "succes",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 20,
                                ),
                      ),
                      if (contentText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          contentText!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          if (showSecondButton) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onSecondButtonTap,
                                child: Text(
                                  secondButtonText ??
                                      LocaleKeys.helpCenter.tr(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: onButtonTap ??
                                  () {
                                    Navigator.of(context).pop();
                                  },
                              child: Text(
                                buttonText ?? LocaleKeys.goIt.tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showCloseButton)
            Positioned(
              top: 20,
              left: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.close),
              ),
            ),
        ],
      ),
    );
  }
}

class ErrorMessageDialog extends StatelessWidget {
  final String? titleText;
  final String? contentText;
  final ImageProvider? imageProvider;
  final String? buttonText;
  final String? secondButtonText;
  final bool showSecondButton;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondButtonTap;

  const ErrorMessageDialog({
    super.key,
    this.titleText,
    this.contentText,
    this.imageProvider,
    this.buttonText,
    this.secondButtonText,
    this.showSecondButton = false,
    this.onRetry,
    this.onSecondButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      titleText: titleText,
      contentText: contentText,
      buttonText: buttonText ?? LocaleKeys.retry.tr(),
      imageProvider: imageProvider ?? Assets.images.failed.image().image,
      showCloseButton: false,
      onButtonTap: onRetry,
      secondButtonText: secondButtonText,
      showSecondButton: showSecondButton,
      onSecondButtonTap: onSecondButtonTap,
    );
  }
}
