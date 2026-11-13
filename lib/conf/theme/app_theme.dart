import 'package:flutter/material.dart';

const colorSeed = Color.fromARGB(255, 118, 211, 248);
const scaffoldBackgroundColor = Color(0xFFF3F6F2);
const _darkSurfaceColor = Color(0xFF1B2722);
const _accentColor = Color(0xFFE47755);

const colorList = <Color>[
  colorSeed,
  Color(0xFF176B58),
  Color(0xFFB84F37),
  Color(0xFF597845),
  Color(0xFF386A82),
  Color(0xFF9A6A32),
  Color(0xFF765273),
  Color(0xFF3F5550),
  Color(0xDFD5D3DB),
];

class AppTheme 
{
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({this.selectedColor = 0, this.isDarkmode = false})
    : assert(selectedColor >= 0, 'Selected color must ber greater then 0'),
      assert(selectedColor < colorList.length, 'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme() 
  {
    const Color azulClaroApp = Color.fromARGB(255, 0, 174, 255);
    const Color azulMedioOscuro = Color.fromARGB(255, 62, 140, 228);
    final brightness = isDarkmode ? Brightness.dark : Brightness.light;
    final surface = isDarkmode ? _darkSurfaceColor : Colors.white;
    final colors = ColorScheme.fromSeed(seedColor: colorSeed, brightness: brightness, surface: surface).copyWith(secondary: _accentColor);
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
      scaffoldBackgroundColor: isDarkmode ? const Color(0xFF121212) : scaffoldBackgroundColor,
      
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontFamily: "MontserratAlternates",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkmode ? azulMedioOscuro : azulClaroApp,
        foregroundColor: colors.onSurface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'MontserratAlternates',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Configuración de Botones
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontFamily: "MontserratAlternates",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  AppTheme copyWith({int? selectedColor, bool? isDarkmode}) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );

  Color get selectedColorValue => colorList[selectedColor];

}
