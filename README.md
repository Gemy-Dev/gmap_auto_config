# Google Maps Flutter Auto Integration 

# App Arcitecture
lib/
├── controller/
│   └── integration_bloc/
│       ├── integration_event.dart
│       ├── integration_state.dart
│       └── integration_bloc.dart
│
├── screen/
│   ├── select_project_screen.dart
│   └── process_time_line.dart
│
├── service/
│   ├── integration_service.dart
│   ├── pubspec_manager.dart
│   └── service_helper.dart
│
├── utils/
│   └── color.dart

this app helps you to select flutter project and add [google_maps_flutter] 
auto and integrate it with andriod congigration and ios configration with add api key

# steps

[1][select project] folder if it's not have [pubspec.yaml] it show you message this is not flutte project
    if project have [pubspec.yaml] file it will containu to step get it it will

[2][Integrate Package] first  try to get version from api if have any error,
    it add package like this [google_maps_flutter:any]
    then it will use [Process.run] to run [flutter pub get][] 

[3][Map Api Key] here show dialog to user to ask him to add api key to use it when integration with [android]
    and [ios] if user skip this it will not inclouded to the [AndroidManifest.xml] and [AppDelegate.swift] or [AppDelegate.m] and [info.plist]

[4][Andriod Configuration]  first check and add [INTERNET] premision and check if key is provide add it if not s s   skip this step
[5][IOS Configuration] check wich file found [AppDelegate.swift] or [AppDelegate.m] and add import google line and
    check if [mapKey] provide add it 
    then chek [info.plist] and add [mapKey] if you wand to use it or some packge mybe need it in [info.plist]
    and add to line to description of asking  location

[6] the last step of remove all content in the [main.dart] file and add demo map content # gmap_auto_config
