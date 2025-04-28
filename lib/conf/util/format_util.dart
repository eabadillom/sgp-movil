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
    // Puedes formatear como quieras, aquí ejemplo simple:
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  static DateTime dateFormated(DateTime fecha)
  {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formatted = formatter.format(fecha);
    DateTime parsed = formatter.parse(formatted);
    return parsed;
  }

}