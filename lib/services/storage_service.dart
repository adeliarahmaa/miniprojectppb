import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    try {
      final ref = storage.ref().child(
        'foods/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      print("UPLOAD START");

      final uploadTask = await ref.putFile(file);

      if (uploadTask.state != TaskState.success) {
        throw Exception("Upload gagal");
      }

      final url = await uploadTask.ref.getDownloadURL();

      print("UPLOAD DONE: $url");

      return url;
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return "";
    }
  }
}
