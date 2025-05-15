import 'package:esteladevega_tfg_cubex/data/dao/supebase/user_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/bottom_navigation.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/session.dart';
import '../../view/utilities/alert.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_user.dart';
import '../dao/supebase/cubetype_dao_sb.dart';
import '../dao/supebase/session_dao_sb.dart';

/// Clase encargada de manejar la lógica de autenticación con Supabase y
/// la inicialización de datos del usuario una vez autenticado.
class SupabaseHelper {
  /// Cliente Supabase utilizado para la autenticación y otras operaciones.
  static final SupabaseClient supabase = Supabase.instance.client;

  /// DAO para operaciones relacionadas con el usuario en Supabase.
  UserDaoSb userDaoSb = UserDaoSb();

  /// DAO para operaciones relacionadas con sesiones de cubo.
  final sessionDaoSb = SessionDaoSb();

  /// DAO para operaciones relacionadas con tipos de cubos.
  final cubeTypeDaoSb = CubeTypeDaoSb();

  /// Escucha los cambios en el estado de autenticación y realiza la configuración
  /// inicial del usuario si es su primer inicio de sesión.
  void getSession(BuildContext context) {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      DatabaseHelper.logger.i('evento: $event, sesion: $session');

      /// Funcion interna que se ejecuta cuando el usuario inicia sesion
      Future<void> handleSignIn() async {
        final supabaseUser = session!.user;
        final metadata = supabaseUser.userMetadata;

        // VERIFICA QUE EL CORREO ESTE CONFIRMADO
        if (supabaseUser.emailConfirmedAt != null) {
          // VERIFICA QUE LOS METADATOS NECESARIOS ESTEN PRESENTES
          if (metadata != null &&
              metadata['username'] != null &&
              metadata['mail'] != null &&
              metadata['password'] != null) {
            String uuid = supabaseUser.id;

            // SE CREA UN OBJETO DE USUARIO A PARTIR DE LOS METADATOS
            final user = UserClass(
              username: metadata['username']!,
              mail: metadata['mail']!,
              password: metadata['password']!,
              userUUID: uuid,
            );

            // INSERTA EL USUARIO EN LA BASE DE DATOS
            final inserted = await userDaoSb.insertUser(user);
            if (inserted) {
              // SE GUARDAR USUARIO EN EL ESTADO GLOBAL
              final currentUser =
                  Provider.of<CurrentUser>(context, listen: false);
              user.isSingup = true;
              currentUser.setUser(user);

              // GUARDAR DATOS EN LAS PREFERENCIAS COMPARTIDAS
              final prefs = await SharedPreferences.getInstance();
              await user.saveToPreferences(prefs);
              await prefs.setBool("isLoggedIn", false);
              await prefs.setBool("isSingup", true);
              await prefs.reload();

              // OBTENER ID DEL USUARIO RECIEN INSERTADO
              final idUser = await userDaoSb.getIdUserFromName(user.username);
              DatabaseHelper.logger.w(idUser);

              if (idUser != -1) {
                // DEFINIR LOS TIPOS DE CUBOS POR DEFECTO
                final cubeTypes = [
                  "2x2x2",
                  "3x3x3",
                  "4x4x4",
                  "5x5x5",
                  "6x6x6",
                  "7x7x7",
                  "PYRAMINX",
                  "SKEWB",
                  "MEGAMINX",
                  "SQUARE-1"
                ];

                // INSERTAR TIPOS DE CUBO PARA EL USUARIO
                for (final cube in cubeTypes) {
                  await cubeTypeDaoSb.insertNewType(cube, idUser);
                }

                // OBTENER LOS TIPOS DE CUBO DEL USUARIO
                final userCubeTypes = await cubeTypeDaoSb.getCubeTypes(idUser);
                DatabaseHelper.logger.i(userCubeTypes.toString());

                // CREAR UNA SESION "NORMAL" PARA CADA TIPO DE CUBO
                for (final type in userCubeTypes) {
                  if (type.idCube != null) {
                    final session = SessionClass(
                      idUser: idUser,
                      sessionName: "Normal",
                      idCubeType: type.idCube!,
                    );

                    await sessionDaoSb.insertSession(session);

                    // SI ES 3x3x3, ACTUALIZAR ESTADO GLOBAL DE SESION Y CUBO
                    if (type.cubeName == "3x3x3") {
                      final currentSession =
                          Provider.of<CurrentSession>(context, listen: false);
                      final currentCube =
                          Provider.of<CurrentCubeType>(context, listen: false);

                      currentSession.setSession(session);
                      currentCube.setCubeType(type);
                    }
                  } else {
                    // ID DE CUBO NULO
                    DatabaseHelper.logger
                        .e("id de tipo de cubo es null para $type");
                  }
                }

                // MOSTRAR SNACKBAR DE EXITO Y REDIRIGIR A LA PANTALLA PRINCIPAL
                AlertUtil.showSnackBarInformation(
                    context, "account_created_successfully");

                ChangeScreen.changeScreen(
                    const BottomNavigation(index: 1), context);
              }
            } else {
              // FALLO EN LA INSERCION DEL USUARIO
              DatabaseHelper.logger
                  .w("No se pudo insertar el usuario en Supabase");
            }
          } else {
            // METADATOS INCOMPLETOS O NULOS
            DatabaseHelper.logger
                .e("Los metadatos del usuario estan incompletos/nulos");
          }
        } else {
          // CORREO AUN NO CONFIRMADO
          DatabaseHelper.logger.i("Correo no confimado todavia");
        }
      }

      // SI EL EVENTO ES SIGNED IN Y LA SESION ES VALIDA, MANEJA LA AUTENTICACION
      if (event == AuthChangeEvent.signedIn && session != null) {
        handleSignIn();
      }

      // MANEJO DE OTROS EVENTOS DE AUTENTICACION (PUEDES AGREGAR MAS SI LO NECESITAS)
      switch (event) {
        case AuthChangeEvent.initialSession:
          DatabaseHelper.logger.i("Initial session");
          break;
        case AuthChangeEvent.signedIn:
          DatabaseHelper.logger.i("Signed in");
          break;
        case AuthChangeEvent.signedOut:
        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.userDeleted:
        case AuthChangeEvent.mfaChallengeVerified:
          // OTROS EVENTOS NO UTILIZADOS
          break;
      }
    });
  }
}