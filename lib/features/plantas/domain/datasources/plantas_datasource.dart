import 'package:sgp_movil/features/plantas/domain/domain.dart';

abstract class PlantasDatasource 
{
  Future<List<Planta>> obtenerPlantas();
}
