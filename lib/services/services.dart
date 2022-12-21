import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filamejer/controllers/controller.dart';
import 'package:filamejer/services/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/is_emri_model.dart';
import '../screens/home_screen.dart';

class CacheHelper {
  Controller controller = Get.put(Controller());
  final dio = Dio();
  var url = Uri.parse(
      'https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/sessions');

  Future<void> getTokenLogin(
      {required String userName, required String password}) async {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$userName:$password'))}';
    try {
      var response = await dio
          .post(
            "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/sessions",
            options: Options(
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
              validateStatus: (_) => true,
              method: 'POST',
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                'Authorization': basicAuth
              },
            ),
            onSendProgress: (int sent, int total) {},
          )
          .whenComplete(() {})
          .catchError((onError) {});
      if (response.statusCode == 200) {
        print("Başarılı");
        Map map = response.data["response"];
        controller.myToken = (map["token"]);
        UserSecureStorage.setUsername(userName);
        UserSecureStorage.setPassword(password);
        Get.offAll(MyHomePage());

        return response.data;
      } else {
        Get.snackbar("Hata", "Hatalı giriş");
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("GİRİŞ YAPARKEN HATA OLUŞTU");
      print("dio $e");
    }
  }

  refreshToken() async {
    String? userName = await UserSecureStorage.getUsername();
    String? password = await UserSecureStorage.getPassword();
    print("kayıtlı userName: $userName");
    print("kayıtlı şifre: $password");
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$userName:$password'))}';
    try {
      var response = await dio.post(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/sessions",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'POST',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': basicAuth
          },
        ),
        onSendProgress: (int sent, int total) {
          debugPrint("sent${sent.toString()}" + " total${total.toString()}");
        },
      ).whenComplete(() {
        debugPrint("complete:");
      }).catchError((onError) {
        debugPrint("error:${onError.toString()}");
      });
      if (response.statusCode == 200) {
        print("Başarılı");
        Map map = response.data["response"];
        controller.myToken = (map["token"]);
        print("Kod ${controller.myToken}");
        controller.isLogin = true;

        return response.data;
      } else {
        print("Hataaaa: ${response.statusCode}");
        controller.isLogin = false;
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  getYuklemeList() async {
    controller.list.value = [];
    var params = {
      "query": [
        {
          "YuklemeUlasim": "1",
          "JobStatus": "Ulasim",
          "SEVK_ServiSevkSofor": "=${await UserSecureStorage.getUsername()}",
        }
      ],
      "limit": "1000",
    };
    try {
      var response = await dio.post(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/_find",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'POST',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': "Bearer ${controller.myToken}"
          },
        ),
        data: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        print("Liste başarıyla getirildi");
        for (var i = 0; i < response.data["response"]["data"].length; i++) {
          Map<String, dynamic> json =
              response.data["response"]["data"][i]["fieldData"];
          String mainId = response.data["response"]["data"][i]["recordId"];
          var isEmri = IsEmriModel.fromJson(json);
          isEmri.mainId = mainId;
          print(isEmri.mainId);

          controller.list.add(isEmri);
        }
        return response.data;
      } else {
        print("Liste Getirilemiyor: ${response.statusCode}");
        await refreshToken();
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  getTeslimatList() async {
    controller.list.value = [];
    var params = {
      "query": [
        {
          "YuklemeUlasim": "2",
          "JobStatus": "Ulasim",
          "SEVK_ServiSevkSofor": "=${await UserSecureStorage.getUsername()}",
        }
      ],
      "limit": "1000",
    };
    try {
      var response = await dio.post(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/_find",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'POST',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': "Bearer ${controller.myToken}"
          },
        ),
        data: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        print("Liste başarıyla getirildi");
        for (var i = 0; i < response.data["response"]["data"].length; i++) {
          Map<String, dynamic> json =
              response.data["response"]["data"][i]["fieldData"];
          String mainId = response.data["response"]["data"][i]["recordId"];
          var isEmri = IsEmriModel.fromJson(json);
          isEmri.mainId = mainId;
          print(isEmri.mainId);

          controller.list.add(isEmri);
        }
        return response.data;
      } else {
        print("Liste Getirilemiyor: ${response.statusCode}");
        await refreshToken();
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  getSeciliGrupList(String seciliGrup) async {
    controller.list.value = [];
    var params = {
      "query": [
        {
          "SeciliGroup": seciliGrup,
        }
      ],
      "limit": "100",
    };

    {
      try {
        var response = await dio
            .post(
          "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/_find",
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            validateStatus: (_) => true,
            method: 'POST',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Authorization': "Bearer ${controller.myToken}"
            },
          ),
          data: jsonEncode(params),
        )
            .whenComplete(() {
          debugPrint("complete:");
        }).catchError((onError) {
          debugPrint("error:${onError.toString()}");
        });
        if (response.statusCode == 200) {
          print("Seçili grup listesi başarıyla getirildi");
          for (var i = 0; i < response.data["response"]["data"].length; i++) {
            Map<String, dynamic> json =
                response.data["response"]["data"][i]["fieldData"];
            String mainId = response.data["response"]["data"][i]["recordId"];
            var isEmri = IsEmriModel.fromJson(json);
            isEmri.mainId = mainId;

            controller.seciliGrupList.add(isEmri);
          }
          return response.data;
        } else {
          updateTeslimat(controller.currentRecordId.toString() ?? "", false);
          print(
              "Seçili grup lisetsi Liste Getirilemiyor: ${response.statusCode}");
          Get.offAll(MyHomePage());
          await refreshToken();
          throw {response.statusCode};
        }
      } on DioError catch (e) {
        print("AAAA");
        print(e);
      }
    }
  }

  getRecord(String recordID) async {
    print("RECORD ID: $recordID");
    var params = {
      "query": [
        {
          "SIP_NO": "=$recordID",
        }
      ],
      "limit": "1",
    };
    try {
      var response = await dio
          .post(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/_find",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'POST',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': "Bearer ${controller.myToken}"
          },
        ),
        data: jsonEncode(params),
      )
          .whenComplete(() {
        debugPrint("complete:");
      }).catchError((onError) {
        debugPrint("error:${onError.toString()}");
      });
      if (response.statusCode == 200) {
        print("Başarılı Kod");

        Map<String, dynamic> json =
            response.data["response"]["data"][0]["fieldData"];
        controller.firmaAdi = response.data["response"]["data"][0]["fieldData"]
            ["FIRMA::Customer_name"];
        controller.currentIsEmri = IsEmriModel.fromJson(json);
        controller.currentRecordId =
            response.data["response"]["data"][0]["recordId"];

        print(controller.currentIsEmri?.jobStatus);
        print(controller.currentIsEmri?.sEVKServiSevkSofor);
        print(controller.currentIsEmri?.yuklemeUlasim);
      } else {
        Get.offAll(MyHomePage());
        return null;
      }
      print("statüs koddan başarıyla geçtim");

      if (controller.currentIsEmri?.jobStatus == "Ulasim") {
      } else {
        Get.offAll(MyHomePage());
        return null;
      }

      if (controller.currentIsEmri?.yuklemeUlasim == "") {
        if (controller.currentIsEmri?.seciliGrup == "") {
          updateYuklemeUlasim(recordID, false);
        } else {
          topluUpdateUlasim(controller.currentIsEmri?.seciliGrup);
        }
      } else if (controller.currentIsEmri?.yuklemeUlasim == "1") {
        if (controller.currentIsEmri?.seciliGrup == "") {
          updateTeslimat(recordID, false);
        } else {
          topluUpdateUlasim(controller.currentIsEmri?.seciliGrup);
        }
      } else if (controller.currentIsEmri?.yuklemeUlasim == "2") {
        Get.offAll(MyHomePage());
        return null;
      }

      // Yükleme Ulaşım Başarılı
      if (controller.currentIsEmri?.jobStatus == "Ulasim" &&
          controller.currentIsEmri?.sEVKServiSevkSofor == "" &&
          controller.currentIsEmri?.yuklemeUlasim == "") {
        print("sipno ${controller.currentIsEmri?.sIPNO}");
        await topluUpdateUlasim(controller.currentIsEmri?.sIPNO.toString());
        Get.offAll(MyHomePage());
      } else {
        print("elseye girdim");
        if (controller.currentIsEmri?.jobStatus == "Ulasim") {
          print("ilk ife girdim");

          // Kullanıcı zaten görevi almış YuklemeUlasim 2 olacak ;
          if (controller.currentIsEmri?.sEVKServiSevkSofor ==
                  await UserSecureStorage.getUsername() &&
              controller.currentIsEmri?.yuklemeUlasim == "1") {
            print("teslimata geçiriyorum ${controller.currentIsEmri?.sIPNO}");
            await topluUpdateTeslimat(
                controller.currentIsEmri?.sIPNO.toString());
            Get.offAll(MyHomePage());
          }
          // paket başka birisi tarafından alınmış ;
          if (controller.currentIsEmri?.sEVKServiSevkSofor !=
              await UserSecureStorage.getUsername()) {
            print("paket başaksı almış");
            Get.defaultDialog(
                onConfirm: () {
                  print("record aiiidd aşağıda");
                  print(controller.currentRecordId);
                  updateYuklemeUlasim(controller.currentRecordId, false);

                  Get.offAll(MyHomePage());
                },
                onCancel: () => Get.back(),
                title: "Paket aktarılsın mı?",
                content: Text(
                    "Paket ${controller.currentIsEmri?.sEVKServiSevkSofor} tarafından alınmış, sana aktarılsın mı?"));
          }
        } else {
          print("paket alınamadı");
        }
      }
      ;

      /*else {
      */ /*  Get.offAll(MyHomePage());

        Get.snackbar("Hata", "Sistemde böyle bir kayıt yok",
            backgroundColor: Colors.red, colorText: Colors.white);
        print("Hataaaa: ${response.statusCode}");
        throw {response.statusCode};*/ /*
      }*/
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  updateYuklemeUlasim(String recordID, bool isToplu) async {
    String? username = await UserSecureStorage.getUsername();
    var params = {
      "fieldData": {
        "JobStatus": "Ulasim",
        "YuklemeUlasim": "1",
        "SEVK_ServiSevkSofor": username,
        "SEVK_SoforTeslimAlmaZamani": dateFormat(),
        //  DateTime.now().millisecondsSinceEpoch.toString(),
      }
    };
    try {
      var response = await dio
          .patch(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/records/$recordID",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'PATCH',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': "Bearer ${controller.myToken}"
          },
        ),
        data: jsonEncode(params),
      )
          .whenComplete(() {
        debugPrint("complete:");
      }).catchError((onError) {
        debugPrint("error:${onError.toString()}");
      });
      if (response.statusCode == 200) {
        isToplu ? null : Get.snackbar("Başarılı", "Statü Güncellendi");
      } else {
        Get.snackbar("Hata", "Update edemedim");
        print("Hataaaa: ${response.statusCode}");
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  topluUpdateUlasim(seciliGrup) async {
    controller.seciliGrupList.value = [];
    await getSeciliGrupList(seciliGrup);
    print("şu an liste uzunluğu ${controller.seciliGrupList.length}");
    for (var i in controller.seciliGrupList) {
      updateYuklemeUlasim(
          i.mainId, controller.seciliGrupList.length == 1 ? false : true);
    }
  }

  updateTeslimat(String recordID, bool isToplu) async {
    var params = {
      "fieldData": {
        "YuklemeUlasim": "2",
      }
    };
    try {
      var response = await dio
          .patch(
        "https://91.93.45.202/fmi/data/vLatest/databases/NOSDEV/layouts/ISEMRITEMP/records/$recordID",
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
          method: 'PATCH',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization': "Bearer ${controller.myToken}"
          },
        ),
        data: jsonEncode(params),
      )
          .whenComplete(() {
        debugPrint("complete:");
      }).catchError((onError) {
        debugPrint("error:${onError.toString()}");
      });
      if (response.statusCode == 200) {
        print("Başarılı Kod");
        isToplu ? null : Get.snackbar("Başarılı", "Statü Güncellendi");
      } else {
        Get.snackbar("Hata", "Update edemedim");
        print("Hataaaa: ${response.statusCode}");
        throw {response.statusCode};
      }
    } on DioError catch (e) {
      print("AAAA");
      print(e);
    }
  }

  topluUpdateTeslimat(seciliGrup) async {
    controller.seciliGrupList.value = [];
    await getSeciliGrupList(seciliGrup);
    print("şu an liste uzunluğu ${controller.seciliGrupList.length}");
    for (var i in controller.seciliGrupList) {
      updateTeslimat(
          i.mainId, controller.seciliGrupList.length == 1 ? false : true);
    }
  }

  String dateFormat() {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm:ss');
    final String formatted = formatter.format(now);
    print(formatted);
    return formatted;
  }
}
