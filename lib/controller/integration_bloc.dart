import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmap_auto_config/service/integration_service.dart';

import 'integration.dart';

enum ProcessState { completed, failed, non }

class IntegrationBloc extends Bloc<IntegrationEvent, IntegrationState> {
  final IntegrationService service = IntegrationService();
  var processes = List.filled(6, ProcessState.non);

  String? _projectPath;
  String? _apiKey;

  IntegrationBloc() : super(IntegrationInitial()) {
    on<SelectProjectEvent>(_onSelectProject);
    on<IntegratePackageEvent>(_onIntegratePackage);
    on<SetApiKeyEvent>(_onSetApiKey);
    on<ConfigureAndriodEvent>(_onAndroidConfigure);
    on<ConfigureIosEvent>(_onIosConfigure);
    on<AddDemoMapEvent>(_onAddDemoMap);
  }

  Future<void> _onSelectProject(
    SelectProjectEvent event,
    Emitter<IntegrationState> emit,
  ) async {
    processes = List.filled(6, ProcessState.non);
    _projectPath = event.projectPath;
    processes[0] = ProcessState.completed;
    emit(ProjectSelected(event.projectPath));
  }

  Future<void> _onIntegratePackage(
    IntegratePackageEvent event,
    Emitter<IntegrationState> emit,
  ) async {
    if (_projectPath == null) {
      emit(IntegrationError("No project selected"));
      return;
    }

    try {
      await service.integrationPackage(_projectPath!);
      processes[1] = ProcessState.completed;
      emit(PackageIntegrated());
    } catch (e) {
      log(e.toString());
      processes[1] = ProcessState.failed;
      emit(IntegrationError("Failed to integrate package: $e"));
    }
  }

  void _onSetApiKey(SetApiKeyEvent event, Emitter<IntegrationState> emit) {
    if (_projectPath == null) {
      emit(IntegrationError("No project selected"));
      return;
    }

    _apiKey = event.apiKey;
    if (event.apiKey != null) {
      processes[2] = ProcessState.completed;
    }
    emit(ApiKeySet());
  }

  void _onAndroidConfigure(
    ConfigureAndriodEvent event,
    Emitter<IntegrationState> emit,
  ) {
    if (_projectPath == null) {
      emit(IntegrationError("No project selected"));
      return;
    }

    try {
      service.androidConfig(_projectPath!, _apiKey);
      processes[3] = ProcessState.completed;
      emit(AndriodConfigured());
    } catch (e) {
      processes[3] = ProcessState.failed;
      emit(IntegrationError("Android configuration failed: $e"));
    }
  }

  Future<void> _onIosConfigure(
    ConfigureIosEvent event,
    Emitter<IntegrationState> emit,
  ) async {
    if (_projectPath == null) {
      emit(IntegrationError("No project selected"));
      return;
    }

    try {
      await service.iosConfig(_projectPath!, _apiKey);
      processes[4] = ProcessState.completed;
      emit(IosConfigured());
    } catch (e) {
      processes[4] = ProcessState.failed;
      emit(IntegrationError("iOS configuration failed: $e"));
    }
  }

  Future<void> _onAddDemoMap(
    AddDemoMapEvent event,
    Emitter<IntegrationState> emit,
  ) async {
    if (_projectPath == null) {
      emit(IntegrationError("No project selected"));
      return;
    }

    try {
      await service.addDemoMap(_projectPath!);
      processes[5] = ProcessState.completed;
      emit(Compleate());
    } catch (e) {
      processes[5] = ProcessState.failed;
      emit(IntegrationError("Failed to add demo map: $e"));
    }
  }
}
