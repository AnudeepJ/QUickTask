import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/routes/app_router.dart';
import 'package:task_manager_app/bloc_state_observer.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:task_manager_app/tasks/data/repository/task_repository.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '6UQ9FC6PNLeK8jkZrfOgpMWG9a4wME1Alf4IHIF4';
  final keyClientKey = 'LnLGUK49NTcsS0ucFT6762i7MrHfvPT4svJ0rSKl';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);



  Bloc.observer = BlocStateOberver();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    preferences: preferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) =>
            TaskRepository(taskDataProvider: TaskDataProvider(preferences)),
        child: BlocProvider(
            create: (context) => TasksBloc(context.read<TaskRepository>()),
            child: MaterialApp(
              title: 'Task Manager',
              debugShowCheckedModeBanner: false,
              initialRoute: Pages.initial,
              onGenerateRoute: onGenerateRoute,
              theme: ThemeData(
                fontFamily: 'Sora',
                visualDensity: VisualDensity.adaptivePlatformDensity,
                canvasColor: Colors.transparent,
                colorScheme: ColorScheme.fromSeed(seedColor: KGreenShade),
                useMaterial3: true,
              ),
            )));
  }
}
