import 'dart:io';

Future<List<int>> getFile(String path) async {
  return File(path).readAsBytesSync().toList();
}

Future deleteFile(String path) async {
  File(path).deleteSync();
}
