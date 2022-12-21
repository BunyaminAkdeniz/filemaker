import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../screens/is_emri_detail_page.dart';

class RecordTile extends StatelessWidget {
  String sipNo;
  var mainId;
  String jobName;
  String company;
  String subCompany;
  var seciliGrup;
  bool isDetail;
  RecordTile(
      {this.isDetail = false,
      required this.company,
      required this.mainId,
      this.subCompany = "",
      required this.jobName,
      required this.seciliGrup,
      required this.sipNo,
      Key? key})
      : super(key: key);

  Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return (seciliGrup == "" || (seciliGrup == sipNo))
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => isDetail
                  ? null
                  : seciliGrup != ""
                      ? Get.offAll(
                          IsEmriDetailPage(seciliGrup: seciliGrup.toString()))
                      : null,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [],
                      ),
                      Text(
                        company,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      subCompany == "" ? SizedBox() : Text(subCompany ?? ""),
                      SizedBox(height: 10),
                      Text(
                        sipNo,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        jobName ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      !isDetail
                          ? seciliGrup != ""
                              ? Text("Grubu gör")
                              : Text("Herhangi bir grup yok")
                          : SizedBox(),
                      Text(mainId.toString()),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
