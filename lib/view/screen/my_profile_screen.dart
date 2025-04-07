import 'dart:io';

import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/validator.dart';
import 'package:provider/provider.dart';
import '../../data/database/database_helper.dart';
import '../../model/gallery_service.dart';
import '../../viewmodel/current_user.dart';
import '../components/Icon/icon.dart';
import '../components/password_field_row.dart';
import '../utilities/app_styles.dart';
import '../utilities/encrypt_password.dart';
import '../utilities/internationalization.dart';

/// Pantalla de perfil del usuario.
///
/// Esta pantalla permite visualizar y modificar los datos del usuario actual,
/// como el nombre de usuario, la contraseña y la imagen de perfil.
/// También proporciona la opción de eliminar la cuenta.
///
/// ### Características:
/// - **Visualización y edición del perfil:** Permite al usuario cambiar su nombre,
///   contraseña e imagen de perfil.
/// - **Validaciones en los formularios:** Se valida el nombre de usuario y la contraseña.
/// - **Confirmación antes de guardar cambios:** Se requiere la contraseña actual
///   para confirmar modificaciones.
/// - **Eliminación de cuenta:** Se ofrece la opción de borrar el usuario de la base de datos.
///
/// ### Métodos principales:
/// - `_getImageUrl()`: Obtiene la URL de la imagen de perfil del usuario desde la base de datos.
/// - `saveUser()`: Guarda los cambios realizados en la cuenta del usuario.
/// - `deleteUser()`: Elimina la cuenta del usuario y lo redirige a la pantalla de inicio de sesión.
/// - `_onWillPopScope()`: Controla la acción de retroceso para evitar la pérdida de cambios.
///
/// ### Diseño:
/// - **Imagen de perfil:** Se muestra como un `CircleAvatar` y permite cambiarla.
/// - **Campos de texto:** Incluyen el nombre de usuario, la contraseña y la confirmación de contraseña.
/// - **Botón de guardar:** Se encuentra en la parte superior derecha.
/// - **Botón de eliminar cuenta:** Se muestra en la parte inferior.
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _password = ''; // ATRIBUTO PARA GUARDAR LA CONTRASEÑA
  UserDao userDao = UserDao();

  String? photoPath;

  // LA URL DE LA IMAGEN DEL USUARIO, QUE SE INICIALIZA CON LA IMAGEN POR DEFECTO
  String imageUrl = "assets/default_user_image.png";

  // ATRIBUTO PARA SABER SI HA PULSADO EL BOTON DE GUARDAR
  bool _isDataSaved = false;

  // ATRIBUTO PARA SABER SI HA CAMBIADO LA FOTO
  bool _isPhotoUpdate = false;

  /// Método para eliminar el usuario.
  ///
  /// Este método obtiene el usuario actual desde el `CurrentUser`,
  /// luego elimina su cuenta de la base de datos y redirige a la pantalla de login.
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

  /// Método para guardar los cambios de la información del usuario.
  ///
  /// Este método actualiza los datos del usuario, como nombre de usuario, contraseña
  /// e imagen de perfil, verificando primero la autenticación con la contraseña actual.
  ///
  /// ### Proceso de actualización:
  /// 1. Obtiene el usuario actual desde el contexto y su ID del usuario desde la base de datos.
  /// 3. Verifica si el nuevo nombre de usuario ya está en uso.
  /// 4. Valida el formulario antes de proceder con la actualización.
  /// 5. Solicita la contraseña actual como confirmación antes de guardar los cambios.
  /// 6. Crea un nuevo objeto `User` con los datos actualizados.
  /// 7. Actualiza el usuario en la base de datos y en el estado global de la aplicación.
  /// 8. Muestra un mensaje de éxito o error según el resultado de la actualización.
  ///
  /// ### Validaciones:
  /// - Si el nombre de usuario ya existe y no es el mismo que el actual, muestra un error.
  /// - Si el formulario no es válido, no se procede con la actualización.
  /// - Si no hay cambios en la imagen, se mantiene la anterior.
  void saveUser() async {
    String newName = _usernameController.text;
    String newPassword = _passwordController.text;

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;

    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    if (newName.isNotEmpty &&
        await userDao.isExistsUsername(newName) && newName != currentUser.username) {
      AlertUtil.showSnackBarError(context, "username_already_in_use");
      return;
    } // VALIDAR SI EL NOMBRE YA ESTA EN USO Y QUE NO ESTE VACIO EL CAMPO

    if (formKey.currentState!.validate()) {
      // PARA GUARDAR LOS DATOS DEBERA PONER SU ANTIGUA CONTRASEÑA
      bool? isConfirmed = await AlertUtil.showConfirmWithOldPass(
          context, "insert_old_pass", "old_pass", currentUser);
      if (!isConfirmed!) {
        DatabaseHelper.logger.e("Actualizacion cancelada por el usuario.");
        return;
      } // SI SE CANCELO, MUESTRA UN MENSAJE

      // CREAR NUEVO USUARIO CON LOS DATOS QUE SE HAN ACTUALIZADOS
      User newUserData = User(
        username: newName.isNotEmpty ? newName : currentUser.username,
        mail: "",
        password: newPassword.isNotEmpty
            ? EncryptPassword.encryptPassword(newPassword)
            : currentUser.password,
        imageUrl: _isPhotoUpdate ? photoPath : currentUser.imageUrl,
      );

      // ACTUALIZAR EL USUARIO ACTUAL
      context.read<CurrentUser>().setUser(newUserData);

      if (await userDao.updateUserInfo(newUserData, idUser)) {
        AlertUtil.showSnackBarInformation(context, "update_user_successfully");
      } else {
        AlertUtil.showSnackBarError(context, "update_user_error");
      } // SE VERIFICA SI SE HA ACTUALIZADO CORRECTAMENTE LA INFORMACION
    } // VALIDAR QUE EL FORMULARIO ESTA CORRECTAMENTE
  } // METODO PARA ACTUALIZAR USUARIO

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CUANDO SE INICIA, SE ESTABLECE LA FOTO
    _getImageUrl();
  }

  /// Método privado para obtener la URL de la imagen de perfil del usuario actual.
  ///
  /// Este método recupera la imagen de perfil del usuario desde la base de datos
  /// y la asigna a la variable `imageUrl` si no es nula.
  ///
  /// Procedimiento:
  /// - Obtiene el usuario actual desde el contexto y ecupera el ID con su nombre.
  /// - Si el ID es válido, busca la URL de la imagen en la base de datos.
  /// - Si la imagen no es nula, actualiza el estado con la nueva URL.
  void _getImageUrl() async {
    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    String? image = await userDao.getImageUser(idUser);
    if (image != null) {
      setState(() {
        // SE ASIGNA EL VALOR DE LA URL DE LA IMAGEN
        imageUrl = image;
      });
    } // SI NO ES NULA, SE ASIGNA EL VALOR
  } // METODO PARA OBTENER LA IMAGEN ACTUAL DEL USUARIO


  /// Maneja la acción de la fecha de back en la pantalla de edición de perfil.
  ///
  /// Este método se ejecuta cuando el usuario intenta salir de la pantalla.
  /// Verifica si hay cambios sin guardar y, en caso de haberlos, muestra un
  /// cuadro de diálogo de confirmación.
  ///
  /// Se usa en el `WillPopScope` para controlar la navegación con el botón de retroceso.
  ///
  /// ### Reglas de validación:
  /// - Si no se ha actualizado la foto y todos los campos de entrada (nombre de usuario,
  ///   contraseña y confirmación de contraseña) están vacíos, se considera que los datos
  ///   están guardados (`_isDataSaved = true`).
  /// - Si `_isDataSaved` es `false`, muestra un diálogo de confirmación para advertir
  ///   sobre la salida sin guardar cambios.
  ///
  /// Retorna `true` para permite salir de la pantalla y `false` para bloquea la salida si el usuario cancela el diálogo.
  Future<bool> _onWillPopScope() async {
    if (!_isPhotoUpdate &&
        (_usernameController.text.isEmpty &&
            _passwordController.text.isEmpty &&
            _confirmPasswordController.text.isEmpty)) {
      // SI NO SE HA CAMBIADO NADA, SE ESTABLECE COMO QUE LO HA "GUARDADO"
      _isDataSaved = true;
    } // VERIFICAR SI SE HA CAMBIADO ALGO
    if (!_isDataSaved) {
      AlertUtil.showExitConfirmationDialog(
          context, "exit_without_saving", "unsaved_changes_message");
    }
    // SALE DIRECTAMENTE SI LOS DATOS ESTAN GUARDADOS
    return true;
  } // METODO PARA CUANDO EL USUARIO QUIERA SALIR DE ESTA PANTALLA

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // LLAMAMOS AL METODO SI SE PULSA LA FLECHA DE BACK
        onWillPop: _onWillPopScope,
        child: Scaffold(
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
                            // SI SE HA SELECCIONADO UNA FOTO, SE SETTEA ESA FOTO
                            child: photoPath != null
                                ?
                                // SE MUESTRA DE FORMA CIRCULAR
                                ClipOval(
                                    child: Image.file(
                                      File(photoPath!),
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    ),
                                  )
                                // SI LA RUTA DE LA FOTO NO ES NULA Y EL USUARIO TIENE UNA FOTO GUARDADA
                                : imageUrl.isNotEmpty
                                    ? ClipOval(
                                        child: Image.file(
                                          File(imageUrl),
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                        ),
                                      )
                                    :
                                    // EN CASO DE NO TENER UNA FOTO O URL, SE MUESTRA LA IMAGEN POR DEFECTO
                                    ClipOval(
                                        child: Image.asset(
                                          "assets/default_user_image.png",
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                        ),
                                      )),

                        // ICONO PARA EDITAR
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 5),
                          child: GestureDetector(
                            onTap: () async {
                              // ABRIR GALERIA/EXPLORADOR DE ARCHIVOS
                              final path = await GalleryService().selectPhoto();
                              if (path == null) return;
                              setState(() {
                                photoPath = path;
                              });
                              // SE HA CAMBIADO LA FOTO
                              _isPhotoUpdate = true;
                            },
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
                      child: IconClass.iconButton(context, () {
                        // PARA GUARDAR LOS DATOS DEBERA PONER SU ANTIGUA CONTRASEÑA
                        saveUser();
                        _isDataSaved = true;
                      }, "save_data", Icons.save)),
                  const SizedBox(height: 10),
                  Form(
                      key: formKey,
                      child: Column(children: [
                        FieldForm(
                            icon: IconClass.iconMaker(
                                context, Icons.person, "username"),
                            labelText: Internationalization.internationalization
                                .getLocalizations(context, "username"),
                            hintText: Internationalization.internationalization
                                .getLocalizations(context, "username_hint"),
                            controller: _usernameController,
                            validator: (value) =>
                                Validator.validateUsername(value, true),
                            labelSemantics: Internationalization
                                .internationalization
                                .getLocalizations(context, "username_label"),
                            hintSemantics: Internationalization
                                .internationalization
                                .getLocalizations(context, "username_hint"),
                            borderSize: 15,
                            colorBox: AppColors.purpleIntroColor),

                        // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                        const SizedBox(height: 10),

                        PasswordFieldForm(
                            icon: IconClass.iconMaker(
                                context, Icons.lock, "password"),
                            labelText: Internationalization.internationalization
                                .getLocalizations(context, "password"),
                            hintText: Internationalization.internationalization
                                .getLocalizations(context, "password_hint"),
                            controller: _passwordController,
                            validator: (value) =>
                                Validator.validatePassword(value, false, true),
                            passwordOnSaved: (value) => _password = value!,
                            labelSemantics: Internationalization
                                .internationalization
                                .getLocalizations(context, "password_label"),
                            hintSemantics: Internationalization
                                .internationalization
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
                                .getLocalizations(
                                    context, "confirm_password_hint"),
                            controller: _confirmPasswordController,
                            validator: (value) =>
                                Validator.validateConfirmPassword(
                                    value, _passwordController.text, true),
                            passwordOnSaved: (value) => _password = value!,
                            labelSemantics: Internationalization
                                .internationalization
                                .getLocalizations(
                                    context, "confirm_password_label"),
                            hintSemantics: Internationalization
                                .internationalization
                                .getLocalizations(
                                    context, "confirm_password_hint"),
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
                                Text(
                                  "Delete account",
                                  style: AppStyles.darkPurpleAndBold(18),
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
        ));
  }
}
