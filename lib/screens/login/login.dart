import 'package:flutter/material.dart';

import '../../services/services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Giriş Yap",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              CircleAvatar(
                radius: 32,
                child: Icon(Icons.person),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kullanıcı adını giriniz';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Kullanıcı adı",
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32))),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: passController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifreyi girin';
                  }
                  return null;
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: "Şifre",
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32))),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    print("yazılan name: ${nameController.text}");
                    print("yazılan pass: ${passController.text}");
                    await CacheHelper().getTokenLogin(
                        userName: nameController.text,
                        password: passController.text);
                  }
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.orange),
                  child: Center(
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
