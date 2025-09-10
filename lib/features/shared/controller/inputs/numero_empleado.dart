import 'package:formz/formz.dart';

// Define input validation errors
enum NumeroEmpleadoError {empty}

// Extend FormzInput and provide the input type and error type.
class NumeroEmpleado extends FormzInput<String, NumeroEmpleadoError>
{
  // Call super.pure to represent an unmodified form input.
  const NumeroEmpleado.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const NumeroEmpleado.dirty(super.value) : super.dirty();

  String? get errorMessage 
  {
    if(isValid || isPure) return null;

    if(displayError == NumeroEmpleadoError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  NumeroEmpleadoError? validator(String value) 
  {
    if(value.isEmpty || value.trim().isEmpty) return NumeroEmpleadoError.empty;

    return null;
  }

}