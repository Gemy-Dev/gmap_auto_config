import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmap_auto_config/screen/process_time_line.dart';
import 'package:path/path.dart' as p;

import '../controller/integration.dart';

class IntegrationScreen extends StatelessWidget {
  const IntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IntegrationBloc>();

    return BlocConsumer<IntegrationBloc, IntegrationState>(
      listener: (context, state) {
        if (state is ProjectSelected) {
          bloc.add(IntegratePackageEvent());
        } else if (state is PackageIntegrated) {
          _promptForApiKey(context).then((apiKey) {
            bloc.add(SetApiKeyEvent(apiKey));
          });
        } else if (state is ApiKeySet) {
          bloc.add(ConfigureAndriodEvent());
        } else if (state is AndriodConfigured) {
          bloc.add(ConfigureIosEvent());
        } else if (state is IosConfigured) {
          bloc.add(AddDemoMapEvent());
        } else if (state is IntegrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Flutter Package Integrator")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is IntegrationInitial || state is Compleate)
                  OutlinedButton.icon(
                    onPressed: () => _selectProject(context),
                    icon: const Icon(Icons.drive_folder_upload_rounded),
                    label: const Text("Select Flutter Project"),
                  ),
                const SizedBox(width: double.infinity, child: ProcessTimeLine()),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectProject(BuildContext context) async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) return;

    final pubspecFile = File(p.join(directoryPath, 'pubspec.yaml'));
    if (pubspecFile.existsSync()) {
      // ignore: use_build_context_synchronously
      context.read<IntegrationBloc>().add(SelectProjectEvent(directoryPath));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This is not a Flutter project')),
      );
    }
  }

  Future<String?> _promptForApiKey(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? apiKey;
        return AlertDialog(
          title: const Text("Enter Google Maps API Key"),
          content: TextField(
            onChanged: (value) => apiKey = value,
            decoration: const InputDecoration(hintText: "API Key"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Skip"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, apiKey),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}