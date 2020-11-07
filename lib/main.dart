import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yellow_class_test/screens/splash.dart';

import 'providers/current_user_provider.dart';
import 'screens/authenticate_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CurrentUserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorDark: Colors.black,
        ),
        home: Splash(),
        routes: {
          HomeScreen.route: (_) => HomeScreen(),
          Authenticate.route: (_) => Authenticate(),
        },
      ),
    );
  }
}
