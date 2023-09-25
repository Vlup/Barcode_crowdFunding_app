import 'package:crowdfunding/screens/base_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(129, 199, 132, 1),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/Logo.png'),
            const Text('halo'),
            // Create login page 
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(129, 199, 132, 1),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BasePage(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            const Text('Not Registered?', style: TextStyle(color: Colors.black),),
            const Padding(padding: EdgeInsets.all(5)),
            // Button to register page
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(129, 199, 132, 1)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Color.fromRGBO(129, 199, 132, 1),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                onPressed: () {},
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const RegisterPage(),
                //     ),
                //   );
                // },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}