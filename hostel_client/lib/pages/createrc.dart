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
    final String name = _nameController.text;
    final String block = _blockController.text;
    final String email = _emailController.text;
    final String phoneNumber = _phoneController.text;

    try {
      await _firestore.collection('rc').add({
        'name': name,
        'block': block,
        'email': email,
        'phone': phoneNumber,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resident saved successfully')),
      );
      // Clear the text fields after saving
      _nameController.clear();
      _blockController.clear();
      _emailController.clear();
      _phoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save resident: $e')),
      );
    }
  }
}