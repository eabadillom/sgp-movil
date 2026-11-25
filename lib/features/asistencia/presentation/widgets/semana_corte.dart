class SemanaCorte 
{
  final DateTime inicio; // viernes 00:00:00.000
  final DateTime fin; // jueves 23:59:59.999

  const SemanaCorte._(this.inicio, this.fin);

  /// Semana de corte (viernes -> jueves) que contiene a [ref].
  factory SemanaCorte.de(DateTime ref) 
  {
    final desdeViernes = (ref.weekday - DateTime.friday + 7) % 7;
    final inicio = DateTime(ref.year, ref.month, ref.day - desdeViernes);
    // Viernes siguiente 00:00 menos 1 ms = jueves 23:59:59.999
    final fin = DateTime(inicio.year, inicio.month, inicio.day + 7).subtract(const Duration(milliseconds: 1));
    return SemanaCorte._(inicio, fin);
  }

  factory SemanaCorte.actual() => SemanaCorte.de(DateTime.now());

  SemanaCorte anterior() => SemanaCorte.de(DateTime(inicio.year, inicio.month, inicio.day - 1));

  SemanaCorte siguiente() => SemanaCorte.de(DateTime(inicio.year, inicio.month, inicio.day + 7));
}