import 'package:flutter/material.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _civilStatusController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  void _register() {
    if (_fullnameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _civilStatusController.text.isEmpty ||
        _birthdateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Fill out all the fields')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password Does not match')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' MACAPUNDAGAG Activity 6'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _fullnameController,
              decoration: _inputDecoration('FullName', Icons.person),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _usernameController,
              decoration: _inputDecoration('Username', Icons.account_circle),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration('Password', Icons.lock),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: _inputDecoration('Confirm Password', Icons.lock_outline),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _genderController,
              decoration: _inputDecoration('Gender', Icons.male_rounded),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _civilStatusController,
              decoration: _inputDecoration('Civil Status', Icons.people),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _birthdateController,
              decoration: _inputDecoration('Birthdate', Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2025),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _birthdateController.text =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  });
                }
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}