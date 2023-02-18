import 'package:chat/screen/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/logincontroller.dart';
import 'package:get/get.dart';

import 'chatuser.dart';

class login extends StatelessWidget {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    logincontroller controller = Get.put(logincontroller());
    TextEditingController user_email = TextEditingController();
    TextEditingController user_password = TextEditingController();
    TextEditingController user_type = TextEditingController();
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/whatsappbackground.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff25D366),
            elevation: 0.0,
            centerTitle: true,
            title: Text('Login', style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Get.to(signup());
                  }),
            ],
          ),
          body: WillPopScope(
            onWillPop: () {
              Get.defaultDialog(
                  title: 'Alarm',
                  middleText: 'do you want to exit from app',
                  actions: [
                    ElevatedButton(onPressed: () {}, child: Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('NO')),
                  ]);
              return Future.value(true);
            },
            child: Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: user_email,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                label: Text('Email')),
                            validator: (val) {
                              if (val == null || val == "") {
                                return "You must enter a name";
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: user_password,
                            validator: (val) {
                              if (val == null || val == "") {
                                return "You must enter a password";
                              }
                            },
                            obscureText: true,
                            // controller:controller.password ,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.lock_clock_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                label: Text('Password')),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: MaterialButton(
                              onPressed: () async {
                                //we define dynamic because return maybe userfirbase or null
                                if (formkey.currentState!.validate()) {
                                  User result = await controller.signin(
                                      user_email.text, user_password.text);
                                  if (result != null) {
                                    Get.offAll(chatusers());
                                    //now create collection for users
                                    // await dbcontroller.createuserid(controller.userid,controller.useremail)?.then((value) async {

                                    //  });
                                    print('user exist');
                                  } else {
                                    print('null');
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Sign In'),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 100),
                          Container(
                              width: 200,
                              height: 200,
                              child: Image.asset('assets/chat.png')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
