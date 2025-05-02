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

  static DateTime dateFormated(DateTime fecha)
  {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(fecha);
    DateTime parsed = formatter.parse(formatted);
    return parsed;
  }

  static String stringToISO(DateTime fecha)
  {
    String formatter = DateFormat('yyyy-MM-dd').format(fecha);
    return formatter;
  }

  static String stringToStandard(DateTime fecha) 
  {
    String formatter = DateFormat('dd-MM-yyyy').format(fecha);
    return formatter;
  }

}