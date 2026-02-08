import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';


// Screens
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CareCueApp());
}

class CareCueApp extends StatelessWidget {
  const CareCueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareCue',
      debugShowCheckedModeBanner: false,
      theme: appTheme,

      home: const SplashScreen(),

      routes: {
        '/app': (_) => const AppShell(),
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
       HomeScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _index,
  onTap: (i) => setState(() => _index = i),

  backgroundColor: backgroundColor, 
  elevation: 8,

  selectedItemColor: primaryBlue,
  unselectedItemColor: textSecondary,

  showSelectedLabels: false,
  showUnselectedLabels: false,
  type: BottomNavigationBarType.fixed,

  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_rounded),
      label: "Settings",
    ),
  ],
)

    );
  }
}

class SettingsScreenPlaceholder extends StatelessWidget {
  const SettingsScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "Settings coming soon",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
