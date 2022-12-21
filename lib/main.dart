import 'dart:io';

import 'package:filamejer/screens/home_screen.dart';
import 'package:filamejer/screens/login/login.dart';
import 'package:filamejer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  Controller controller = Get.put(Controller());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: CacheHelper().refreshToken(),
        builder: (context, snapshot) {
          print("şu an login mi ${controller.isLogin}");
          print("şu an loading mi ${controller.isLoading}");
          if (snapshot.hasData) {
            return MyHomePage();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
