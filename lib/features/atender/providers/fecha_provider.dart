import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/format_util.dart';

final fechaInicialProvider = StateProvider<DateTime>((ref) {
  DateTime fechaIni;
  fechaIni = FormatUtil.dateFormated(
    DateTime.now().subtract(const Duration(days: 15)),
  );
  return fechaIni;
});

final fechaFinalProvider = StateProvider<DateTime>((ref) {
  DateTime fechaFin;
  fechaFin = FormatUtil.dateFormated(
    DateTime.now().add(const Duration(days: 1)),
  );
  return fechaFin;
});
