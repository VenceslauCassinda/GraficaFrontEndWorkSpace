import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'aplicacao_c.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'janelas/login/janela_login.dart';

class Aplicacao extends StatelessWidget {
  late AplicacaoC _controlador;

  Aplicacao() {
    _controlador = Get.put(AplicacaoC());
  }

  @override
  Widget build(BuildContext context) {
    _controlador.context = context;
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (c,w) => GetMaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [Locale('pt', 'BR')],
        theme: ThemeData(
            primaryColor: const Color.fromRGBO(86, 0, 78, 1),
            // accentColor: const Color.fromRGBO(86, 0, 78, 1),
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(secondary: const Color.fromRGBO(86, 0, 78, 1))),
        debugShowCheckedModeBanner: false,
        home: JanelaLogin(),
      ),
    );
  }
}
