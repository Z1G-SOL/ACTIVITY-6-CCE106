import 'package:flutter/material.dart';
import '../socialmedia.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = "This is an errormessage";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkLogin(username, password) {
    setState(() {
      if (username == "") {
        errormessage = "Please input your username!";
        isError = true;
      } else if (password == "") {
        errormessage = "Please input your password!";
        isError = true;
      } else {
        errormessage = "";
        isError = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 48,
                    width: 48,
                  ),
                  const SizedBox(width: 12),
                  Text('TIKITOKTOK', style: txtstyle),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  checkLogin(usernameController.text, passwordController.text);
                  if (!isError) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Socialmedia()),
                    );
                  }
                },
                child: Text('LOGIN', style: txtstyle2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var txtstyle = const TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontSize: 38,
);

var registertxtstyle = const TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontSize: 14,
);

var errortxtstyle = const TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
  fontSize: 14,
  color: Colors.red,
);
var txtstyle2 = const TextStyle(
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontSize: 24,
  color: Colors.white,
);