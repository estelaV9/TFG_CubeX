import 'package:esteladevega_tfg_cubex/color/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background_intro.jpeg"),
                fit: BoxFit.cover, // AJUSTAR LA IMAGEN AL TAMAÑO DE LA PANTALLA
              ),
            ),
          ),
          Positioned.fill(
              top: 150,
              // SE DEJA UN HUECO DONDE SE VE UN POCO LA PARTE DE ARRIBA
              child: Container(
                decoration: const BoxDecoration(
                  // COLOR DEGRADADO PARA EL FONDO
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, // DESDE ARRIBA
                    end: Alignment.bottomCenter, // HASTA ABAJO
                    colors: [
                      AppColors.upLinearColor, // COLOR DE ARRIBA DEL DEGRADADO
                      AppColors.downLinearColor, // COLOR DE ABAJO DEL DEGRADADO
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontFamily: 'Gluten',
                            fontSize: 70,
                            color: AppColors.lightPurpleColor),
                      ),

                      const SizedBox(height: 10),

                      FieldForm(
                        icon: const Icon(Icons.person),
                        labelText: 'Username or mail',
                        hintText: 'Write your username or mail',
                      ),

                      // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                      const SizedBox(height: 10),

                      FieldForm(
                        icon: const Icon(Icons.lock),
                        labelText: 'Password',
                        hintText: 'Write your password',
                      ),

                      const SizedBox(height: 10),

                      // SE ALIMEA EL TEXTO A LA DERECHA
                      Align(
                          alignment: Alignment.centerRight,
                          // SE USA TEXT BUTTON PARA CUANDO PULSE EL TEXTO HAGA UNA ACCION
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot your password?",
                              style: TextStyle(
                                  color: AppColors.darkPurpleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                color: AppColors.darkPurpleColor),
                          ),
                          const SizedBox(width: 14),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets
                                    .zero, // LE QUITAMOS EL PADDING DE DENTRO DEL BTON
                              ),
                              child: const Icon(Icons.arrow_forward)),
                        ],
                      ),
                      const SizedBox(height: 70),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.darkPurpleColor,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
