import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_dialog_picker/emoji_dialog_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import '../common/drawerchatind.dart';
import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import 'package:chat/screen/chatuser.dart';
class chatind extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    logincontroller loginController=Get.put(logincontroller());
    databasechat dbchatcontroller=Get.put(databasechat());
    TextEditingController message=TextEditingController();
   // print("in");
    //print(Get.currentRoute);
    dbchatcontroller.setmycurrentpage(Get.currentRoute);
    return  Container(
        constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/whatsappbackground.png"), fit: BoxFit.cover)),

      child:

      SafeArea(
        child: Scaffold(
          key:scaffoldKey, //this is the key
          endDrawer:drawerchatind(scaffoldKey),

          resizeToAvoidBottomInset:true,backgroundColor: Colors.transparent,
          body:SingleChildScrollView(

            child: Column(children: [

              //This row for the header with green color
              Row(children: [
                Expanded(

                  child: Container(color:Color(0xff25D366),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        IconButton(color:Colors.white,onPressed: (){
                          Get.offAll(chatusers());
                        },
                            icon:Icon(Icons.arrow_back)),
                        const SizedBox(width: 50,height: 50,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/img2.png'),
                          ),

                        ),

                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Text(dbchatcontroller.touser,style: TextStyle(color: Colors.white),),
                            ///////////////////////////////////////
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
                                      Text(online=="1"?"online":online==null?"":lastseentime.toDate().toString()
                                        ,style: TextStyle(fontSize: 10,color: Colors.white),
                                      );
                                  } else {
                                    return const Text('Empty data');
                                  }
                                } else {
                                  return Text('State: ${snapshot.connectionState}');
                                }
                              },
                            ),

                          /////////////////////////////////////////
                          ],
                        ),
                        Spacer(),
                        IconButton(color:Colors.white,onPressed: (){
                          scaffoldKey.currentState!.openEndDrawer(); // this is it
                          //Get.offAll(drawer());
                        },
                            icon:Icon(Icons.menu)),
                      ],
                    ),
                  ),
                ),

              ],),

              ////////////////////////////////////////////////////////////////
              GetBuilder<databasechat>( // specify type as Controller
                  init: databasechat(), // intialize with the Controller
                  builder: (mvalue) =>
                      StreamBuilder<QuerySnapshot>(
                          stream:dbchatcontroller.allmessage(mvalue.chatroomid),
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
                                List l=[];
                                snapshot.data!.docs.forEach((e) {
                                  l.add(e);
                                });

                                final map = l.groupBy((item) =>
                                item['chatroomdate'],
                                  valueTransform: (item) => item,
                                );

                                return
                                  // This for the whole listview
                                  ConstrainedBox(constraints:BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height-50,
                                    maxWidth: MediaQuery.of(context).size.width ,
                                  ) ,

                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                        shrinkWrap:true,
                                        itemCount: map.length,
                                        itemBuilder:(context,index){
                                          return
                                            Column(children: [
                                              Text(map.keys.elementAt(index)),
                                              ListView.builder(
                                                  shrinkWrap:true,
                                                  itemCount:map.values.elementAt(index).length ,
                                                  itemBuilder:(context,index2){
                                                    var ind=map.values.elementAt(index)[index2];
                                                    var user=map.values.elementAt(index)[index2]["touseremail"];
                                                    return
                                                      Align(alignment:user==loginController.useremail?
                                                      Alignment.centerLeft:Alignment.centerRight,
                                                        child: ConstrainedBox(constraints:BoxConstraints(
                                                          maxHeight: MediaQuery.of(context).size.height,
                                                          maxWidth: MediaQuery.of(context).size.width -45,
                                                        ),child:  Card(color:user==loginController.useremail?Colors.white:Color(0xffdcf8c6),
                                                            child:
                                                           Column(mainAxisSize:MainAxisSize.min ,
                                                             children: [
                                                             ind["typemessage"]=="message"?
                                                             Text(ind["message"].toString()):
                                                             SizedBox(height:100,child: Image.network(ind['fileurl'])),
                                                             Text(ind["createddate"]==null?"":DateFormat.jm().format(ind["createddate"].toDate()),style: TextStyle(fontSize: 8),),
                                                             Icon(ind["read"]=="no"?Icons.done:Icons.done_all,color: Colors.cyan,size: 20,)
                                                           ],)
                                                        )
                                                          ,
                                                        ),
                                                      );

                                                  }),

                                            ],);

                                        }),
                                  );

                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),

              ),
///////////////////////////////////////////////////////////////

            ]),
          ),


         bottomNavigationBar:

         Padding(
            padding: MediaQuery.of(context).viewInsets,
        child:Container(padding:EdgeInsets.fromLTRB(0, 0, 0,0),color: Colors.white,
          child: Row(
            children: [



              Container(width: 30,height:30,
                child: EmojiButton(
                  emojiPickerView: EmojiPickerView(onEmojiSelected: (String emoji) {
                    print('Emoji selected: $emoji');
                    //message.text=message.text+emoji;

                    message.text= emoji;
                    print(message.text);
                    dbchatcontroller.createchat(loginController.useremail, dbchatcontroller.touser,dbchatcontroller.tousertype, message.text,"","","message").then((value) => message.clear());
                  }),
                  child:Icon(Icons.emoji_emotions),
                ),
              ),

              Expanded(
                child: Form(
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,  // allow user to enter 5 line in textfield
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.go,
                    //  focusNode:myFocusNode ,
                    onFieldSubmitted: (value) {
                     print("messssssssssssssssss");
                      var typemessage="message";
                      dbchatcontroller.createchat(loginController.useremail, dbchatcontroller.touser,dbchatcontroller.tousertype, message.text,"","","message").then((value) => message.clear());

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
                    decoration:  InputDecoration(border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),label:Text('message')
                    ),
                  ),
                ),
              ),
              IconButton(iconSize: 30, icon: Icon(Icons.attach_file),onPressed:() async{
                await dbchatcontroller.imageFromGallery("gallery");

              }),

              IconButton(iconSize: 30, icon: Icon(Icons.photo_camera),onPressed:() async{
                await dbchatcontroller.imageFromGallery("camera");

              }),
            ],
          ),
        ) ,
    ),),
      ),

    );
}}
