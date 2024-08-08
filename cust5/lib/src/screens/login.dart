import 'package:customer/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:customer/pages/register.dart';
import 'package:customer/API/api_login.dart';



//Container for Login Details
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

// Initialize the API
final login = NewService();

class Login extends StatelessWidget {
  
  const Login({super.key});
  
  Future<void> _login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await login.loginUser(email, password);

      final token = response['token']; // Extract token from response

      // Navigate to CustomerDetailsPage and pass token as parameter
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            token: token,
            
          ),
        ),
      );

      // Rest of your code
    } catch (e) {
      print('Login Error: $e');
      showInvalidCredentialsDialog(context);
    }
  }

  void showInvalidCredentialsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login failed'),
          content: const Text('Invalid email or password. Please try again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> openDialog(BuildContext context) async {
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Email'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Please Enter Your Email'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, emailController.text);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );

    if (email != null) {
      emailController.text = email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    openDialog(context);
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User? Click here to '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                register()), // Navigate to the register page
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
