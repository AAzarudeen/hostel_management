import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/myWigdets.dart';
import 'package:image_picker/image_picker.dart';

class ViewCicular extends StatefulWidget {
  const ViewCicular({super.key});

  @override
  State<ViewCicular> createState() => _ViewCicularState();
}

class _ViewCicularState extends State<ViewCicular> {
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Circular"),
        ),
        body: Container(
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
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('circulars').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Center(
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
                                            ListTile(
                                              title: Text(data['title']),
                                              subtitle: Text(data['description'] ??
                                                  ''), // Assuming 'description' is a field in your document
                                              onTap: () {
                                                // Add onTap logic here
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewStudentDetails(
                                                              studentDetails: data),
                                                    ),
                                                  );
                                                }
                                            )
                                          ]))))));
                },
              );
            },
          ),
        ));
  }
}
