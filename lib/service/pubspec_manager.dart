import 'dart:io';

import 'package:gmap_auto_config/service/service_helper.dart';

mixin class PubspecManager {
  Future<bool> addDependency(
    String projectPath,
    String package, {
    String? version,
    bool isDev = false,
  }) async {


    /// here i check if version null add [any] else add version
    /// 
    String packageVersion = version != null ? '^ $version' : 'any';

    final depsKey = isDev ? 'dev_dependencies:' : 'dependencies:';

    final depsPath =
        isDev ? '  $package: $packageVersion' : '  $package: $packageVersion';

  await  FileService.updateFile(
      fullPath: '$projectPath/pubspec.yaml',
      target: depsKey,
      check: depsPath,
      add: depsPath,
    );
    
    

    // Run flutter pub get
    final result = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: projectPath,
      runInShell: true,
    );

    return result.exitCode == 0;
  }
}
