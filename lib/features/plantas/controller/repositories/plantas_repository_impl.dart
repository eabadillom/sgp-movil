import 'package:sgp_movil/features/plantas/domain/domain.dart';

class PlantasRepositoryImpl extends PlantasRepository
{
  final PlantasDatasource datasource;

  PlantasRepositoryImpl(this.datasource);

  @override
  Future<List<Planta>> obtenerPlantas() 
  {
    return datasource.obtenerPlantas();
  }

}