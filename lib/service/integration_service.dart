import 'dart:io';

import 'package:gmap_auto_config/service/pubspec_manager.dart';
import 'package:gmap_auto_config/service/service_helper.dart';
import 'package:path/path.dart' show join;

enum PlatformCheck { android, ios }

enum DelegateType { objectiveC, swift }

class IntegrationService with ApiServiceMixin, PubspecManager {
  static const _packageName = 'google_maps_flutter';

  // File paths
  static const _manifestPath = 'android/app/src/main/AndroidManifest.xml';
  static const _delegateSwiftPath = 'ios/Runner/AppDelegate.swift';
  static const _delegateObjectiveCPath = 'ios/Runner/AppDelegate.m';
  static const _mainPath = 'lib/main.dart';
  static const _infoPlistPath = 'ios/Runner/Info.plist';

  Future<void> integrationPackage(String projectPath) async {
    /// this will get last version from api
    /// if has error it will be null and we use [any] keyword
    final packageVersion = await getLatestVersion(_packageName);

    await addDependency(projectPath, _packageName, version: packageVersion);
  }

  Future<bool> androidConfig(String projectPath, [String? mapKey]) async {
    /// check and add internet
    await FileService.updateFile(
      fullPath: '$projectPath/$_manifestPath',
      target: '<application',
      check: 'INTERNET',
      add: '  <uses-permission android:name="android.permission.INTERNET"/>',
      insertBefore: true,
    );

    // Add API key if provided
    if (mapKey != null) {
      await FileService.updateFile(
        fullPath: '$projectPath/$_manifestPath',
        target: '</application>',
        check: 'android:name="com.google.android.geo.API_KEY"',
        add: '''
        <meta-data 
            android:name="com.google.android.geo.API_KEY"
            android:value="$mapKey" />''',
        insertBefore: true,
      );
    }
    return true;
  }

  Future<void> iosConfig(String projectPath, [String? mapKey]) async {
    final delegateType = await _getIosDelegateType(projectPath);

    if (delegateType == DelegateType.swift) {
      await _configureSwiftDelegate(projectPath, mapKey);
    } else {
      await _configureObjectiveCDelegate(projectPath, mapKey);
    }

    await _updateInfoPlist(projectPath, mapKey);
  }

  Future<void> _configureSwiftDelegate(
    String projectPath,
    String? mapKey,
  ) async {
    await FileService.updateFile(
      fullPath: '$projectPath/$_delegateSwiftPath',
      target: 'import Flutter',

      add: 'import GoogleMaps',
    );

    if (mapKey != null) {
      await FileService.updateFile(
        fullPath: '$projectPath/$_delegateSwiftPath',
        target: ') -> Bool {',
        check: 'GMSServices.provideAPIKey',
        add: '    GMSServices.provideAPIKey("$mapKey")',
      );
    }
  }

  Future<void> _configureObjectiveCDelegate(
    String projectPath,
    String? mapKey,
  ) async {
    await FileService.updateFile(
      fullPath: '$projectPath/$_delegateObjectiveCPath',
      target: 'GeneratedPluginRegistrant.h',
      add: '#import "GoogleMaps/GoogleMaps.h',
    );

    if (mapKey != null) {
      await FileService.updateFile(
        fullPath: '$projectPath/$_delegateObjectiveCPath',
        target: 'didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {',
        check: 'GMSServices provideAPIKey',
        add: '  [GMSServices provideAPIKey:@"$mapKey"];',
      );
    }
  }

  Future<void> _updateInfoPlist(String projectPath, [String? mapKey]) async {
    if (mapKey != null) {
      await FileService.updateFile(
        fullPath: '$projectPath/$_infoPlistPath',
        target: '<dict>',
        check: 'GMSApiKey',
        add: '''
    <key>GMSApiKey</key>
    <string>$mapKey</string>
    
''',
      );
    }
    await FileService.updateFile(
      fullPath: '$projectPath/$_infoPlistPath',
      target: '<dict>',
      check: 'NSLocationWhenInUseUsageDescription',
      add: '''
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to show the map accurately.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need your location to show the map accurately even when the app is in the background.</string>
''',
    );
  }

  Future<void> addDemoMap(String projectPath) async {
    final mainFile = File(join(projectPath, _mainPath));
    await mainFile.writeAsString('''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps Demo")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}''');
  }

  Future<DelegateType> _getIosDelegateType(String projectPath) async {
    final swiftDelegate = File(join(projectPath, _delegateSwiftPath));
    if (swiftDelegate.existsSync()) {
      return DelegateType.swift;
    }
    return DelegateType.objectiveC;
  }
}
