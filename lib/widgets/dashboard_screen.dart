import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/widgets/add/add_teacher_screen.dart';
import 'package:school_management_app/widgets/add/add_student_screen.dart';
import 'package:school_management_app/widgets/list_screen/dashboard_list_widget.dart';
import 'package:theme_provider/theme_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       colors: [
          //         Color.fromRGBO(234, 220, 237, 1),
          //         Color.fromRGBO(221, 203, 224, 1),
          //         Color.fromRGBO(228, 205, 231, 1),
          //         Color.fromRGBO(221, 191, 226, 1),
          //         Color.fromRGBO(219, 192, 223, 1),
          //       ],
          //     ),
          //   ),
          //   child:
          const DataList(),
      // ),
      drawer: DrawerWidget(),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.exit_to_app,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String logo = 'images/umt_logo.png';
    final user = FirebaseAuth.instance.currentUser!;

    String headerText = 'SKBG Admin';

    if (user.email == 'skbg123@gmail.com') {
      headerText = 'SKBG Admin';
    } else if (user.email == 'skkk123@gmail.com') {
      headerText = 'SKKK Admin';
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
              border: Border.all(color: Colors.purple),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign in as: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  headerText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 47,
                  ),
                ),
              ],
            ),
          ),
          // DrawerHeader(
          //   decoration: const BoxDecoration(
          //     color: Colors.purple,
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         'Sign in as: ',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //         ),
          //       ),
          //       Text(
          //         headerText,
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 18,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(
            title: const Text('Add Teacher'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherDataEntry(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Add Student'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDataEntry(),
                ),
              );
            },
          ),
          const Spacer(), // Now the Spacer has more space to take up
          ListTile(
            tileColor: Colors.red,
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _showLogoutConfirmationDialog(context),
          ),
        ],
      ),
    );
  }
}
