import 'package:esteladevega_tfg_cubex/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/session.dart';

class SessionMenu extends StatefulWidget {
  const SessionMenu({super.key});

  @override
  State<SessionMenu> createState() => _SessionMenuState();
}

class _SessionMenuState extends State<SessionMenu> {
  List<Session> sessions = [];
  SessionDao sessionDao = SessionDao();

  void sessionList() async{
    final result = await sessionDao.sessionList();
    setState(() {
      sessions = result;
    });
    DatabaseHelper.logger.i("obtenidas: ${result.toString()}");
  }

  @override
  void initState() {
    super.initState();
    sessionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000), // SIN FONDO
      body: Container(
        width: 245,
        decoration: BoxDecoration(
          color: AppColors.purpleIntroColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter, // CENTRAR EL TEXTO
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // CENTRADO
              children: [
                const Text(
                  "Select a session",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor,
                      fontSize: 18),
                ), // TITULO

                // ESPACIO ENTRE EL TITULO Y EL LISTVIEW
                const SizedBox(height: 10),

                // EXPANDIR EL LISTVIEW
                Expanded(
                  child: ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          /// cuando pulsa, se establece la sesion a la elegida y se ceirra
                          onTap: () {
                            print('hola');
                          },
                          child: Container(
                            // MARGEN ENTRE SESION Y SESION
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            height: 50,
                            color: Colors.grey,
                            child: Center(child: Text(sessions[index].sessionName)),
                          ),
                        );
                      }),
                ),

                // ESPACIO ENTRE EL LISTVIEW Y EL BOTON
                const SizedBox(height: 10),

                // BOTON PARA CREAR NUEVA SESION
                ElevatedButton(
                    onPressed: () {}, child: const Text("Create a new session"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
