import 'package:flutter/material.dart';

Future<DateTime?> customDatePicker({required BuildContext context, required DateTime initialDate, required DateTime firstDate, DateTime? lastDate}) async 
{
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colorScheme = Theme.of(context).colorScheme;

  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate ?? DateTime(2100, 12, 31),
    locale: const Locale('es', 'ES'),
    builder: (context, child) 
    {
      return Theme(
        data: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme.copyWith(
            primary: colorScheme.primary,
            onPrimary: Colors.white,
            surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            onSurface: isDark ? Colors.white : Colors.black87,
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            headerBackgroundColor: colorScheme.primary,
            headerForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            todayForegroundColor: WidgetStateProperty.all(colorScheme.primary),
            todayBackgroundColor:
            WidgetStateProperty.all(colorScheme.primary.withValues(alpha: .15)),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) 
            {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return null;
            }),
            dayOverlayColor: WidgetStateProperty.resolveWith((states) 
            {
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.primary.withValues(alpha: .35);
              }

              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary.withValues(alpha: .20);
              }

              if (states.contains(WidgetState.focused)) {
                return Colors.orange.withValues(alpha: .35);
              }

              return null;
            }),
            dayShape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            confirmButtonStyle: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
