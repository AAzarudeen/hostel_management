import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(
                  data['image_url'],
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                title: Text(data['name']),
                subtitle: Text(data['description'] ??
                    ''), // Assuming 'description' is a field in your document
                onTap: () {
                  // Add onTap logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateStudent(studentDetails: {
                        'name': data['name'],
                        'register': data['register'],
                        'number': data['number'],
                        'email': data['email'],
                        'block': data['block'],
                        'room_number': data['room_number'],
                        'parent_email_id': data['parent_email_id'],
                        'parent_number': data['parent_number'],
                        // 'image_data' : data['']
                      }),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
