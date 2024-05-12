import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStudent extends StatefulWidget {
  final Map<String, String>? studentDetails;

  const CreateStudent({super.key, this.studentDetails});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  final picker = ImagePicker();
  Uint8List? _imageData;

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
    if (widget.studentDetails != null) {
      _nameController.text = widget.studentDetails!['name'] ?? '';
      _registerController.text = widget.studentDetails!['register'] ?? '';
      _phoneController.text = widget.studentDetails!['number'] ?? '';
      _emailController.text = widget.studentDetails!['email'] ?? '';
      _blockController.text = widget.studentDetails!['block'] ?? '';
      _roomNumberController.text = widget.studentDetails!['room_number'] ?? '';
      _parentEmailController.text =
          widget.studentDetails!['parent_email_id'] ?? '';
      _parentNumberController.text =
          widget.studentDetails!['parent_number'] ?? '';
      // _imageData = (widget.studentDetails!['image_data'] ?? '') as Uint8List?;
    }
  }

  List<String> hostels = ['A', 'B', 'C', 'D'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Student"),
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
                                          label: Text("Parent Phone number")),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          _imageData != null
                                              ? Image.memory(_imageData!,
                                                  height: 200, width: 200)
                                              : Container(
                                                  height: 200,
                                                  width: 200,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.image,
                                                      size: 100,
                                                      color: Colors.grey[600]),
                                                ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: _getImage,
                                            child: const Text('Select Image'),
                                          )
                                        ]),
                                    const SizedBox(height: 20.0),
                                    ElevatedButton(
                                        onPressed: uploadFile,
                                        child: const Text("Create student")),
                                  ],
                                ) ))))))));
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('students/${_registerController.text}.jpg');
    UploadTask uploadTask = storageReference.putData(
        _imageData!, SettableMetadata(contentType: 'image/jpeg'));
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    _firestore.collection('students').doc(_registerController.text).set({
      'name': _nameController.text,
      'register': _registerController.text,
      'email': _emailController.text,
      'number': _phoneController.text,
      'block': _blockController.text,
      'room_number': _roomNumberController.text,
      'parent_email_id': _parentEmailController.text,
      'parent_number': _parentNumberController.text,
      'image_url': downloadURL
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

  void _getImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _imageData = file.bytes;
      });
    }
  }
}
