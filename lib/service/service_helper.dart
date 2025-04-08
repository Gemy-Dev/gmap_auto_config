// api_service_mixin.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

mixin class ApiServiceMixin {
  Future<String?> getLatestVersion(String packageName) async {
    try {
      final uri = Uri.parse('https://pub.dev/api/packages/$packageName');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['latest']['version'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class FileService {
  
  /// [fullPath] is to get path of file
  /// [target] is the keyword or line i add befor it or after it
  /// [check] this to check if it found or not if it empty it will take [add]
  /// [add] the line want to add it 
  /// [insertBefore] to add after or befor [tartget] line
  static Future<void> updateFile({
    required String fullPath,
    required String target,
     String? check,
    required String add,
    bool insertBefore = false,
  }) async {
    final file = File(fullPath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    
    if (content.contains(check?.trim()??add.trim())) return;

    final lines = content.split('\n');
    final index = lines.indexWhere((line) => line.trim() == target);
    if (index == -1) return;

    lines.insert(index + (insertBefore ? 0 : 1), add);
    await file.writeAsString(lines.join('\n'));
  }
}
