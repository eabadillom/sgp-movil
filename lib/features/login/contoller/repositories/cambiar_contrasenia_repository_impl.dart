import 'package:sgp_movil/features/login/domain/domain.dart';

class CambiarContraseniaRepositoryImpl extends CambiarContraseniaRepository 
{
  final CambiarContraseniaDatasource datasource;

  CambiarContraseniaRepositoryImpl(this.datasource);

  @override
  Future<ControlMovil> cambiarPalabra(String palabra) async 
  {
    return datasource.cambiarPalabra(palabra);
  }
  
}
