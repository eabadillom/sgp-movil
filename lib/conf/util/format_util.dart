import 'package:intl/intl.dart';

class FormatUtil {
  static String humanReadbleNumber(double number) {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(number);

    return formatterNumber;
  }

  static DateTime dateFormated(DateTime fecha) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(fecha);
    DateTime parsed = formatter.parse(formatted);
    return parsed;
  }

  static DateTime stringToDateTime(String fecha)
  {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime fechaFormateada = formatter.parse(fecha);
    return fechaFormateada;
  }

  static String stringToISO(DateTime fecha) {
    String formatter = DateFormat('yyyy-MM-dd').format(fecha);
    return formatter;
  }

  static String stringToStandard(DateTime fecha) {
    String formatter = DateFormat('dd-MM-yyyy').format(fecha);
    return formatter;
  }

  static String formatearFecha(DateTime? fecha) {
    if (fecha == null) return '';
    // Ajustar manualmente a UTC-6
    final fechaZonaHoraria = fecha.toUtc().add(Duration(hours: -6));
    return DateFormat('dd/MM/yyyy - HH:mm:ss').format(fechaZonaHoraria);
  }

  static String formatearFechaSimple(DateTime? fecha) {
    if (fecha == null) return '';
    // Ajustar manualmente a UTC-6
    final fechaZonaHoraria = fecha.toUtc().add(Duration(hours: -6));
    return DateFormat('dd/MM/yyyy').format(fechaZonaHoraria);
  }
  
}
