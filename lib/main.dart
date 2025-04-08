import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gmap_auto_config/screen/select_project_screen.dart';
import 'package:gmap_auto_config/utils/colors.dart';

import 'controller/integration.dart';

void main() {
  Bloc.observer = CustomBlocObserver();
  runApp(
    BlocProvider(create: (context) => IntegrationBloc(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(20),
            iconColor: AppColor.primary,

            backgroundColor: const Color.fromARGB(255, 228, 227, 227),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          elevation: 0,
        ),
        primaryColor: Colors.blueGrey,
        useMaterial3: false,
      ),
      home: IntegrationScreen(),
    );
  }
}

class CustomBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
