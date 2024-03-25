import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CreateStudent extends StatefulWidget {
  final Map<String, String>? studentDetails;

  const CreateStudent({super.key, this.studentDetails});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  Uint8List? _imageData;
  
  final picker = ImagePicker();

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
    _parentEmailController.text = widget.studentDetails!['parent_email_id'] ?? '';
    _parentNumberController.text = widget.studentDetails!['parent_number'] ?? '';
    // _imageData = (widget.studentDetails!['image_data'] ?? '') as Uint8List?;
  }
}

  List<String> hostels = ['A', 'B', 'C', 'D'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          if (_imageData != null)
              Image.memory(
                _imageData!,
                width: 100,
                height: 100,
              )
            else
              const Text('No image selected'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getImage,
            child: const Text('Select Image'),
          )
        ]),
        const SizedBox(height: 20.0),
        ElevatedButton(
            onPressed: uploadData,
            child: const Text("Create student")),
      ],
    ));
  }

  // Future uploadFile() async {
  //   print("hello");
  //   final blob = html.Blob([_imageData], 'image/jpeg');
  //   final file = html.File([blob], 'image.jpg');
  //   Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('students/2022179017.jpg');
  //   UploadTask uploadTask = storageReference.putBlob(file);
  //   print("file updloaded");
  //   await uploadTask.whenComplete(() => {
  //           _firestore.collection('students').doc("2022179017").set({
  //           'name': "Azarudeen",
  //           'register': "2022179017",
  //           'email': "2022179017@student.annauniv.edu",
  //           'number': "8667288997",
  //           'block': "thazam",
  //           'room_number': "66",
  //           'parent_email_id': "azarcrackzz@gmail.com",
  //           'parent_number': "9789291871"
  //         }).then((value) {
  //           FirebaseAuth auth = FirebaseAuth.instance;
  //           auth.createUserWithEmailAndPassword(email: "2022179017@student.annauniv.edu", password: "2022179017");
  //           print('Data added successfully!');
  //           auth.createUserWithEmailAndPassword(email: "azarcrackzz@gmail.com", password: "9789291871");
  //           print("data uploaded");
  //         }).catchError((error) {
  //           print('Failed to add data: $error');
  //         })
  //       });
  //       print("hello end");
  // }

Future<void> uploadData() async {
    if (_imageData == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child('students/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageReference.putData(_imageData!);
      await uploadTask.whenComplete(() async {
        final imageUrl = await storageReference.getDownloadURL();
        await _firestore.collection('students').doc(_registerController.text).set({
          'name': _nameController.text,
          'register': _registerController.text,
          'email': _emailController.text,
          'number': _phoneController.text,
          'block': _blockController.text,
          'room_number': _roomNumberController.text,
          'parent_email_id': _parentEmailController.text,
          'parent_number': _parentNumberController.text,
          'image_url': imageUrl,
        });

        // Create users with student and parent emails
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(email: _emailController.text, password: _registerController.text);
        await auth.createUserWithEmailAndPassword(email: _parentEmailController.text, password: _parentNumberController.text);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Student details uploaded successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload data: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _getImage() async {
    final imageData = await ImagePickerWeb.getImageAsBytes();
    if (imageData != null) {
      setState(() {
        _imageData = Uint8List.fromList(imageData);
      });
    }
  }
}
