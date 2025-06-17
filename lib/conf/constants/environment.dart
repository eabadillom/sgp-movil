import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sgp_movil/conf/constants/context.dart';

class Environment 
{
  static final List<Context> contexts = [
    Context(name: 'SGP', context: 'sgp'),
    Context(name: 'Movil', context: 'sgp-api/movil'),
  ];

  static String baseURL = dotenv.env['HOST'] ?? 'No está configurado el API_URL';

  static initEnvironmet () async{
    await dotenv.load(fileName: ".env");
  }

  static String obtenerUrlPorNombre(String nombre) 
  {
    final ctx = contexts.firstWhere(
      (c) => c.name == nombre,
      orElse: () => throw ArgumentError('Nombre de contexto no válido'),
    );
    return "$baseURL/${ctx.context}";
  }
}
