import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_form_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

final LoggerSingleton log = LoggerSingleton.getInstance('LoginScreen');

class LoginScreen extends StatefulWidget 
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver
{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    context.read<NotificationsBloc>().add(RequestNotificationPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationsBloc>().add(RequestNotificationPermission());
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return BlocListener<NotificationsBloc, NotificationsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) 
      {
        log.logger.info('Estado de notificación: ${state.status}');
        if(state.status == AuthorizationStatus.denied) 
        {
          CustomSnackBarCentrado.mostrar(
            context,
            mensaje: 'Permiso de notificaciones denegado',
            tipo: SnackbarTipo.error,
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: GeometricalBackground(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),
                  Image.asset(
                    'assets/images/login.png',
                    width: 400,
                    height: 200,
                    colorBlendMode: BlendMode.darken,
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: size.height - 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: const _LoginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget 
{
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(loginProvider, (previous, next)
    {
      if(next.errorMessage.isEmpty) return;
      CustomSnackBarCentrado.mostrar(
        context,
        mensaje: next.errorMessage,
        tipo: SnackbarTipo.error,
      );
    });
    
    final textStyles = Theme.of(context).textTheme;

    final authStatus = context.select((NotificationsBloc bloc) => bloc.state.status);
    final permisoDenegado = authStatus == AuthorizationStatus.denied;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Inicia Sesión', style: textStyles.titleLarge ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Num. Empleado',
            keyboardType: TextInputType.name,
            onChanged: ref.read(loginFormProvider.notifier).onNumeroEmpleadoChange,
            errorMessage: loginForm.isFormPosted ? loginForm.numeroEmpleado.errorMessage : null,
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Usuario',
            keyboardType: TextInputType.name,
            onChanged: ref.read(loginFormProvider.notifier).onNameChange,
            errorMessage: loginForm.isFormPosted ? loginForm.nombre.errorMessage : null,
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            errorMessage: loginForm.isFormPosted ? 
            loginForm.contrasenia.errorMessage : null,
          ),
    
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: permisoDenegado ? 'Permiso requeridos' : 'Ingresar',
              buttonColor: permisoDenegado ? Colors.grey : Colors.lightBlueAccent,
              onPressed: permisoDenegado? () 
              {
                CustomSnackBarCentrado.mostrar(
                  context,
                  mensaje: 'Debes permitir notificaciones para ingresar.',
                  tipo: SnackbarTipo.error,
                );
              } : () {
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
