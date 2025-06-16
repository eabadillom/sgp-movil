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

  static String stringToISO2(DateTime fecha) {
    String formatter = DateFormat('yyyy-MM-ddTHH:mm:ss').format(fecha);
    return formatter;
  }

  static String stringToStandard(DateTime fecha) {
    String formatter = DateFormat('dd-MM-yyyy').format(fecha);
    return formatter;
  }

  static String fechaHoy()
  {
    DateTime hoy = DateTime.now();
    String fechaFormateada = DateFormat('EEEE, d MMMM yyyy','es').format(hoy);
    return fechaFormateada;
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

  static String formatearFechaConOffset(DateTime dateTime) {
    Duration fixedOffset = const Duration(hours: -6);
    // Asegura que la hora sea 00:00
    final normalized = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0).subtract(fixedOffset);

    final sign = fixedOffset.isNegative ? '-' : '+';
    final hours = fixedOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (fixedOffset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return '${normalized.toIso8601String().substring(0, 10)}T00:00$sign$hours:$minutes';
  }

  static DateTime formatearFechaStringOffset(String fecha)
  {
    Duration offset = const Duration(hours: -6);

    // Parseamos la fecha "dd-MM-yyyy"
    final partes = fecha.split('-');
    final day = int.parse(partes[0]);
    final month = int.parse(partes[1]);
    final year = int.parse(partes[2]);

    // Creamos fecha UTC y restamos offset para representar 00:00 con ese desfase
    final utcDateTime = DateTime.utc(year, month, day, 0, 0, 0).subtract(offset);
    return utcDateTime;
  }
  
}
