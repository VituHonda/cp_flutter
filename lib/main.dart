import 'package:cp_flutter/common/utils.dart';
import 'package:cp_flutter/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: kBackgoundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgoundColor,
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: kBackgoundColor,
          )),
      home: const BottomNavBar(),
    );
  }
}
