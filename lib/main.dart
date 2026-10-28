import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/kos_api_service.dart';
import 'services/kos_supabase_service.dart';
import 'repositories/kos_repository.dart';
import 'providers/kos_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

const String supabaseUrl = 'https://siguyjmbjiamchgjzadl.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpZ3V5am1iamlhbWNoZ2p6YWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxOTE5MzIsImV4cCI6MjEwODc2NzkzMn0.QCsrkcqzrJGjIgSuLLlZftlJJWvusiFbjWlSTrQHWHE';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final repository = KosRepository(
    apiService: KosApiService(),
    supabaseService: KosSupabaseService(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => KosProvider(repository)
            ..loadCatalog()
            ..loadSavedKos(),
        ),
      ],
      child: const FindMyKosApp(),
    ),
  );
}

class FindMyKosApp extends StatelessWidget {
  const FindMyKosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FindMyKos - Singaraja Kos Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}