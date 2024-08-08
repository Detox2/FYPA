import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:customer/model/ordermodel.dart';

const baseUrl = "http://10.0.2.2:5005";

class NewService {
  // Specify that the Map must be a string that can be of any type
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/dashboarddatabase/login'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            // Encode the body so that the program recognizes it is a JSON file
            body: jsonEncode({
              'email': email,
              'password': password,
              'userType': 'customer',
            }),
          )
          .timeout(const Duration(seconds: 20)); // Add a timeout of 10 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response body to a Dart object
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error registering user: $error');
    }
  }

  Future<Map<String, dynamic>> getCustomerByToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboarddatabase/customer/$token'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to get customer details: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error getting customer details: $error\n$stackTrace');
      throw Exception('Error getting customer details: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderDetailsByCustomerIdAndStatus(
      String customerId, String status, String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/dashboarddatabase/orders/$customerId/$status?customerId=$customerId&status=$status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Convert List<dynamic> to List<Map<String, dynamic>>
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to get order details: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error getting order details: $error\n$stackTrace');
      throw Exception('Error getting order details: $error');
    }
  }

  Future<List<OrderModel>> viewCustomerOrders(
      String token, String customerId) async {
    try {
      print('Fetching orders for customer ID: $customerId with token: $token');
      final response = await http.get(
        Uri.parse('$baseUrl/dashboarddatabase/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'customer'
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("Customer ID: $customerId");

      if (response.statusCode == 200) {
        List<dynamic> ordersJson = jsonDecode(response.body)['result'];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error fetching orders: $error\n$stackTrace');
      throw Exception('Error fetching orders: $error');
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
    required File? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dashboarddatabase/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'customer'
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Order created successfully'};
      } else {
        return {'success': false, 'message': 'Failed to create order'};
      }
    } catch (err) {
      return {'success': false, 'message': 'Error: $err'};
    }
  }
  Future<Map<String, dynamic>> getOrderDetail(String token, String orderId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboarddatabase/orders/details/$orderId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'result': data['result']};
    } else if (response.statusCode == 404) {
      return {'success': false, 'error': 'Order not found'};
    } else {
      return {'success': false, 'error': 'Failed to load order details'};
    }
  } catch (error) {
    print('Error fetching order details: $error');
    return {'success': false, 'error': 'Error fetching order details: $error'};
  }
}
Future<Map<String, dynamic>> updateCustomerProfile(
    String token,
    String customerId,
    String name,
    String email,
    String location,
    String alarmBrand,
    String autogateBrand,
    String phoneNumber,
    String warranty,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dashboarddatabase/customer/updateProfile/$customerId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'location': location,
          'alarm_brand': alarmBrand,
          'autogate_brand': autogateBrand,
          'phone_number': phoneNumber,
          'warranty': warranty,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update customer: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating customer: $error');
      throw Exception('Error updating customer: $error');
    }
  }
  Future<List<OrderModel>> getLatestOrder(String token, String customerId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboarddatabase/orders/latest/$customerId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    ).timeout(const Duration(seconds: 15)); // Increased timeout to 15 seconds

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic> && responseData.containsKey('latest_order')) {
        final dynamic orderData = responseData['latest_order'];

        if (orderData is Map<String, dynamic>) {
          // If the response contains a single order, wrap it in a list
          final OrderModel latestOrder = OrderModel.fromJson(orderData);
          return [latestOrder];
        } else if (orderData is List<dynamic>) {
          // If the response contains multiple orders, parse each one and return as a list
          final List<OrderModel> latestOrders = orderData.map((data) => OrderModel.fromJson(data)).toList();
          return latestOrders;
        } else {
          // If orderData is not the expected type, return an empty list
          return [];
        }
      } else {
        // If the response format is unexpected, return an empty list
        return [];
      }
    } else {
      throw Exception('Failed to load latest order: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching latest order: $error');
    throw Exception('Failed to load latest order: $error');
  }
}


Future<Map<String, dynamic>> cancelOrder(String token, String orderId, String cancelDetails) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/cancel/$orderId');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode({
          'cancel_details': cancelDetails,
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to cancel order: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error cancelling order: $error');
      throw Exception('Error cancelling order: $error');
    }
  }



}

