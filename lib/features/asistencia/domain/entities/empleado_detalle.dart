import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class EmpleadoDetalle 
{
  final int id;
  final String nombre;
  final String primerAp;
  final String segundoAp;
  final List<RegistroAsistencia> registroAsistencia;

  EmpleadoDetalle({
    required this.id,
    required this.nombre,
    required this.primerAp,
    required this.segundoAp,
    required this.registroAsistencia
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmpleadoDetalle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}