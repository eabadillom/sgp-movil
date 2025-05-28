import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color.fromARGB(255, 247, 247, 248);

const Color _customColor = Color( 0xFF5C11D4 ); 
const colorList = <Color> [
  _customColor,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.green,
  Colors.orange,
  Colors.pink,
  Colors.white,
];

class AppTheme 
{
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = false,
  }): assert (selectedColor >= 0, 'Selected color must ber greater then 0'), 
      assert (selectedColor < colorList.length, 'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme() => ThemeData(
    ///* General
    useMaterial3: true,
    brightness: isDarkmode ? Brightness.dark : Brightness.light,
    colorSchemeSeed: colorSeed,

    ///* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith(fontSize: 20)
    ),

    ///* Scaffold Background Color
    scaffoldBackgroundColor: isDarkmode ? const Color(0xFF121212) : scaffoldBackgroundColor,
    
    ///* Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          )
      )
    ),

    ///* AppBar
    appBarTheme: AppBarTheme(
      color: isDarkmode ? const Color(0xFF1F1F1F) : scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.montserratAlternates()
        .copyWith(fontSize: 25, fontWeight: FontWeight.bold, color: isDarkmode ? Colors.white : Colors.black),
      iconTheme: IconThemeData(
        color: isDarkmode ? Colors.white : Colors.black,
      ),
    )
  );

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkmode,
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );

}
