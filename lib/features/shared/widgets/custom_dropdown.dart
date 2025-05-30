import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget 
{
  final List<T> items;
  final T? value;
  final String label;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T)? iconBuilder;
  final IconData Function(T)? iconDataBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.label,
    required this.itemLabelBuilder,
    this.iconBuilder,
    this.iconDataBuilder,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      value: value,
      isExpanded: true,
      items: items.map((item) {
        final Widget iconWidget;

        if (iconBuilder != null) {
          iconWidget = iconBuilder!(item);
        } else if (iconDataBuilder != null) {
          iconWidget = Icon(iconDataBuilder!(item), size: 16, color: Colors.blue);
        } else {
          iconWidget = const SizedBox.shrink(); // por si no se pasó ningún ícono
        }

        return DropdownMenuItem<T>(
          value: item,
          child: Row(
            children: [
              iconWidget,
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  itemLabelBuilder(item),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
