import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/widgets/list_screen/dashboard_list_widget.dart';
import 'package:theme_provider/theme_provider.dart';

class KKPMDashboardScreen extends StatelessWidget {
  const KKPMDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: false,
        actions: [
          ThemeConsumer(
            child: Builder(
              builder: (themeContext) => IconButton(
                onPressed: () {
                  ThemeProvider.controllerOf(context).nextTheme();
                  var currentTheme = ThemeProvider.themeOf(themeContext);

                  // Check the type of the current theme and switch the icon accordingly
                  if (currentTheme.id == AppTheme.dark().id) {
                    print('Switched to Dark Theme');
                    // You may update the logic based on your theme structure
                  } else {
                    print('Switched to Light Theme');
                    // You may update the logic based on your theme structure
                  }
                },
                icon: Icon(
                  ThemeProvider.themeOf(themeContext).id == AppTheme.dark().id
                      ? Icons.sunny
                      : Icons.dark_mode,
                ),
              ),
            ),
          )
        ],
      ),
      body:
          const KPMDataList(),
      // ),
    );
  }
}

class KPMDataList extends StatefulWidget {
  const KPMDataList({super.key});

  @override
  State<KPMDataList> createState() => _KPMDataListState();
}

class _KPMDataListState extends State<KPMDataList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



