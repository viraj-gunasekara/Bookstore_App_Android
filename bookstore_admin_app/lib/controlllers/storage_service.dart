/* for Firebase Storage */
// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class StorageService{
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // TO UPLOAD IMAGE TO FIREBASE STORAGE
//   Future<String?> uploadImage(String path, BuildContext context) async {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("Uploading image...")));
//     print("Uploading image...");
//     File file = File(path);

//     try {
//       // Create a unique file name based on the current time
//       String fileName = DateTime.now().toString();

//       // Create a reference to Firebase Storage
//       Reference ref = _storage.ref().child("bookstore_images/$fileName");

//       // Upload the file
//       UploadTask uploadTask = ref.putFile(file);

//       // Wait for the upload to complete
//       await uploadTask;

//       // Get the download URL
//       String downloadURL = await ref.getDownloadURL();
//       print("Download URL: $downloadURL");
//       return downloadURL;
//     } catch (e) {
//       print("There was an error");
//       print(e);

//       return null;
//     }

//   }
// }

/* for Cloudinary */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class StorageService {
  Future<String?> uploadImage(String path, BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Uploading image...")));
    print("Uploading image...");

    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];
    final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    final file = File(path);
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['upload_preset'] = uploadPreset!
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final imageUrl = data['secure_url'];
        print("Cloudinary URL: $imageUrl");
        return imageUrl;
      } else {
        print("Upload failed: $resBody");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
