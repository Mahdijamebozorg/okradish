import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/themes.dart';
import 'package:OKRADISH/route/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget appView({
    required bool isMobile,
    required double desktopWidth,
    required double desktopHeight,
    required Widget child,
  }) {
    if (isMobile) return child;
    return Center(
      child: ClipRect(
        child: SizedBox(
          width: desktopWidth,
          height: desktopHeight,
          child: MediaQuery(
            data: MediaQueryData(
              size: Size(desktopWidth, desktopHeight),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return appView(
        isMobile: MediaQuery.sizeOf(context).width < 450,
        desktopWidth: 450, //360.0,
        desktopHeight: MediaQuery.sizeOf(context).height,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("fa", "IR"),
          ],
          locale: const Locale("fa", "IR"),
          title: 'OKRADISH',
          theme: lightTheme(),
          routes: routes,
          initialRoute: '/',
        ));
  }
}
