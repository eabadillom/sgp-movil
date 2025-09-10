import 'package:logging/logging.dart';

class LoggerSingleton 
{
  final Logger _logger;

  LoggerSingleton._privateConstructor(String nombreLogger)
    : _logger = Logger(nombreLogger);

  static final LoggerSingleton _defaultInstance =
      LoggerSingleton._privateConstructor('ferbo');

  static LoggerSingleton getInstance([String? nombreLogger]) 
  {
    if (nombreLogger != null) {
      return LoggerSingleton._privateConstructor(nombreLogger);
    }
    return _defaultInstance;
  }

  Logger get logger => _logger;

  void setupLoggin() 
  {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((LogRecord rec) 
    {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }

}