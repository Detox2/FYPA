import 'package:flutter/material.dart';
import 'package:customer/API/api_login.dart';  // Make sure this path is correct

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  final String token;

  const OrderDetailPage({super.key, required this.orderId, required this.token});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Map<String, dynamic>> _orderDetailFuture;

  @override
  void initState() {
    super.initState();
    print('OrderId ${widget.orderId}');
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    print('Token: $token');
    try {
      final orderDetails = await NewService().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        print('Order details: $orderDetails');
        return orderDetails['result'];
      } else {
        _showErrorDialog(orderDetails['error']);
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      print('Error fetching order details: $error');
      _showErrorDialog('Error fetching order details: $error');
      throw Exception('Failed to fetch order details');
    }
  }

  Future<void> _cancelOrder() async {
    try {
      final response = await NewService().cancelOrder(widget.token, widget.orderId, 'Customer cancelled the order');
      if (response['status'] == 200) {
        // Order cancelled successfully
        _showSuccessDialog('Order cancelled successfully');
      } else {
        // Failed to cancel order
        _showErrorDialog(response['message']);
      }
    } catch (error) {
      _showErrorDialog('Error cancelling order: $error');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _orderDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final orderDetails = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.red,
            appBar: AppBar(
              backgroundColor: Colors.red,
            ),
            body: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Container(
                color: Colors.grey[300],
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Problem Type: ${orderDetails['ProblemType']}'),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Date and Time: ${orderDetails['orderDate']}'),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text('Priority:'),
                              SizedBox(width: 20),
                              Text(
                                orderDetails['priority'],
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text('Problem Description'),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: '${orderDetails['orderDetail']}',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(
                                  12), // Add padding for better readability
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Picture: ${orderDetails['orderImage']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text('View')
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text('Technician: Dylan Wong'),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Estimated Time of Arrival: 1:55pm - 2:15pm'),
                          SizedBox(
                            height: 15,
                          ),
                          Text('Contact Number: +6012-3456789'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: TextButton(
                            onPressed: _cancelOrder,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
