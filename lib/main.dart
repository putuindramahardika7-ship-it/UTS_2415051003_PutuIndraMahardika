import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/kos_api_service.dart';
import 'services/kos_supabase_service.dart';
import 'repositories/kos_repository.dart';
import 'providers/kos_provider.dart';
import 'screens/main_navigation_screen.dart';

const String supabaseUrl = 'https://nwbggednoovhykmrcfnt.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53YmdnZWRub292aHlrbXJjZm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxNzcwNzIsImV4cCI6MjEwODc1MzA3Mn0.Fo0Mi9QUJpuSdIXYEorwOaC3yvvfoD_qxAYoPsFligY';

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
    ChangeNotifierProvider(
      create: (_) => KosProvider(repository)
        ..loadCatalog()
        ..loadSavedKos(),
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
      home: const MainNavigationScreen(),
    );
  }
}