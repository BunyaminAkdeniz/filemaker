import 'package:filamejer/screens/login/login.dart';
import 'package:filamejer/screens/qr_screen.dart';
import 'package:filamejer/services/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Controller controller = Get.put(Controller());

  getUsername() async {
    controller.userName.value = await UserSecureStorage.getUsername() ?? "";
  }

  @override
  initState() {
    getUsername();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // CacheHelper().updateYuklemeUlasim("1404533", "");
            Get.to(() => const QRScreen());
          },
          child: const Icon(Icons.qr_code),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(controller.userName.value),
          actions: [
            IconButton(
              onPressed: () {
                UserSecureStorage.setUsername("");
                UserSecureStorage.setPassword("");
                Get.offAll(LoginScreen());
                setState(() {});
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: controller.pageList[controller.pageIndex.value],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.pageIndex.value,
            onTap: (int pageIndex) {
              controller.pageIndex.value = pageIndex;
            },
            items: const [
              BottomNavigationBarItem(
                  label: "Yükleme", icon: Icon(Icons.upload)),
              BottomNavigationBarItem(
                  label: "Teslimat", icon: Icon(Icons.share_arrival_time))
            ]),
      ),
    );
  }
}
