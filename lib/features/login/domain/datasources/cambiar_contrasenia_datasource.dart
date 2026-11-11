import 'package:sgp_movil/features/login/domain/domain.dart';

abstract class CambiarContraseniaDatasource 
{
  Future<ControlMovil> cambiarPalabra(String palabra);
}
