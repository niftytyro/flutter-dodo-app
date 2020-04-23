import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ListStorage {
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/lists.json');
  }

  Future<Map<String, dynamic>> getItems() async {
    final file = await _localFile;
    String source;
    Map<String, dynamic> lists;
    try {
      source = file.readAsStringSync();
      lists = jsonDecode(source);
    } catch (e) {
      file.writeAsStringSync(jsonEncode({}));
      source = file.readAsStringSync();
      lists = jsonDecode(source);
    }
    return lists;
  }

  Future<void> writeItems(Map items) async {
    final file = await _localFile;
    print(items);
    file.writeAsStringSync(jsonEncode(items));
  }
}
