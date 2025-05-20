import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:agendar_consultas/provider/clientes_provider.dart';
import 'package:agendar_consultas/provider/consultas_provider.dart';
import 'screens/home.dart';
import 'screens/agendar.dart';
import 'screens/cadastrar.dart';
import 'screens/detalhes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientesProvider()), 
        ChangeNotifierProvider(create: (context) => ConsultasProvider()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Agendar Consultas',
      theme: ThemeData(
        primarySwatch: const Color.fromARGB(255, 0, 112, 216), 
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, 
      routes: {         
        '/agendar': (context) => const AgendarScreen(),
        '/cadastrar': (context) => const CadastrarScreen(),
        '/detalhes': (context) => const DetalhesScreen(),
      },
    );
  }
}