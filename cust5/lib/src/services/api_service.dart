import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";



class APIService {
  Future<http.Response> registerUser(String name, String email, String password,
      String location, String phoneNumber, String autogatebrand, String alarmbrand, String warranty) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/dashboarddatabase/customer/register'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'location': location,
              'phone_number': phoneNumber,
              'auto_gate_brand': autogatebrand,
              'alarm_brand': alarmbrand,
              'warranty' : warranty
            }),
          )
          .timeout(const Duration(seconds: 10)); // Add a timeout of 10 seconds

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error registering user: $error');
    }
  }

  
  

}
