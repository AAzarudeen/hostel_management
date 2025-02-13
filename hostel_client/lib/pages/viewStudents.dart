import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_client/pages/android_app/ViewDetail.dart';
import 'package:hostel_client/pages/createstudent.dart';

class ViewStudent extends StatefulWidget {
  const ViewStudent({super.key});

  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Student List"),
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
                FirebaseFirestore.instance.collection('students').snapshots(),
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
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(data[
                                                    'image_url']), // Load image from URL
                                              ),
                                              title: Text(data['name']),
                                              subtitle: Text(data['register'] ??
                                                  ''), // Assuming 'description' is a field in your document
                                              onTap: () {
                                                // Add onTap logic here
                                                if (kIsWeb) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreateStudent(
                                                              studentDetails: {
                                                            'name':
                                                                data['name'],
                                                            'register': data[
                                                                'register'],
                                                            'number':
                                                                data['number'],
                                                            'email':
                                                                data['email'],
                                                            'block':
                                                                data['block'],
                                                            'room_number': data[
                                                                'room_number'],
                                                            'parent_email_id': data[
                                                                'parent_email_id'],
                                                            'parent_number': data[
                                                                'parent_number'],
                                                            'image_data': data[
                                                                'image_url']
                                                          }),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewStudentDetails(
                                                              studentDetails: data),
                                                    ),
                                                  );
                                                }
                                              },
                                            )
                                          ]))))));
                },
              );
            },
          ),
        ));
  }
}
