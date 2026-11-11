import 'package:sgp_movil/features/login/domain/domain.dart';

abstract class CambiarContraseniaRepository 
{
  Future<ControlMovil> cambiarPalabra(String palabra);
}
