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
  File? _image;
  Uint8List? _webImageBytes;

  Uint8List? _imageData;

  // final picker = ImagePicker();

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
        body: SingleChildScrollView(
            child: Column(
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
          _imageData != null
              ? Image.memory(_imageData!, height: 200, width: 200)
              : Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getImage,
            child: const Text('Select Image'),
          )
        ]),
        const SizedBox(height: 20.0),
        ElevatedButton(
            onPressed: uploadFile, child: const Text("Create student")),
      ],
    )));
  }

  Future uploadFile() async {
    print("hello");
    Reference storageReference =
        FirebaseStorage.instance.ref().child('students/${_registerController.text}.jpg');
    print(_imageData);
    UploadTask uploadTask = storageReference.putData(
        _imageData!, SettableMetadata(contentType: 'image/jpeg'));
    print("file uploaded");
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
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _registerController.text);
      print('Data added successfully!');
      auth.createUserWithEmailAndPassword(
          email: _parentEmailController.text, password: _parentNumberController.text);
      print("data uploaded");
    }).catchError((error) {
      print('Failed to add data: $error');
    });
    print("hello end");
  }

  // Future<void> uploadData() async {
  //   if (_imageData == null) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error'),
  //           content: const Text('Please select an image.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     return;
  //   }
  //
  //   try {
  //     final Reference storageReference = FirebaseStorage.instance
  //         .ref()
  //         .child('students/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     final UploadTask uploadTask = storageReference.putData(_imageData!);
  //     await uploadTask.whenComplete(() async {
  //       final imageUrl = await storageReference.getDownloadURL();
  //       await _firestore
  //           .collection('students')
  //           .doc(_registerController.text)
  //           .set({
  //         'name': _nameController.text,
  //         'register': _registerController.text,
  //         'email': _emailController.text,
  //         'number': _phoneController.text,
  //         'block': _blockController.text,
  //         'room_number': _roomNumberController.text,
  //         'parent_email_id': _parentEmailController.text,
  //         'parent_number': _parentNumberController.text,
  //         'image_url': imageUrl,
  //       });
  //
  //       // Create users with student and parent emails
  //       final FirebaseAuth auth = FirebaseAuth.instance;
  //       await auth.createUserWithEmailAndPassword(
  //           email: _emailController.text, password: _registerController.text);
  //       await auth.createUserWithEmailAndPassword(
  //           email: _parentEmailController.text,
  //           password: _parentNumberController.text);
  //
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Success'),
  //             content: const Text('Student details uploaded successfully.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     });
  //   } catch (error) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error'),
  //           content: Text('Failed to upload data: $error'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // Future _getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       // _webImageBytes = null; // Reset web image bytes when a new image is picked
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
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
