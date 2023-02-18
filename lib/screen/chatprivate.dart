import 'package:chat/screen/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import 'chatuser.dart';

class chatprivate extends StatelessWidget {

  @override
  GlobalKey<FormState> formkey=GlobalKey<FormState>();

  Widget build(BuildContext context) {

    FocusNode myFocusNode = FocusNode();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    logincontroller loginController=Get.find<logincontroller>();
    databasechat dbchatcontroller=Get.find<databasechat>();
    TextEditingController message=TextEditingController();



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(key:scaffoldKey,
        appBar:
        AppBar(backgroundColor: Colors.transparent,
            title:  Column(
              children: [
                Text(dbchatcontroller.touser),
                //This stream only used to show online status nothing else
                StreamBuilder<QuerySnapshot>(
                  stream: dbchatcontroller.oneuser(),
                  builder: (
                      BuildContext context,
                     snapshot,
                      ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState == ConnectionState.active
                        || snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else if (snapshot.hasData) {
                        var online;
                        var lastseentime;
                        snapshot.data!.docs.forEach((e) {
                          if(e["useremail"]==dbchatcontroller.touser){
                            var onlines=e["online"];
                            var lastseen=e["lastseentime"];
                            online=onlines;
                            lastseentime=lastseen;

                          }
                        });
                        return
                          Text(online=="1"?"online":lastseentime.toDate().toString()
                        ,style: TextStyle(fontSize: 10),
                        );
                      } else {
                        return const Text('Empty data');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  },
                ),


              //Text(value.on==1?"online":value.on==0?DateFormat.yMMMMd('en_US').format(value.lastseentime).toString():""))
              ],
            )
        ,actions: [
          IconButton(iconSize: 30, icon: Icon(Icons.arrow_forward),onPressed:() {
            Get.to(chatusers());
          }),
        ],),
        body:
       Column(
         children: [

          Form(
              key:formkey,
              child:Column(children: [
                Container(margin:EdgeInsets.all(2),color: Colors.black12,
                   child: Row(
                     children: [
                       Expanded(
                         child: Container(margin:EdgeInsets.all(0),width: 200,
                           child: TextFormField(
                            focusNode:myFocusNode ,
                            onFieldSubmitted: (value) {
                              if (formkey.currentState!.validate()) {
                              //  dbchatcontroller.checkroomid("user").then((value){
                                var typemessage="message";
                                  dbchatcontroller.createchat(loginController.useremail, dbchatcontroller.touser,dbchatcontroller.tousertype, message.text,"","","message").then((value) => message.clear());
                                 myFocusNode.requestFocus();
                              }
                            },
                           controller: message,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //   dbchatcontroller.createchatroom(loginController.useremail, tousierid);
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            //controller:controller.email ,
                            decoration: const InputDecoration(suffixIcon:Icon(Icons.mail),border: OutlineInputBorder(borderRadius:BorderRadius.zero),label:Text('message')
                            ),
                ),
                         ),
                       ),

                       IconButton(iconSize: 30, icon: Icon(Icons.photo_camera),onPressed:() async{
                         await dbchatcontroller.imageFromGallery("camera");

                       }),
                       IconButton(iconSize: 30, icon: Icon(Icons.attach_file),onPressed:() async{
                         await dbchatcontroller.imageFromGallery("gallery");

                       }),
                     ],
                   ),
                 ),


            SizedBox(height: 10,),
            SizedBox(width: 100,height: 30,

            ),
          ],)),
     GetBuilder<databasechat>( // specify type as Controller
      init: databasechat(), // intialize with the Controller
        builder: (mvalue) =>
      StreamBuilder(
      stream:dbchatcontroller.allmessage(mvalue.chatroomid),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      if (streamSnapshot.hasData) {

      return

            Expanded(
              child: GroupedListView<dynamic,DateTime>(
                elements:streamSnapshot.data!.docs,
                groupBy: (element) {
                  DateTime date0 = DateTime.parse(element['chatroomdate']);

                  //String onlyDate=DateFormat.yMd().format(element['createddate'].toDate());

                  return date0;
                },
                groupComparator: (value1, value2) => value2.compareTo(value1),

                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (DateTime value) => Container(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                itemBuilder: (c, element) {

                  return
                    Card(
                      color: Color(0xffdcf8c6),
                    elevation: 0.0,
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    child: SizedBox(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                       // leading: const Icon(Icons.account_circle,size: 50,),
                        title:
                           Row(children:
                          [
                            if (dbchatcontroller.tousertype== "group") ...[
                              element['typemessage']=="message"?Expanded(child: Text(element['message'])):SizedBox(width:100,height: 100,child: Image.network(element['fileurl'])),
                            ] else ...[

                                       if (loginController.useremail!=element['fromuseremail']) ...[
                                         Icon(Icons.account_circle,size: 50,), element['typemessage']=="message"?
                                         Expanded(child: Text(element['message'])):SizedBox(height:100,child: Image.network(element['fileurl'])),
                                         Text(DateFormat.jm().format(element['createddate'].toDate()))
                                       ] else ...[
                                        Expanded(child: Container(child: Align( alignment: Alignment.centerRight,child: element['typemessage']=="message"? Text(element['message']):SizedBox(width:100,height: 100,child: Image.network(element['fileurl'])), ))),
                                       SizedBox(width: 20,), Text(element['createddate']==null?"":DateFormat.jm().format(element['createddate'].toDate()))
                                       ]


                            ],
                          ],),

                         trailing:dbchatcontroller.tousertype== "group"?Column(
                           children: [
                             Text(element['fromuseremail'],style: TextStyle(fontSize: 10),),
                             SizedBox(width: 20,), Text(element['createddate']==null?"":DateFormat.jm().format(element['createddate'].toDate()))
                           ],
                         ):Text("")

                      ),
                    ),
                  );
                },
              ),
            );


    }else{return Text("No data");


    }})),
         ],
       )






      ,drawer:task(scaffoldKey) ,),
    );
  }
}