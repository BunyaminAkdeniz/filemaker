import 'package:filamejer/controllers/controller.dart';
import 'package:filamejer/model/is_emri_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/services.dart';
import '../widgets/record_tile.dart';

class YuklemeScreen extends StatefulWidget {
  const YuklemeScreen({Key? key}) : super(key: key);

  @override
  State<YuklemeScreen> createState() => _YuklemeScreenState();
}

class _YuklemeScreenState extends State<YuklemeScreen> {
  @override
  void initState() {
    controller.list.value = [];
    super.initState();
  }

  @override
  Controller controller = Get.put(Controller());
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: CacheHelper().getYuklemeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  List myList = controller.list;
                  IsEmriModel isEmri = myList[index];
                  return RecordTile(
                    subCompany: isEmri.subeName,
                    company: isEmri.firmaName,
                    jobName: isEmri.jobName,
                    sipNo: isEmri.sIPNO.toString(),
                    seciliGrup: isEmri.seciliGrup.toString(),
                    mainId: isEmri.mainId,
                  );
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              CacheHelper().refreshToken();
              print("token yenileyeceğim");
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
