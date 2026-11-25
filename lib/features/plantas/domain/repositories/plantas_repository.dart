import 'package:sgp_movil/features/plantas/domain/domain.dart';

abstract class PlantasRepository 
{
  Future<List<Planta>> obtenerPlantas();
}
