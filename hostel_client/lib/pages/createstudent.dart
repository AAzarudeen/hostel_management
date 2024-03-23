import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _registerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentNumberController = TextEditingController();

  List<String> hostels = ['A', 'B', 'C', 'D'];

  late String _selectedHostel = "A";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _createStudent() {
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Text("Student details"),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(label: Text("Name")),
        ),
        TextField(
          controller: _registerController,
          decoration: const InputDecoration(label: Text("Register number")),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(label: Text("Phone number")),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(label: Text("Email id")),
        ),
        TextField(
          controller: _blockController,
          decoration: const InputDecoration(label: Text("Hostel Block")),
        ),
        TextField(
          controller: _roomNumberController,
          decoration: const InputDecoration(label: Text("Room number")),
        ),
        TextField(
          controller: _parentEmailController,
          decoration: const InputDecoration(label: Text("Parent Email ID")),
        ),
        TextField(
          controller: _parentNumberController,
          decoration: const InputDecoration(label: Text("Parent Phone number")),
        ),
        const SizedBox(height: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select Image'),
            )]),
        const SizedBox(height: 20.0),
        ElevatedButton(
            onPressed: () {
              _createStudent();
            },
            child: const Text("Create student")),
      ],
    ));
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image!.path)}');
    UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() => {
      _firestore.collection('users').add({
      'name' : _nameController.text,
      'register' :_registerController.text,
      'email' : _emailController.text,
      'number' : _registerController.text,
      'block' : _blockController.text,
      'room_number' : _roomNumberController.text,
      'parent_email_id' : _emailController.text,
      'parent_number' : _parentNumberController.text
    }).then((value) {
      print('Data added successfully!');
    }).catchError((error) {
      print('Failed to add data: $error');
    })
    }
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
