import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/provider/calendar_time_provider.dart';
import 'package:todo_app/presentation/provider/time_provider.dart';
import 'package:todo_app/presentation/screens/page/today_page.dart';
import 'package:todo_app/presentation/screens/todo_home_screen.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => SelectedTimeChangeProvider())
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context , child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.grey),
              home:  TodoHomeScreen(),
            );
          }
      ),
    );
  }
}