import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class FilePiki extends StatefulWidget {
  const FilePiki({super.key});

  @override
  State<FilePiki> createState() => _FilePikiState();
}

class _FilePikiState extends State<FilePiki> {
  // Future<void> uploadVideo(String title) async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.video);
  //   if (result != null) {
  //     final file = File(result.files.single.path!);

  //     final formData = FormData.fromMap({
  //       "title": title,
  //       "video": await MultipartFile.fromFile(file.path,
  //           filename: file.path.split('/').last),
  //     });

  //     final dio = Dio();
  //     final response = await dio.post(
  //       "https://your-domain.com/api/upload-media/",
  //       data: formData,
  //       options: Options(headers: {
  //         "Content-Type": "multipart/form-data",
  //         // Add Authorization if needed
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       print("✅ Upload successful!");
  //       print(response.data);
  //     } else {
  //       print("⚠️ Upload failed: ${response.statusMessage}");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                //  uploadVideo('sokoni');
              },
              child: Text('data'))
        ],
      ),
    );
  }
}
