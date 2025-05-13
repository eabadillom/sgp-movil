import 'package:flutter/material.dart';

class SelectorFecha extends StatelessWidget {
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const SelectorFecha({Key? key, required this.onDateRangeChanged})
    : super(key: key);

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      if (isStart) {
        onDateRangeChanged(picked, null);
      } else {
        onDateRangeChanged(null, picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _pickDate(context, true),
          child: const Text("Fecha inicio"),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () => _pickDate(context, false),
          child: const Text("Fecha Final"),
        ),
      ],
    );
  }
}
