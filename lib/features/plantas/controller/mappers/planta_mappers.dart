import 'package:sgp_movil/features/plantas/domain/domain.dart';

class PlantaMappers 
{
  static Planta jsonToEntity(Map<String, dynamic> json) => Planta(
    id: json['id'] as int,
    descripcion: json['descripcion'] as String,
  );

}
