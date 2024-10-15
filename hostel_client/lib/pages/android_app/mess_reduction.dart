import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MessReduction extends StatefulWidget {
  const MessReduction({super.key});

  @override
  State<MessReduction> createState() => _MessReductionState();
}

class _MessReductionState extends State<MessReduction> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _registerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<String> hostels = ['A', 'B', 'C', 'D'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Apply Mess reduction"),
        ),
        body: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade600,
                      Colors.blue.shade400,
                    ],
                  ),
                ),
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text("Student details"),
                                        TextField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                              label: Text("Name")),
                                        ),
                                        TextField(
                                          controller: _registerController,
                                          decoration: const InputDecoration(
                                              label: Text("Register number")),
                                        ),
                                        TextField(
                                          controller: _phoneController,
                                          decoration: const InputDecoration(
                                              label: Text("Phone number")),
                                        ),
                                        TextField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                              label: Text("Email id")),
                                        ),
                                        TextField(
                                          controller: _blockController,
                                          decoration: const InputDecoration(
                                              label: Text("Hostel Block")),
                                        ),
                                        TextField(
                                          controller: _roomNumberController,
                                          decoration: const InputDecoration(
                                              label: Text("Room number")),
                                        ),
                                        TextField(
                                          controller: _parentEmailController,
                                          decoration: const InputDecoration(
                                              label: Text("Parent Email ID")),
                                        ),
                                        TextField(
                                          controller: _parentNumberController,
                                          decoration: const InputDecoration(
                                              label:
                                                  Text("Parent Phone number")),
                                        ),
                                        const SizedBox(height: 20.0),
                                        const SizedBox(height: 20.0),
                                        ElevatedButton(
                                            onPressed: uploadFile,
                                            child:
                                                const Text("Create student")),
                                      ],
                                    )))))))));
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('students/${_registerController.text}.jpg');

    // String downloadURL = await snapshot.ref.getDownloadURL();
    _firestore.collection('students').doc(_registerController.text).set({
      'name': _nameController.text,
      'register': _registerController.text,
      'email': _emailController.text,
      'number': _phoneController.text,
      'block': _blockController.text,
      'room_number': _roomNumberController.text,
      'parent_email_id': _parentEmailController.text,
      'parent_number': _parentNumberController.text,
      // 'image_url': downloadURL
    }).then((value) {
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Data is saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _registerController.text);
      auth.createUserWithEmailAndPassword(
          email: _parentEmailController.text,
          password: _parentNumberController.text);
    }).catchError((error) {
      print('Failed to add data: $error');
    });
  }
}
