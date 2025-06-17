
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';

final usuarioDetalleProvider = StateNotifierProvider<UsuarioDetalleNotifier, UsuarioDetalleState>(
  (ref) => UsuarioDetalleNotifier(),
);

class UsuarioDetalleNotifier extends StateNotifier<UsuarioDetalleState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroDetalleProvider');
  
  UsuarioDetalleNotifier() : super(UsuarioDetalleState.initial());

  void setUsuarioDetalle(UsuarioDetalle detalle) {
    state = state.copyWith(usuarioDetalle: detalle);
  }

  void limpiar() {
    state = UsuarioDetalleState.initial();
  }

}

class UsuarioDetalleState 
{
  final UsuarioDetalle? usuarioDetalle;
  
  UsuarioDetalleState({
    this.usuarioDetalle,
  });

  factory UsuarioDetalleState.initial() => UsuarioDetalleState();

  UsuarioDetalleState copyWith({
    UsuarioDetalle? usuarioDetalle,
  }) {
    return UsuarioDetalleState(
      usuarioDetalle: usuarioDetalle ?? this.usuarioDetalle,
    );
  }
}