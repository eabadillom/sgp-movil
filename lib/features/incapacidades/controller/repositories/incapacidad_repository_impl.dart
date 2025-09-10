import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadRepositoryImpl extends IncapacidadRepository
{
  final IncapacidadDatasource datasource;

  IncapacidadRepositoryImpl(this.datasource);

  @override
  Future<List<Incapacidad>> getListIncapacidades(DateTime fechaInicial, DateTime fechaFinal) 
  {
    return datasource.getListIncapacidades(fechaInicial, fechaFinal);
  }
  
}