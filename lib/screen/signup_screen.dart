import 'package:esteladevega_tfg_cubex/color/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                        "Sign Up",
                        style: TextStyle(
                            fontFamily: 'Gluten',
                            fontSize: 70,
                            color: AppColors.lightPurpleColor),
                      ),

                      const SizedBox(height: 10),

                      /*FieldForm(
                        icon: const Icon(Icons.person),
                        labelText: 'Username',
                        hintText: 'Write your username',
                      ),

                      // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                      const SizedBox(height: 10),

                      FieldForm(
                        icon: const Icon(Icons.mail),
                        labelText: 'Mail',
                        hintText: 'Write your mail',
                      ),

                      // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                      const SizedBox(height: 10),

                      FieldForm(
                        icon: const Icon(Icons.lock),
                        labelText: 'Password',
                        hintText: 'Write your password',
                      ),

                      // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                      const SizedBox(height: 10),

                      FieldForm(
                        icon: const Icon(Icons.check),
                        labelText: 'Confirm password',
                        hintText: 'Confirm password',
                      ),*/

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign up",
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
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Log in",
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
