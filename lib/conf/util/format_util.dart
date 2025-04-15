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

}