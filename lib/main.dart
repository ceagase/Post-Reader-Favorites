import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finals_lab_exam/screens/posts.dart';
import 'package:finals_lab_exam/screens/favorites.dart';
import 'package:finals_lab_exam/screens/post_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Reader & Favorites',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
          error: Colors.grey.shade700,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        cardTheme: CardThemeData(color: Colors.grey.shade200),
        dialogTheme: DialogThemeData(backgroundColor: Colors.grey.shade200),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey.shade900,
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Posts(),
        "/favorites": (context) => const Favorites(),
        "/post_details": (context) => const PostDetails(),
      },
    );
  }
}
