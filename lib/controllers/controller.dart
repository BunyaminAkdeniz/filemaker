import 'package:filamejer/model/is_emri_model.dart';
import 'package:filamejer/screens/teslimat.dart';
import 'package:filamejer/screens/yukleme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var userName = "".obs;
  bool isLogin = false;
  var isLoading = true.obs;
  var myToken = "";
  List<Widget> pageList = [YuklemeScreen(), TeslimatScreen()];
  var pageIndex = 0.obs;
  IsEmriModel? currentIsEmri;
  var currentRecordId = "";
  var isEmriDetailList = <IsEmriModel>[].obs;
  var seciliGrupList = <IsEmriModel>[].obs;
  var list = <IsEmriModel>[].obs;

  //FIRMA
  var firmaAdi = "";
  var firmaAdiTest = "";
  var subeAdi = "";
  var firmaRecordID = "";
}
