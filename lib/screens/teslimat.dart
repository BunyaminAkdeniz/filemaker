import 'package:filamejer/controllers/controller.dart';
import 'package:filamejer/model/is_emri_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/services.dart';
import '../widgets/record_tile.dart';

class TeslimatScreen extends StatefulWidget {
  const TeslimatScreen({Key? key}) : super(key: key);

  @override
  State<TeslimatScreen> createState() => _TeslimatScreenState();
}

class _TeslimatScreenState extends State<TeslimatScreen> {
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
          future: CacheHelper().getTeslimatList(),
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
              print(controller.list.length);
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
