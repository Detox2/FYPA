import 'package:customer/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:customer/API/api_service.dart'; // Import APIService
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class register extends StatefulWidget {
  const register({super.key, this.customerId});
  final String? customerId;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<register> {
  bool? isChecked = false;
  final apiService = APIService(); // Create an instance of APIService

  // Makes the container that takes data from the text field
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController autoController = TextEditingController();
  TextEditingController alarmController = TextEditingController();
  TextEditingController warrantyController = TextEditingController();

  Future<void> _register() async {
    print('Register button pressed'); // Log that the register button is pressed

    // Extract data from text fields
    final String username = usernameController.text;
    final String email = emailController.text;
    final String phone = phoneController.text;
    final String password = passwordController.text;
    final String location = locationController.text;
    final String autogatebrand = autoController.text;
    final String alarmbrand = alarmController.text;
    final String warranty = warrantyController.text;

    // Call signUp function from APIService
    print('Calling signUp API'); // Log that the signUp API is being called

    try {
      final response = await apiService.registerUser(
        username,
        email,
        password,
        location,
        phone,
        autogatebrand,
        alarmbrand,
        warranty
      );

      // Handle response
      if (response.statusCode == 201) {
        // Signup success
        print('Signup successful'); // Log that the signup is successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')),
        );
        // Navigate to next screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        // Signup failed
        print(
            'Signup failed with status code: ${response.statusCode}'); // Log that the signup failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Signup failed with status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print('Error registering user: $error'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering user: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: autoController,
                decoration: InputDecoration(
                  labelText: 'Auto Gate Brand',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: alarmController,
                decoration: InputDecoration(
                  labelText: 'Alarm Brand',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: warrantyController,
                decoration: InputDecoration(
                  labelText: 'warranty',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                ),
                const Text('I have read and agreed to Terms & Conditions'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _register, // Call _register function
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
