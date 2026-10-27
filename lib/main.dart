import 'package:auroria/screens/auth_screen.dart';
import 'package:auroria/screens/calendar_screen.dart';
import 'package:auroria/services/auth_service.dart';
import 'package:auroria/services/task_service.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  final tasks = TaskService();
  final auth = AuthService(tasks);
  await auth.restoreSession();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskService>.value(value: tasks),
        ChangeNotifierProvider<AuthService>.value(value: auth),
      ],
      child: const AuroriaApp(),
    ),
  );
}

class AuroriaApp extends StatelessWidget {
  const AuroriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auroria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final logged = context.watch<AuthService>().isLogged;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: logged
          ? const CalendarScreen(key: ValueKey('calendar'))
          : const AuthScreen(key: ValueKey('auth')),
    );
  }
}