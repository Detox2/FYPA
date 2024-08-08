import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:customer/API/api_login.dart';

class Requests extends StatefulWidget {
  final String token;
  const Requests({super.key, required this.token});

  @override
  State<Requests> createState() => _RequestsState();
}

Future<void> submitOrder(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String token,
    int? selectedChipIndex,
    DateTime? selectedDate,
    int? selectedPriorityIndex,
    TextEditingController problemDescriptionController,
    File? imageFile) async {
  final orderData = {
    'problem_type': selectedChipIndex == 0 ? 'Autogate' : 'Alarm',
    'order_date':
        selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    'urgency_level': selectedPriorityIndex == 0
        ? 'Standard'
        : selectedPriorityIndex == 1
            ? 'Urgent'
            : 'Emergency',
    'order_detail': problemDescriptionController.text,
  };

  final response = await NewService.createOrder(
    token: token,
    orderData: orderData,
    image: imageFile,
  );

  if (response['success']) {
    print('Order Created');
  } else {
    // Failed to create order, show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'])),
    );
  }
}

class _RequestsState extends State<Requests> {
  int? _selectedChipIndex;
  int? _selectedPriorityIndex;
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  late CameraController _cameraController;
  final TextEditingController ProbController = TextEditingController();

  late Future<void> _initializeCameraControllerFuture;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeCameraControllerFuture;

      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = File(image.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(20.0),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please Select a Problem Type',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('Autogate'),
                        selected: _selectedChipIndex == 0,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChipIndex = selected ? 0 : null;
                          });
                        },
                        selectedColor: Colors.red,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: _selectedChipIndex == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Alarm'),
                        selected: _selectedChipIndex == 1,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChipIndex = selected ? 1 : null;
                          });
                        },
                        selectedColor: Colors.red,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: _selectedChipIndex == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Date and Time:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {},
                        onConfirm: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: Text(
                      _selectedDate != null
                          ? 'Selected Date: ${DateFormat.yMd().add_jm().format(_selectedDate!)}'
                          : 'Select Date and Time',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Priority Level:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('Standard'),
                        selected: _selectedPriorityIndex == 0,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedPriorityIndex = selected ? 0 : null;
                          });
                        },
                        selectedColor: Colors.red,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: _selectedPriorityIndex == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Urgent'),
                        selected: _selectedPriorityIndex == 1,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedPriorityIndex = selected ? 1 : null;
                          });
                        },
                        selectedColor: Colors.red,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: _selectedPriorityIndex == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Emergency'),
                        selected: _selectedPriorityIndex == 2,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedPriorityIndex = selected ? 2 : null;
                          });
                        },
                        selectedColor: Colors.red,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: _selectedPriorityIndex == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description of Problem",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ProbController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Describe your problem...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Describe Your Problem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await submitOrder(
                        context,
                        _formKey,
                        widget.token,
                        _selectedChipIndex,
                        _selectedDate,
                        _selectedPriorityIndex,
                        ProbController,
                        _imageFile,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _takePicture,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Take Picture'),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.file(_imageFile!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
