import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


  class logincontroller extends GetxController{
  FirebaseAuth auth=FirebaseAuth.instance;

   var useremail="";
   var userid="";
   var typeuser="";
   var lastsignintime;

  Future signin(user_email,user_password) async{
    try {

      UserCredential result=await auth.signInWithEmailAndPassword(email: user_email, password:user_password);
      User? user=result.user;
      userid=user!.uid;
      useremail=user_email;

      print(useremail);
      update();
      lastsignintime=auth.currentUser?.metadata.lastSignInTime ;
      update();


     return user;

    }catch(e)
    {

      print(e.toString());
      return null;
    }

  }



  Future signup(user_email,user_password) async{
    try {

   UserCredential result= await auth.createUserWithEmailAndPassword(email: user_email, password:user_password);
     User? user=result.user;
     userid=user!.uid;
     useremail=user_email;

     update();
   return user;
       }catch(e)
    {
      print(e.toString());
      return null;

    }
  }

Future signout() async{
    auth.signOut();
}

Future getlistofusers() async {
    var k=0;
    var type="";
    var collectiongroupusers = FirebaseFirestore.instance.collection('department');
    var querySnapshotgroupusers= await collectiongroupusers.get();
    for (var doc in querySnapshotgroupusers.docs) {
     List l=doc.get("listofusers");
     print(l);
     l.map((e) {
       if(e!="") {
         if (e["name"] == useremail) {
           if (e["typeuser"] == "admin") {
            // Get.off(repaircardadmin());
           }
           else {
            // Get.off(forwordtouser());
           }
         }
       }
     }).toList();

    }


  }

  @override
  void onInit() {
     super.onInit();
  }
}
