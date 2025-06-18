import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? unit;
  final TextEditingController controller;
  final void Function()? onChanged;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.unit,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // ← هنا أضفنا اللون الأبيض للخلفية
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    if (onChanged != null) onChanged!();
                  },
                ),
              ),
              if (unit != null)
                Text(
                  unit!,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
