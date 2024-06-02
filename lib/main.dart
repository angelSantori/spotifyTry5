import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoty_try5/models/character_model.dart';
import 'package:spoty_try5/provider/api_provider.dart';
import 'package:spoty_try5/screens/zcreens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp(
        title: 'Rick & Morty',
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        routes: {
          'login':(_) => const LoginScreen(), 
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == 'character') {
            final character = settings.arguments as Character;
            return MaterialPageRoute(
              builder: (context) {
                return CharacterScreen(character: character);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
