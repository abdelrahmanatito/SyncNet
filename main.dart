import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/devices_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/voice_command_history_screen.dart';
import 'screens/routines_screen.dart';
import 'screens/notifications_screen.dart';
import 'theme/app_theme.dart';
import 'models/device.dart';
import 'models/routine.dart';
import 'models/notification.dart';
import 'services/voice_command_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SyncNetApp());
}

class SyncNetApp extends StatelessWidget {
  const SyncNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VoiceCommandService(sampleDevices),
        ),
      ],
      child: MaterialApp(
        title: 'SyncNet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/devices': (context) => const DevicesScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/voice_history': (context) => VoiceCommandHistoryScreen(
                voiceService: Provider.of<VoiceCommandService>(context),
              ),
          '/routines': (context) => RoutinesScreen(
                routines: sampleRoutines,
              ),
          '/notifications': (context) => NotificationsScreen(
                notifications: sampleNotifications,
              ),
        },
      ),
    );
  }
}
