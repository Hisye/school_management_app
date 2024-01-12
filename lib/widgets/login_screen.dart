import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/main.dart';
import 'package:school_management_app/widgets/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String logo = 'images/logo_kpm.png';
    String back_pic = 'images/umt_background.jpg';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(back_pic), opacity: 0.2, fit: BoxFit.cover),
            gradient: const LinearGradient(begin: Alignment.topCenter, colors: [
              Color.fromRGBO(171, 71, 188, 1),
              Color.fromRGBO(156, 39, 176, 1),
              Color.fromRGBO(171, 71, 188, 1),
              Color.fromRGBO(158, 40, 176, 1),
              Color.fromRGBO(160, 39, 176, 1),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(logo),
            ),
            const SizedBox(
              height: 100,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(20), child: LoginForm()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    userEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey, // Assign the key created above to the Form widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Login',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('School Management App', style: TextStyle(fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.purpleAccent,
                        blurRadius: 20,
                        offset: Offset(0, 8))
                  ]),
              child: Column(
                children: [
                  // Email form
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: TextFormField(
                      controller: userEmailController,
                      validator: (value) {
                        // Validate the email field
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter the email',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Password form
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        // Validate the password field
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more password validation logic if needed
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter the password',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(child: Text('')),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.purple[400]),
                onPressed: signIn,
                icon: const Icon(Icons.lock_open),
                label: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    //navigator key
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
