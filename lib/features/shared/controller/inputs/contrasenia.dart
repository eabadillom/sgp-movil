import 'package:formz/formz.dart';

// Define input validation errors
enum ContraseniaError {empty}

// Extend FormzInput and provide the input type and error type.
class Contrasenia extends FormzInput<String, ContraseniaError> 
{
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const Contrasenia.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Contrasenia.dirty(super.value) : super.dirty();

  String? get errorMessage 
  {
    if(isValid || isPure) return null;

    if(displayError == ContraseniaError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ContraseniaError? validator(String value) 
  {
    if (value.isEmpty || value.trim().isEmpty) return ContraseniaError.empty;

    return null;
  }
}