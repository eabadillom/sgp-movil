import 'package:intl/intl.dart';

class FormatUtil 
{
  static String humanReadbleNumber(double number) 
  {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format( number );

    return formatterNumber;
  }

  static String formatearFecha(DateTime fecha) 
  {
    return '${fecha.year}-${fecha.month}-${fecha.day}';
  }

  static DateTime dateFormated(DateTime fecha)
  {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(fecha);
    DateTime parsed = formatter.parse(formatted);
    return parsed;
  }

  static String stringDateFormated(DateTime fecha)
  {
    String formatter = DateFormat('yyyy-MM-dd').format(fecha);
    //String formatted = formatter.format(fecha);
    //DateTime parsed = formatter.parse(formatted);
    return formatter;
  }

}