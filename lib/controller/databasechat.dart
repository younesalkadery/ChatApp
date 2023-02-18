import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


import '../screen/chatind.dart';
import '../screen/chatprivate.dart';

import 'logincontroller.dart';
import 'package:firebase_storage/firebase_storage.dart';
class databasechat extends GetxController with WidgetsBindingObserver {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference collectionchatroom = FirebaseFirestore.instance
      .collection("chatroom");
  CollectionReference collectionusers = FirebaseFirestore.instance.collection(
      "users");
  CollectionReference collectionchatmessage = FirebaseFirestore.instance
      .collection("chatmessage");
  CollectionReference collectionchatroomdate = FirebaseFirestore.instance
      .collection("chatroomdate");
  CollectionReference collectiongroupname = FirebaseFirestore.instance
      .collection("groupname");
  CollectionReference collectionaddusertogroup = FirebaseFirestore.instance
      .collection("groupusers");
  CollectionReference collectionmessagecount = FirebaseFirestore.instance
      .collection("messagecount");

  logincontroller controller = Get.find<logincontroller>();


  StreamController mystream = StreamController();

  //the listuser is a list of map has [{"useremail":"user or group"...,type:"user or group"}]
  List listusersgroup =[];
  Set usercombo={};
   //this list is for chatgroup screen that represent the list of user in the created group
  Set listusergroup={};
  List listofuser=[];
  var checklist = [];
  var errorname = "";
  var touser = "";
  var tousertype = "";
  var loadstate = 1;
  var selecteduser="";
  var i = 0;
  var nodata = "لا يوجد اعطال";
  int testload=0;
  Color iconcolor = Colors.cyan;
  String fixcolor = "";
  String chatroomid = "";
  String groupid = "";
  List listmessage = [];
  var fromtomessagecount="";
  var tofrommessagecount="";
  late DateTime lastseentime;
  var online="0";
  var myc="";
  var on=0;
  List userandgroups = [];
  List userbelongtogroup=[];
  List listg=[];
/////this for firestorage////////
  File? filepath;
  var filename="";
  var  fileurl="";
 FirebaseStorage storage=FirebaseStorage.instance;
////////////////////////////////
  var d = DateFormat('dd-MM-yyyy').format(DateTime.now());



  checkroomid(to,testgrouporuser) async {

   // we must check roomid it must be unique with format first one
    // who will start chat will create chat roomid with his mail then underscore
    // then user email for the reciver : younes@gmail.com_rami@gmail.com
    //when the reciver want to chat at any time for ever with this sender
    // the chat room id will not created again even if rami want to start new
    //chat the chat room id will stay as :younes@gmail.com_rami@gmail.com
    chatroomid = "";
    update();
    var collection = FirebaseFirestore.instance.collection('chatroom');
    var querySnapshot = await collection.get();
    //if chat not exist at all create it
    if (querySnapshot.docs.length == 0) {
      //If chat room id not exist created for user must be fromuseremail then
      //underscor then to the reciver email
      print("oooooooooooooooooooo");
      if(testgrouporuser=="user")
      {
        var chatroomid0 = controller.useremail + "_" + to;
        chatroomid = chatroomid0;
        update();

      }
      else
        // for group must be the name
        //of the group created before which is uniqe
       {
         var chatroomid0 =to;
         chatroomid = chatroomid0;
         update();
       }
    }
    else {
      for (var doc in querySnapshot.docs) {
        //now check if chat room exist before will check the chat room id
        //and not created again as we say according to the sender
         if(testgrouporuser=="user"){
           print("uuuuuuuuuuu");
           if (doc.id == controller.useremail + "_" + to ||
               doc.id == to+ "_" + controller.useremail) {
             var chatroomid0 = doc.id;
             chatroomid = chatroomid0;
             update();
             break;
           }
           else {
             if(doc.id==to){


             }
             else
               {
                 var chatroomid0 =controller.useremail + "_" + to;
                 chatroomid = chatroomid0;
                 update();
               }

           }
        }
         ////////////////////now for group chat room will be the name of groupnameid////
         else
        {
          if(doc.id==to )
          {
            var chatroomid0 = doc.id;
            chatroomid = chatroomid0;
            update();
            break;
          }
          else
          {
            var chatroomid0 =to;
            chatroomid = chatroomid0;
            update();
          }
        }
      }
    }

    createchatroom(chatroomid,to);
    print('in check state');
    print(chatroomid);
  }

  Future createchatroom(chatroomid,to) async {
    await collectionchatroom.doc(chatroomid)
        .set(
        {
          "fromuseremail": controller.useremail,
          "touseremail": to,


        }
    );
    checkroomdate(chatroomid);
  }

//The chatroomdate for every chatroomid must be uniqe for everyday
  checkroomdate(chatroomid) async {
    var collection = FirebaseFirestore.instance.collection('chatroomdate');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      if (doc["chatroomdate"] == d) {
        var i = 1;
        break;
      }
    }

    if (i != 1) {
      createchatdate(chatroomid);
    }
  }


  Future createchatdate(chatroomid) async {
    print('chat date');
    await collectionchatroomdate.doc(chatroomid + "_" + d.toString()).set
      (
        {
          "chatroomdate": d,
          "chatroomid": chatroomid
        }
    );
  }

  Future createchat(fromuseremail, touseremail,type, message,filename,fileurl,typemessage) async {


      await collectionchatmessage.doc(
          chatroomid + "_" + DateTime.now().toString()).set
        (
          {
            "fromuseremail": controller.useremail,
            "touseremail": touser,
            "message": message,
            "createddate": FieldValue.serverTimestamp(),
            "chatroomdate": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),
            "chatroomid": chatroomid,
            "read":"no",
            "typemessage":typemessage,
            "filename":filename,
            "fileurl":fileurl
         }
      );



      CollectionReference collection = FirebaseFirestore.instance.collection('chatmessage');
      QuerySnapshot q = await collection.get();
      CollectionReference collectionpage = FirebaseFirestore.instance.collection('page');
      /////////Test if user on the chat page when i send message so the user see the message///
      ////////so i will check the page of user if its chat page or else///
      ///////after that i will mark read yes if its chat page////////////
      DocumentSnapshot doc = await collectionpage.doc(touser).get();
      if(doc.get("mypage")=="/chatind"){
        setmessagetoreadwhensendmessage();
      }
      else
     {

     }
      countmessagesent(fromuseremail,touseremail,type,message);

  }

  Future setmessagetoreadwhensendmessage() async{
    CollectionReference collection = FirebaseFirestore.instance.collection('chatmessage');
    QuerySnapshot q = await collection.get();
    q.docs.forEach((e) {
      if(e.get("fromuseremail")==controller.useremail && e.get("touseremail")==touser){
        collection.doc(e.id).update({
          "read":"yes"
        });
      }
    });

  }

  Future setmessagetoread() async{

    CollectionReference collection = FirebaseFirestore.instance.collection('chatmessage');
    QuerySnapshot q = await collection.get();
    q.docs.forEach((e) {
      if(e.get("fromuseremail")==touser && e.get("touseremail")==controller.useremail){
        collection.doc(e.id).update({
          "read":"yes"
        });
      }
    });

  }




  countmessagesent(fromuseremail,touseremailm,type,message) async{

  var i=0;
    var collectioncountmessage = FirebaseFirestore.instance.collection('messagecount');
    var querySnapshotgroupusers= await collectioncountmessage.get();
    for (var doc2 in querySnapshotgroupusers.docs) {
      if(type=="user") {
        if (doc2.id == controller.useremail + "_" + touser) {
          print("uuuuuuuuuuuser");
          print(doc2.data()["tousers"][0]);
          i = 1;
          var n = doc2.data()["count"];

          await collectioncountmessage.doc(controller.useremail + "_" + touser)
              .update
            (

              {
                "count": ++n,
                "from": controller.useremail,
                "tousers": [{"name":touser,"count":doc2.data()["tousers"][0]["count"]+1}],
                "lastmessage": message,
                "timesent": FieldValue.serverTimestamp(),
                "type":"user"
              }
          );
        }
      }
      else//Now for group we will test if exist or new
        {
          if(doc2.id ==touseremailm)
          {
           Map u={};
           List l=[];
            for(var z=0;z<listofuser.length;z++){
              u={
                "name":listofuser[z],
                "count":doc2.data()["tousers"][z]["count"]+1,
              };
              l.add(u);

              print(l);
            }
            print(doc2.id);
            print(touseremailm);
            print("dddddddddddsssssssssssssssss");
            await collectioncountmessage.doc(touseremailm)
                .update
              (
                {
                  "count": doc2.data()["count"]+1,
                  "from": controller.useremail,
                  "to":touser,
                  "tousers":l,
                  "lastmessage": message,
                  "timesent": FieldValue.serverTimestamp(),
                  "type":"group"
                }
            );
            print(doc2.data());
            i = 1;
                 break;
          }
          else
            {
              print("dddddddddddsssssssssssssssss3333333333");
              Map u={};
              List l=[];
              for(var z=0;z<listofuser.length;z++) {
                u = {
                  "name":listofuser[z],
                  "count":1,
                };
                l.add(u);
              }

              await collectioncountmessage.doc(touseremailm)
                  .set
                (

                  {
                    "count": 1,
                    "from": controller.useremail,
                    "to":touser,
                    "tousers":l,
                    "lastmessage": message,
                    "timesent": FieldValue.serverTimestamp(),
                    "type":"group"
                  }
              );
              i = 1;

            }



        }
    }
    //this section for the first time if no document exist will
  // create new one
    if(i!=1) {
      if(type=="user"){
      await collectioncountmessage.doc(
          controller.useremail + "_" + touser).set
        (
          {
            "from": controller.useremail,
            "tousers": [{"name":touser,"count":1}],
            "count": 1,
            "lastmessage": message,
            "timesent": FieldValue.serverTimestamp(),
            "type":"user"
          }
         );
        }//now for group
        else
          {
            Map u={};
            List l=[];
            for(var z=0;z<listofuser.length;z++) {
              u = {
                "name":listofuser[z],
                "count":1,
              };
              l.add(u);
            }
            await collectioncountmessage.doc(touseremailm)
                .set
              (

                {
                  "count": 1,
                  "from": controller.useremail,
                  "to":touser,
                  "tousers":l,
                  "lastmessage": message,
                  "timesent": FieldValue.serverTimestamp(),
                  "type":"group"
                }
            );

          }
    }

  }



  Future createchatgroup(messages) async {

    var collection = FirebaseFirestore.instance.collection('groupusers');
    var querySnapshot = await collection.get();
    Set listgroupuser0 = {};
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      if(data['groupnameid']==chatroomid) {
        listgroupuser0.add(data['touseremail']);
        listusergroup=listgroupuser0;
        update(); // <-- Retrieving the value.
      }

    }

 //////////////////////////////////////////////////

for (var i = 0; i < listusergroup.length; i++) {
  await collectionchatmessage.doc(
      chatroomid + "_" + DateTime.now().toString()).set
    (
      {
        "fromuseremail": controller.useremail,
        "touseremail": listusergroup.elementAt(i),
        "message": messages,
        "createddate": FieldValue.serverTimestamp(),
        "chatroomdate": DateTime(DateTime
            .now()
            .year, DateTime
            .now()
            .month, DateTime
            .now()
            .day).toString(),
        "chatroomid": chatroomid
      }
  );
}
  }




  Future checkgroupid(fromuseremail, groupname) async{

    groupid="";
    var querySnapshot = await collectiongroupname.get();
    if (querySnapshot.docs.length == 0) {

      var groupid0 = controller.useremail + "_" + groupname;
      groupid = groupid0;
      update();
    }
    else {
      for (var doc in querySnapshot.docs) {
        if (doc.id == controller.useremail + "_" + groupname
            ) {
          var groupid0 = doc.id;
          groupid= groupid0;
          update();
          break;
        }
        else {
          var  groupid0= controller.useremail + "_" + groupname ;
          groupid= groupid0;
          update();
        }
      }
    }
    creategroup(groupid,groupname);
  }


    Future creategroup(groupid,groupname) async {

      await collectiongroupname.doc(groupid).set
        (
          {
            "groupnameid":groupid,
            "groupname":groupname,
            "type":"group"

          }
      );
    adduserstogrouparray(groupid,groupname);
    }


  Future adduserstogroup(groupid,groupname) async {

    //we will add the list that created by the loginuser and also
    //add the loginuser to the list
    for (var i = 0; i < listusergroup.length; i++) {

      await collectionaddusertogroup.doc(
          groupid + "_" + listusergroup.elementAt(i).toString())
          .set
        (
          {
            "groupnameid": groupid,
            "groupname":groupname,
            "touseremail": listusergroup.elementAt(i),

          }
      );
    }
    await collectionaddusertogroup.doc(
        groupid + "_" + controller.useremail)
        .set
      (
        {
          "groupnameid": groupid,
          "groupname":groupname,
          "touseremail": controller.useremail,

        }
    );


  }



  Future adduserstogrouparray(groupid,groupname) async {

    //we will add the list that created by the loginuser and also
    //add the loginuser to the list
   // for (var i = 0; i < listusergroup.length; i++) {

      await collectionaddusertogroup.doc(
          groupid )
          .set
        (
          {
            "groupnameid": groupid,
            "groupname":groupname,
            "touseremail":groupid,
            "listofusers":FieldValue.arrayUnion(listusergroup.toList()),

          }
      );
   // }
      await collectionaddusertogroup.doc(
          groupid )
          .update
        (
          {
            "groupnameid": groupid,
            "groupname":groupname,
            "touseremail":groupid,
            "listofusers": FieldValue.arrayUnion([controller.useremail]),

          }
      );


  }
  void setSelected(value){
    selecteduser=value;
    update();
    listusergroup.add(value);

   update();
    }

    changeloadstate() {
      testload = 1;
      update();
    }
    getuserbelonggroup() async {

      Map m={};
      listusersgroup=[];
     //Add group name to the same list but check if the loginuser
     // belong to these groups before add the groups to the list
     //if loginuser exist then the group will add to the list
     //and displayed for him because he belongs to the group
      var collectiongroupusers = FirebaseFirestore.instance.collection('groupusers');
      var querySnapshotgroupusers= await collectiongroupusers.get();
     for (var doc2 in querySnapshotgroupusers.docs) {

        if (doc2.data().length>0){
          if(doc2.data()["touseremail"]==controller.useremail){
            m={"touseremail":doc2.data()['touseremail'],"type":"group","groupname":doc2.data()['groupname'],"groupnameid":doc2.data()['groupnameid']};
            listusersgroup.add(m);
            update();


          }
        }

      }
    }


 countmymessage(from,to) async {
    var i=0;
    var collectiongroupusers = FirebaseFirestore.instance.collection('messagecount');
    var querySnapshotgroupusers= await collectiongroupusers.get();
    for (var doc2 in querySnapshotgroupusers.docs) {
      if(doc2.id==from+"_"+to){
        i=1;
        myc= doc2.data()["count"];
        update();

      }
    }
   if(i!=1){

   }
  }

//////////////////////////Test page/////////////////////
  Stream<QuerySnapshot> readpage() {
    return FirebaseFirestore.instance.collection('page')
        .snapshots();
  }


 Future setmycurrentpage(page) async {

    var collectiongroupusers = FirebaseFirestore.instance.collection('page');
     await collectiongroupusers.doc(controller.useremail).set
       (
         {
           "mypage": page
         }
       ).then((value){
       setmessagetoread();
     });
  }




///////////////////////////////////////////////////////

  Stream<QuerySnapshot> allmessageind() async* {
    var m = FirebaseFirestore.instance.collection('chatmessage')


        .snapshots();

    yield* m;
  }



    Stream<QuerySnapshot> allmessage(chatroomid) async* {
      var m = FirebaseFirestore.instance.collection('chatmessage')
          .orderBy('createddate', descending: true)
          .where('chatroomid', isEqualTo: chatroomid)
          .snapshots();

      yield* m;
    }

    Stream<QuerySnapshot> allmessage2() async* {
      var m = FirebaseFirestore.instance.collection('chatmessage')
          .orderBy('createddate')
          .snapshots();

      yield* m;
    }

    Stream<QuerySnapshot> allchatroomdate() {
      return FirebaseFirestore.instance.collection('chatroomdate')

          .snapshots();
    }

  Stream<QuerySnapshot> allusers() {
    return FirebaseFirestore.instance.collection('users')
        .snapshots();


  }

  Stream<QuerySnapshot> allgroupsbelongtouser() async*{

    var m =  FirebaseFirestore.instance.collection('groupusers')

        .snapshots();
      m.forEach((element) {
        element.docs.forEach((d) {
          userbelongtogroup.add(d.data());
        });
      });
      update();

    yield* m;
  }


    Future getmessage() async {
      try {
        var l = await FirebaseFirestore.instance.collection('chatmessage')
            .get();

        var listmessage0 = [];
        l.docs.forEach((doc) {
          listmessage0.add(doc);
        });
        listmessage = listmessage0;

        update();
        return listmessage;
      } catch (error) {
        return null;
      }
    }
    //This is when user click on one of the user in the list
    updateuserthengo(touseremail,type) async{
      touser = touseremail;
      update();
      tousertype= type;
      update();
      getuserlastseen(touseremail);
      checkroomid(touser ,tousertype);
      setcounttoafterread(touseremail,type);
      setmessagetoread();
      Get.to(chatind());
    }

  Future setcounttoafterread(touseremail,type) async {
   var v;
   Map m={};

   var g= await collectionmessagecount;
    if(type=="user"){
     v=touseremail + "_" + controller.useremail;
   }else{
    v=touseremail ;
   }

   await g.doc(v).get().then((value) {
     List t = value.get("tousers");

   if(type=="user"){
     if (t[0]["name"] == controller.useremail) {
       Map l = {"name": controller.useremail, "count": 0};

       collectionmessagecount.doc(v)
           .update
         (
           {
             "tousers": [l]
           }
       );
     }
   }
   else//now for group
     {
       for(var j=0;j<t.length;j++){
         if(t[j]["name"]==controller.useremail){
         t[j]["count"]=0;
         }
       }
       print("tttttttttttttttttttttttkkkkkkkkkkkkk");
print(t);

       collectionmessagecount.doc(v)
           .update
         (
           {
             "tousers": t
           }
       );
     }
   });
  }

   removeuser(userindex){

    listusergroup.remove(userindex);

      update();
    }

 Future setonlinetooffline() async{

    await collectionusers.doc(controller.userid).set
      (
        {
          "lastseentime": FieldValue.serverTimestamp(),
          "useremail":controller.useremail,
          "userid":controller.userid,
          "online":"0",
        }
    );
on=0;
update();
    print(online);
  }


 Future setuseronlinelastseen() async{
      await collectionusers.doc(controller.userid).set
        (
          {
            "lastseentime": FieldValue.serverTimestamp(),
            "useremail":controller.useremail,
            "userid":controller.userid,
            "online":"1",
          }
      );
      on=1;
      update();
      print(online);
   }
 getuserlastseen(touseremail) async {
      var collectionusers = FirebaseFirestore.instance.collection('users');
    var querySnapshotusers= await collectionusers.get();
    for (var doc2 in querySnapshotusers.docs) {
       if(doc2.data()["useremail"]==touseremail){
          lastseentime= doc2.data()["lastseentime"].toDate();
          update();
        }
   }
}

  getlistofusers() async {
    var collectiongroupusers = FirebaseFirestore.instance.collection('users');
    var querySnapshotgroupusers= await collectiongroupusers.get();
    for (var doc2 in querySnapshotgroupusers.docs) {
      listofuser.add(doc2["useremail"]);
      update();
    }
  }

/////////////user page chatuser////////////////////////////////////////
  getusers() async {
    var collectiongusers = FirebaseFirestore.instance.collection('users');
    var querySnapshotgroupusers1 = await collectiongusers.get();
    for (var doc2 in querySnapshotgroupusers1.docs) {

      Map m = {
        "useremail": doc2.data()["useremail"],
        "online": doc2.data()["online"],
        "lastseentime": doc2.data()["lastseentime"],
        "count": doc2.data()["count"],
        "lastmessage":doc2.data()["lastmessage"],
        "timesent" :doc2.data()["timesent"],
        "type":"user",
        "groupname":"",
        "groupnameid":"",

      };
      userandgroups.add(m);
      update();
    }
  }

  Stream<QuerySnapshot> allmessagecount() {
    return FirebaseFirestore.instance.collection('messagecount')
        .orderBy("timesent", descending: true)
        .snapshots();
  }


  Stream<QuerySnapshot> alluser() {
    return FirebaseFirestore.instance.collection('users')
        .snapshots();
  }
  Stream<QuerySnapshot> oneuser() {
    return FirebaseFirestore.instance.collection('users')
        .snapshots();
  }

  Stream<QuerySnapshot> usertogroupbelong() async* {


    var m = await FirebaseFirestore.instance.collection('groupusers')

        .where('listofusers',  arrayContainsAny: [controller.useremail])
        .snapshots();
m.forEach((element) {
  element.docs.forEach((element) {
   Map g= {
   "groupnameid": element.data()["groupnameid"],
   "groupname": element.data()["groupname"],
   "touseremail": element.data()["touseremail"],

  };
   listg.add(g);
  });

});

    yield* m;
  }

todo() async{
    await  usertogroupbelong();
}

////////////////////////////for fire store//////////////////////////////////
  Future imageFromGallery(sourcefrom) async {
    ImageSource source0;
    source0=ImageSource.camera;
    if (sourcefrom=="camera"){
      source0=ImageSource.camera;
    }
    else
     {
       source0=ImageSource.gallery;
     }

    final myfile = await ImagePicker()
        .getImage(source: source0);
    if (myfile!= null) {
      filepath = File(myfile.path);
      filename=filepath!.path.split("/").last;
      update();
      uploadfile();
    }
  }


  Future uploadfile()async{

    try{
      await storage.ref("test/$filename").putFile(filepath!).then((p0){

       print("test upload file");
       print(filename);
       print(filepath);
       downloadfile(filename);

      });
    }
    catch(e)
    {print(e.toString());}

  }
  Future downloadfile(String filename) async{
   await storage.ref("test/$filename").getDownloadURL().then((value) {
      //fileurl=imageurl0;
     print("gggggggggggggggggggggggggggggggggggggggggg");
      print(value);
      fileurl=value;
      update();
     createchatwithfile();
    });

  }


  createchatwithfile() async{

      await createchat(controller.useremail,touser,tousertype,"",filename,fileurl,"file");


   }
  ///////////////////////////////////////////////////////////////////

    @override
    void onInit() {
      todo();
      super.onInit();

      print("on init databasechat");
      getuserbelonggroup();
      setuseronlinelastseen();
      getlistofusers();
      getusers();
      WidgetsBinding.instance.addObserver(this);
    }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    setonlinetooffline();
    super.dispose();
  }
  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state >>>>>>>>>>>>>>>>>>>>>> : ${state}');
    final isbackgound=state==AppLifecycleState.paused;
    final isclosed=state==AppLifecycleState.detached;
    if(isbackgound || isclosed){
      print("in background");
      setonlinetooffline();
      setmycurrentpage("out");
    }

    final isresumed=state==AppLifecycleState.resumed;
    if(isresumed){
      print("resumed");
      setuseronlinelastseen();
      setmycurrentpage(Get.currentRoute);
    }

  }



  }
