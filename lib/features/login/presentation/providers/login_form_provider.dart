import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

//! 1 - State del provider
class LoginFormState
{
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final NumeroEmpleado numeroEmpleado;
  final Nombre nombre;
  final Contrasenia contrasenia;

  LoginFormState
  ({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.numeroEmpleado = const NumeroEmpleado.pure(),
    this.nombre = const Nombre.pure(),
    this.contrasenia = const Contrasenia.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    NumeroEmpleado? numeroEmpleado,
    Nombre? nombre,
    Contrasenia? contrasenia,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    numeroEmpleado: numeroEmpleado ?? this.numeroEmpleado,
    nombre: nombre ?? this.nombre,
    contrasenia: contrasenia ?? this.contrasenia,
  );

  @override
  String toString() 
  {
    return '''
    LoginFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      numeroEmpleado: $numeroEmpleado
      nombre: $nombre
      contrasenia: $contrasenia
    ''';
  }
}

//! 2 - Como imlementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> 
{
  final Function(String, String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback
  }): super(LoginFormState());

  onNumeroEmpleadoChange(String value)
  {
    final newNumeroEmpleado = NumeroEmpleado.dirty(value);
    state = state.copyWith(
      numeroEmpleado: newNumeroEmpleado,
      isValid: Formz.validate([newNumeroEmpleado, state.numeroEmpleado])
    );
  }

  onNameChange(String value){
    final newNombre = Nombre.dirty(value);
    state = state.copyWith(
      nombre: newNombre,
      isValid: Formz.validate([newNombre, state.nombre])
    );
  }

  onPasswordChange(String value){
    final newContrasenia = Contrasenia.dirty(value);
    state = state.copyWith(
      contrasenia: newContrasenia,
      isValid: Formz.validate([newContrasenia, state.contrasenia])
    );
  }
  
  onFormSubmit() async
  {
    _touchEveryField();

    if(!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(state.numeroEmpleado.value, state.nombre.value, state.contrasenia.value);

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField()
  {
    final nombre = Nombre.dirty(state.nombre.value);
    final contrasenia = Contrasenia.dirty(state.contrasenia.value);
    final numeroEmpleado = NumeroEmpleado.dirty(state.numeroEmpleado.value);

    state = state.copyWith(
      isFormPosted: true,
      numeroEmpleado: numeroEmpleado,
      nombre: nombre,
      contrasenia: contrasenia,
      isValid: Formz.validate([numeroEmpleado, nombre, contrasenia]) 
    );
  }
}

//! 3 - SateNotifierProvider - consume afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref)
{
  final loginUserCallback = ref.watch(loginProvider.notifier).loginUser;
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  ); 
});
