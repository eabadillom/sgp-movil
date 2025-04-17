import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_form_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class LoginScreen extends StatelessWidget 
{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                const SizedBox(height: 120),
                // Icon Banner
                Image.asset(
                  'assets/images/login.png',
                  width: 400,
                  height: 200,
                  colorBlendMode: BlendMode.darken,
                ),

                const SizedBox(height: 80),
    
                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget 
{
  const _LoginForm();

  void showSnackbar(BuildContext context, String message)
  {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(loginProvider, (previous, next)
    {
      if(next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);  
    });
    
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Inicia Sesión', style: textStyles.titleLarge ),
          const SizedBox(height: 50),

          CustomTextFormField(
            label: 'Nombre',
            keyboardType: TextInputType.name,
            onChanged: ref.read(loginFormProvider.notifier).onNameChange,
            errorMessage: loginForm.isFormPosted ? loginForm.nombre.errorMessage : null,
          ),
          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            errorMessage: loginForm.isFormPosted ? 
            loginForm.contrasenia.errorMessage : null,
          ),
    
          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.lightBlueAccent,
              onPressed: (){
                ref.read(loginFormProvider.notifier).onFormSubmit();
              },
            )
          ),

          const Spacer(flex: 2),

        ],
      ),
    );
  }
}
