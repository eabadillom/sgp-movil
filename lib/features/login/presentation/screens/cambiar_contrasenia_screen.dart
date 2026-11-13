import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class CambiarContraseniaScreen extends ConsumerStatefulWidget 
{
  const CambiarContraseniaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CambiarContraseniaScreen();
}

class _CambiarContraseniaScreen extends ConsumerState<CambiarContraseniaScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() 
  {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  bool get hasValidLength => _passwordController.text.length >= 8 && _passwordController.text.length <= 16;
  bool get hasNoSpaces => !_passwordController.text.contains(RegExp(r'\s'));
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get hasSpecialCharacter => RegExp(r'[,.:\*\+\-#\$%@]').hasMatch(_passwordController.text);
  bool get passwordsMatch => _passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text;
  bool get isPasswordValid => hasValidLength && hasNoSpaces && hasUppercase && hasLowercase && hasNumber && hasSpecialCharacter && passwordsMatch;

  @override
  void dispose() 
  {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async 
  {
    if (!isPasswordValid) {
      return;
    }

    final notifier = ref.read(cambiarContraseniaNotifierProvider.notifier);

    final exito = await notifier.cambiarPalabra(_passwordController.text);

    if (!mounted) {
      return;
    }

    if (!exito) {
      final error = ref.read(cambiarContraseniaNotifierProvider).errorMessage;

      await CustomSnackBarCentrado.mostrar(context, mensaje: error ?? 'Ocurrió un error al cambiar la contraseña.', tipo: SnackbarTipo.error);

      return;
    }

    await CustomSnackBarCentrado.mostrar(context, mensaje: 'Contraseña cambiada correctamente.', tipo: SnackbarTipo.success);

    await ref.read(loginProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) 
  {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            'Cambio de contraseña',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          scrolledUnderElevation: 2,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  const Text(
                    'La contraseña debe cumplir con:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  _passwordRequirement(
                    text: 'Entre 8 y 16 caracteres',
                    isValid: hasValidLength,
                  ),
                  _passwordRequirement(
                    text: 'No debe tener espacios en blanco',
                    isValid: hasNoSpaces,
                  ),
                  _passwordRequirement(
                    text: 'Al menos una letra mayúscula',
                    isValid: hasUppercase,
                  ),
                  _passwordRequirement(
                    text: 'Al menos una letra minúscula',
                    isValid: hasLowercase,
                  ),
                  _passwordRequirement(
                    text: 'Al menos un número',
                    isValid: hasNumber,
                  ),
                  _passwordRequirement(
                    text: 'Al menos un carácter especial: , . : * + - # \$ % @ etc.',
                    isValid: hasSpecialCharacter,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nueva contraseña',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) 
                    {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Ingrese su nueva contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () 
                        {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Confirme contraseña',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onChanged: (_) 
                    {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirme su nueva contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: 
                        [
                          if (_confirmPasswordController.text.isNotEmpty)
                            Icon(
                              passwordsMatch ? Icons.check_circle : Icons.cancel,
                              color: passwordsMatch ? Colors.blue : Colors.blueGrey,
                            ),
                          IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () 
                            {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_confirmPasswordController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: 
                        [
                          Icon(
                            passwordsMatch ? Icons.check_circle : Icons.cancel,
                            size: 18,
                            color: passwordsMatch ? Colors.blue : Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            passwordsMatch ? 'Las contraseñas coinciden' : 'Las contraseñas no coinciden',
                            style: TextStyle(
                              color: passwordsMatch ? Colors.blue : Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isPasswordValid ? _changePassword : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) 
                          {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.grey.shade300;
                            }

                            if (states.contains(WidgetState.pressed)) {
                              return Colors.white;
                            }

                            return Colors.blue;
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) 
                          {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.blueGrey.shade600;
                            }

                            if (states.contains(WidgetState.pressed)) {
                              return Colors.blue;
                            }

                            return Colors.white;
                          },
                        ),
                        side: WidgetStateProperty.resolveWith<BorderSide>((states) 
                        {
                          if (states.contains(WidgetState.pressed)) {
                            return const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            );
                          }

                          return BorderSide.none;
                        }),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        elevation: WidgetStateProperty.resolveWith<double>((states) 
                        {
                          if (states.contains(WidgetState.pressed)) {
                            return 0;
                          }

                          return 2;
                        }),
                      ),
                      child: const Text(
                        'Cambiar contraseña',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

Widget _passwordRequirement({required String text, required bool isValid}) 
{
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 20,
          color: isValid ? Colors.blue : Colors.blueGrey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isValid ? Colors.blue : Colors.blueGrey,
            ),
          ),
        ),
      ],
    ),
  );
}
