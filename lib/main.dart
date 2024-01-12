import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/widgets/dashboard_screen.dart';
import 'package:school_management_app/widgets/kpmdashboard_screen.dart';
import './widgets/login_screen.dart';
import 'package:theme_provider/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        //initialize theme
        AppTheme.dark(),
        AppTheme.purple(),
      ],
      child: MyApp()));
}


final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Hisye App',
      theme: ThemeProvider.themeOf(context).data,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              // Check the user's email and redirect accordingly
              String userEmail = snapshot.data?.email ?? "";
              if (userEmail == "kpm123@gmail.com") {
                return KPMDashboardScreen();
              } else {
                return DashboardScreen();
              }
            } else {
              return LoginScreen();
            }
          },
        ),
      );
}