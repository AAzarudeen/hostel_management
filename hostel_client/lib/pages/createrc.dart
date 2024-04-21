import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRC extends StatefulWidget {

  const CreateRC({super.key});

  @override
  State<CreateRC> createState() => _CreateRcState();
}

class _CreateRcState extends State<CreateRC> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create RC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _blockController,
              decoration: const InputDecoration(labelText: 'Block'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveResident();
              },
              child: const Text('Save Resident'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResident() async {
    _firestore.collection('RC').doc(_emailController.text).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'number': _phoneController.text,
      'block': _blockController.text,
    }).then((value) {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _phoneController.text);
      print('Data added successfully!');
});
    }
}