import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:provider/provider.dart';
import '../../data/database/database_helper.dart';
import '../../viewmodel/current_user.dart';
import '../components/Icon/icon.dart';
import '../components/password_field_row.dart';
import '../../utilities/internationalization.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _password = ''; // ATRIBUTO PARA GUARDAR LA CONTRASEÑA
  UserDao userDao = UserDao();

  void deleteUser() async {
    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    bool isDelete = await userDao.deleteUser(idUser);

    if (isDelete) {
      // SI SE ELIMINA CORRECTAMENTE MUESTRA UN MENSAJE Y SE CIERRA LA SESION
      AlertUtil.showSnackBarInformation(context, "delete_user_successfully");
      // CIERRA LA SESION Y VA A LA PANTALLA DEL LOGIN
      ChangeScreen.changeScreen(const LoginScreen(), context);
    } else {
      // SI HAY UN ERROR SE MUESTRA UN MENSAJE
      AlertUtil.showSnackBarInformation(context, "delete_user_error");
    } // VALIDA SI SE ELIMINA CORRECTAMENTE EL USUARIO
  } // METODO PARA ELIMINAR EL USUARIO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Internationalization.internationalization
            .getLocalizations(context, "my_profile")),
        backgroundColor: AppColors.lightVioletColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          // COLOR DEGRADADO PARA EL FONDO
          gradient: LinearGradient(
            begin: Alignment.topCenter, // DESDE ARRIBA
            end: Alignment.bottomCenter, // HASTA ABAJO
            colors: [
              // COLOR DE ARRIBA DEL DEGRADADO
              AppColors.upLinearColor,
              // COLOR DE ABAJO DEL DEGRADADO
              AppColors.downLinearColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  // EL ICONO DEL PINCEL ESTARA EN LA ESQUINA DE ABAJO A LA DERECHA
                  alignment: Alignment.bottomRight,
                  children: [
                    // IMAGEN DEL USUARIO
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: AppColors.imagenBg,
                      child: Image.asset("assets/default_user_image.png"),
                    ),

                    // ICONO PARA EDITAR
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 18,
                          // FONDO BLACNO DEL ICONO
                          backgroundColor: Colors.white,
                          child: IconClass.iconMaker(
                              context, Icons.edit, "edit_button"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconClass.iconMaker(
                      context, Icons.save, "save_data", 30)),
              const SizedBox(height: 10),
              Form(
                  child: Column(children: [
                FieldForm(
                    icon:
                        IconClass.iconMaker(context, Icons.person, "username"),
                    labelText: Internationalization.internationalization
                        .getLocalizations(context, "username"),
                    hintText: Internationalization.internationalization
                        .getLocalizations(context, "username_hint"),
                    controller: _usernameController,
                    validator: (value) => Validator.validateUsername(value),
                    labelSemantics: Internationalization.internationalization
                        .getLocalizations(context, "username_label"),
                    hintSemantics: Internationalization.internationalization
                        .getLocalizations(context, "username_hint"),
                    borderSize: 15,
                    colorBox: AppColors.purpleIntroColor),

                // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                const SizedBox(height: 10),

                FieldForm(
                    icon: IconClass.iconMaker(context, Icons.mail, "mail"),
                    labelText: Internationalization.internationalization
                        .getLocalizations(context, "mail"),
                    hintText: Internationalization.internationalization
                        .getLocalizations(context, "mail_hint"),
                    controller: _mailController,
                    validator: (value) => Validator.validateEmail(value),
                    labelSemantics: Internationalization.internationalization
                        .getLocalizations(context, "mail_label"),
                    hintSemantics: Internationalization.internationalization
                        .getLocalizations(context, "mail_hint"),
                    borderSize: 15,
                    colorBox: AppColors.purpleIntroColor),

                // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                const SizedBox(height: 10),

                PasswordFieldForm(
                    icon: IconClass.iconMaker(context, Icons.lock, "password"),
                    labelText: Internationalization.internationalization
                        .getLocalizations(context, "password"),
                    hintText: Internationalization.internationalization
                        .getLocalizations(context, "password_hint"),
                    controller: _passwordController,
                    validator: (value) => Validator.validatePassword(value),
                    passwordOnSaved: (value) => _password = value!,
                    labelSemantics: Internationalization.internationalization
                        .getLocalizations(context, "password_label"),
                    hintSemantics: Internationalization.internationalization
                        .getLocalizations(context, "password_hint"),
                    borderSize: 15,
                    colorBox: AppColors.purpleIntroColor),

                // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                const SizedBox(height: 10),

                PasswordFieldForm(
                    icon: IconClass.iconMaker(
                        context, Icons.check, "confirm_password"),
                    labelText: Internationalization.internationalization
                        .getLocalizations(context, "confirm_password"),
                    hintText: Internationalization.internationalization
                        .getLocalizations(context, "confirm_password_hint"),
                    controller: _confirmPasswordController,
                    validator: (value) => Validator.validateConfirmPassword(
                        value, _passwordController.text),
                    passwordOnSaved: (value) => _password = value!,
                    labelSemantics: Internationalization.internationalization
                        .getLocalizations(context, "confirm_password_label"),
                    hintSemantics: Internationalization.internationalization
                        .getLocalizations(context, "confirm_password_hint"),
                    borderSize: 15,
                    colorBox: AppColors.purpleIntroColor),
              ])),

              // COLOCAMOS UN EXPANDED PARA OCUPAR EL ESPACIO RESSTANTE Y
              // COLOCAR EL BOTON DE DELETE ACCOUN ABAJO DELTODO
              Expanded(child: Container()),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.deleteAccount,
                      borderRadius: BorderRadius.circular(15),

                      // AÑADIMOS EL EFECTO DE "drop shadow"
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          // COLOR DE LA SOMBRA
                          spreadRadius: 2,
                          // LARGURA DE LA SOMBRA
                          blurRadius: 5,
                          // EFECTO BLUR DE LA SOMBRA
                          // DONDE SE VA A COLOCAR HORIZONTAL Y VERTICALMENTE
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: deleteUser,
                        child: Row(
                          children: [
                            IconClass.iconMaker(
                                context, Icons.delete, "delete_account"),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Delete account",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.darkPurpleColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
