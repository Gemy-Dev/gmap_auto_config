// process_time_line.dart
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmap_auto_config/controller/integration_bloc.dart';
import 'package:gmap_auto_config/controller/integration_state.dart';
import 'package:gmap_auto_config/utils/colors.dart';

class ProcessTimeLine extends StatefulWidget {
  const ProcessTimeLine({super.key});

  @override
  createState() => _ProcessTimeLineState();
}

class _ProcessTimeLineState extends State<ProcessTimeLine> {
  int activeStep = 0;
  
  final processIcons = [
    (Icons.folder_zip_sharp, 'Select Project'),
    (Icons.downloading, 'Integrate Package'),
    (Icons.key_outlined, 'Map API Key'),
    (Icons.android, 'Android Configuration'),
    (Icons.apple, 'iOS Configuration'),
    (Icons.map, 'Add Demo Map'),
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IntegrationBloc>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<IntegrationBloc, IntegrationState>(
        builder: (context, state) {
          return EasyStepper(
            activeStep: activeStep,
            stepShape: StepShape.rRectangle,
            stepBorderRadius: 15,
            borderThickness: 2,
            stepRadius: 28,
            finishedStepTextColor: AppColor.success,
            showLoadingAnimation: false,
            steps: [
              for (int i = 0; i < processIcons.length; i++)
                EasyStep(
                  customStep: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: bloc.processes[i] == ProcessState.completed
                          ? AppColor.success
                          : AppColor.unSelected,
                      child: Icon(processIcons[i].$1, color: Colors.white),
                    ),
                  ),
                  customTitle: Text(
                    processIcons[i].$2,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            onStepReached: (index) => setState(() => activeStep = index),
          );
        },
        listener: (context, state) {
          final result = _handleState(state);
          if (result != null) {
            setState(() => activeStep = result);
          }
        },
      ),
    );
  }

  int? _handleState(IntegrationState state) {
    return switch (state) {
      IntegrationInitial() => null,
      ProjectSelected() => 1,
      PackageIntegrated() => 2,
      ApiKeySet() => 3,
      AndriodConfigured() => 4,
      IosConfigured() => 5,
      Compleate() => 6,
      IntegrationError() => null,
    };
  }
}