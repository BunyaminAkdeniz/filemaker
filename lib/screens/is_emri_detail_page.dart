import 'package:filamejer/screens/home_screen.dart';
import 'package:filamejer/widgets/record_detail_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../model/is_emri_model.dart';
import '../services/services.dart';

class IsEmriDetailPage extends StatefulWidget {
  String seciliGrup;
  IsEmriDetailPage({required this.seciliGrup, Key? key}) : super(key: key);

  @override
  State<IsEmriDetailPage> createState() => _IsEmriDetailPageState();
}

class _IsEmriDetailPageState extends State<IsEmriDetailPage> {
  @override
  void initState() {
    controller.isEmriDetailList.value = [];
    super.initState();
  }

  @override
  Controller controller = Get.put(Controller());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () => Get.offAll(MyHomePage()),
      )),
      body: FutureBuilder(
          future: CacheHelper().getSeciliGrupList(widget.seciliGrup.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: controller.seciliGrupList.length,
                itemBuilder: (context, index) {
                  List myList = controller.seciliGrupList;
                  IsEmriModel isEmri = myList[index];
                  return RecordDetailTile(
                    subCompany: isEmri.subeName,
                    company: isEmri.firmaName,
                    jobName: isEmri.jobName,
                    sipNo: isEmri.sIPNO.toString(),
                    seciliGrup: widget.seciliGrup,
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
              return const Center(
                child: Text("Hiç üzerine aldığın Yükleme işi yok."),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
