import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/model/user_model.dart';
import 'package:crowdfunding/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  bool isRegisterButtonEnabled() {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmpasswordController.text;

    return name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      (password == confirmPassword);
  }

  Future<void> createUser() async {
    final dbUser = FirebaseFirestore.instance.collection('users').doc();
    String docID = dbUser.id;
    final user = UserModel(
      id: docID,
      name: nameController.text, 
      email: emailController.text,
      password: passwordController.text, 
      isVerified: false
    );
    await dbUser.set(user.toJson()).then((value) {
      nameController.text = '';
      emailController.text = '';
      passwordController.text = '';
      confirmpasswordController.text = '';
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Registered!'),
          duration: Duration(milliseconds: 2000)
        )
      );
    });
  }

  void onRegisterButtonPressed(BuildContext context) {
    if (isRegisterButtonEnabled()) {
      createUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    "images/Logo.png"
                    // "assets/images/Logo.png"    - NB: use this one when build apk 
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    width: 315,
                    height: 470,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SizedBox(
                              width: 242,
                              height: 56,
                              child: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Name',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SizedBox(
                              width: 242,
                              height: 56,
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: SizedBox(
                              width: 242,
                              height: 56,
                              child: TextField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: SizedBox(
                              width: 242,
                              height: 56,
                              child: TextField(
                                controller: confirmpasswordController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Confirm Password',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 242,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(129, 199, 132, 1)),
                                onPressed: () => onRegisterButtonPressed(context),
                                child: const Text(
                                  "Register",
                                  style:
                                      TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Already have an account ?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Color.fromRGBO(129, 199, 132, 1)),
                                )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
