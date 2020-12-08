import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class APIStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/api.txt');
  }

  Future<String> readAPI() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeAPI(String api) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$api');
  }
}
