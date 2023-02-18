import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:async/async.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logincontroller.dart';

class taskcontroller extends GetxController {
  List status=["new","pending","done"];
 var mystatus="";
  logincontroller controller = Get.find<logincontroller>();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference collectiontask = FirebaseFirestore.instance
      .collection("task");

  Future createtask(fromuser, touser, taskname, taskdetails, fromdate, todate,
      status) async {
    print('chat date');
    await collectiontask.doc(
        fromuser + "_" + touser + "_" + DateTime.now().toString()).set
      (
        {
          "fromuser": fromuser,
          "touser": touser,
          "taskname": taskname,
          "takdetails": taskdetails,
          "fromdate": fromdate,
          "todate": todate,
          "status": status,
          "arrayfromto":[fromuser,touser]
        }
    );
  }


  Stream<QuerySnapshot> alltask() async* {
    var m = FirebaseFirestore.instance.collection('task')
         .orderBy('fromdate', descending: true)
        .where('arrayfromto',  arrayContainsAny: [controller.useremail])
        .snapshots();

    yield* m;
  }





  


  Future updatetask(status,id) async {

    await collectiontask.doc(id).update
      (
        {

          "status": status
        }
    );
  }






  void setSelected(value,id){
    mystatus = value;
    updatetask(value,id);
  update();

  }



}