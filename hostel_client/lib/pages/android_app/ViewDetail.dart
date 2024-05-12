import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/myWigdets.dart';
import 'package:image_picker/image_picker.dart';

class ViewStudentDetails extends StatefulWidget {
  final Map<String, dynamic>? studentDetails;

  const ViewStudentDetails({super.key, this.studentDetails});

  @override
  State<ViewStudentDetails> createState() => _ViewStudentDetailsState();
}

class _ViewStudentDetailsState extends State<ViewStudentDetails> {
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Student Details"),
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
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Student details",
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 50.0,
                                                  backgroundImage: NetworkImage(
                                                      widget.studentDetails![
                                                          'image_url']!),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        StudentDetailWiget(
                                            "Name ",
                                            widget.studentDetails!['name'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "Register number ",
                                            widget.studentDetails![
                                                    'register'] ??
                                                ''.trim()),
                                        StudentDetailWiget(
                                            "Phone Number",
                                            widget.studentDetails!['number'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "Email",
                                            widget.studentDetails!['email'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "Block",
                                            widget.studentDetails!['block'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "Room Number",
                                            widget.studentDetails![
                                                    'room_number'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "parent email id",
                                            widget.studentDetails![
                                                    'parent_email_id'] ??
                                                ''),
                                        StudentDetailWiget(
                                            "Parent Number",
                                            widget.studentDetails![
                                                    'parent_number'] ??
                                                ''),
                                        const SizedBox(height: 20.0),
                                      ],
                                    )))))))));
  }
}
