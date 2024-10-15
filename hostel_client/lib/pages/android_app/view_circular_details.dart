import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/myWigdets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ViewCircularDetails extends StatefulWidget {
  final Map<String, dynamic>? circularDetails;

  const ViewCircularDetails({super.key, this.circularDetails});

  @override
  State<ViewCircularDetails> createState() => _ViewCircularDetailsState();
}

class _ViewCircularDetailsState extends State<ViewCircularDetails> {
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Circular Details"),
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
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
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
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    StudentDetailWiget("Title",
                                        widget.circularDetails!['title'] ?? ''),
                                    StudentDetailWiget(
                                        "Message",
                                        widget.circularDetails!['message'] ??
                                            ''.trim()),
                                    Center(
                                        child: ElevatedButton(
                                            onPressed: () {
                                              _downloadFile(
                                                  widget.circularDetails![
                                                      'file_url']);
                                            },
                                            child: const Text(
                                                "Click to download"))),
                                    const SizedBox(height: 20.0),
                                  ],
                                ))))))));
  }

  Future<void> _downloadFile(String fileURL) async {
    await getDownloadsDirectory().then((value) async {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.refFromURL(fileURL);
        String? tempPath = value?.path;
        File localFile = File('$tempPath/${ref.name}');
        await ref.writeToFile(localFile);
        print('File downloaded to: ${localFile.path}');
      } catch (e) {
        print('Error downloading file: $e');
      }
    });
  }
}
