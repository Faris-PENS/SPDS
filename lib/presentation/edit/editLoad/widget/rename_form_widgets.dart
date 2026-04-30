import 'package:flutter/material.dart';

class RenameSectionTitle extends StatelessWidget {
  final String title;
  final Color? color;

  const RenameSectionTitle({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class RenameTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle;

  const RenameTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintStyle: hintStyle,
        ),
      ),
    );
  }
}

class RenameTypeSelector extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int> onTypeChanged;

  const RenameTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          _TypeOption(typeValue: 1, label: 'Lampu'),
          _TypeOption(typeValue: 2, label: 'AC'),
          _TypeOption(typeValue: 3, label: 'Stop Kontak'),
          _TypeOption(typeValue: 4, label: 'Pompa'),
          _TypeOption(typeValue: 5, label: 'Kulkas'),
          _TypeOption(typeValue: 0, label: 'Any'),
        ].map((option) {
          final active = selectedType == option.typeValue;
          return GestureDetector(
            onTap: () => onTypeChanged(option.typeValue),
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
}

class RenameUpdateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RenameUpdateButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
