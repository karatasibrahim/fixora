import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<List<String>> uploadFailureImages({
    required String companyId,
    required String uid,
    required List<File> images,
  }) async {
    final urls = <String>[];
    final ts = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < images.length; i++) {
      final ref = _storage.ref('failures/$companyId/${uid}_${ts}_$i.jpg');
      await ref.putFile(
        images[i],
        SettableMetadata(contentType: 'image/jpeg'),
      );
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }
}
