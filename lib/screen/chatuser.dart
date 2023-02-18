import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/drawer.dart';
import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import 'alltask.dart';
import 'chatgroup.dart';
import 'chatind.dart';


class chatusers extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    logincontroller loginController=Get.find<logincontroller>();

    databasechat dbchatcontroller=Get.put(databasechat(),permanent:true);
    TextEditingController message=TextEditingController();
    TextEditingController location=TextEditingController();
    TextEditingController tousierid=TextEditingController();
    FocusNode myFocusNode = FocusNode();
    TextEditingController group=TextEditingController();
    dbchatcontroller.setmycurrentpage(Get.currentRoute);

    return

      Container(color: Colors.white,
        constraints: const BoxConstraints.expand(),
       // decoration: const BoxDecoration(
      //      image: DecorationImage(
     //           image: AssetImage("assets/whatsappbackground.png"), fit: BoxFit.cover)
     //   ),

        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey, //this is the key
            endDrawer:drawer(),

            backgroundColor:Colors.transparent,
          
          body:Column(
            children: [
              Container(padding:EdgeInsets.fromLTRB(15, 0, 0, 0),height:50,color:Color(0xff25D366),child: Row(children:
              [

                Text("WhatsApp",style:TextStyle(color:Colors.white,fontSize: 20)),
                SizedBox(width: 40,),
               CircleAvatar(
                  radius:20,
                  backgroundImage:AssetImage('assets/younes3.jpg'),
                ),

                //Text(loginController.useremail,style:TextStyle(color:Colors.white)),
                Spacer(),
                IconButton(color:Colors.white,onPressed: (){
                  _scaffoldKey.currentState!.openEndDrawer(); // this is it
                  //Get.offAll(drawer());
                },
                    icon:Icon(Icons.menu)),
              ],),),
              StreamBuilder(
                stream:dbchatcontroller.allmessagecount(),
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
                      ///////////////  /////////////////////////////////////////////
                      List alldata=[];
                      var a=snapshot.data?.docs;
                      for(var i=0;i<a!.length;i++){
                        alldata.add(snapshot.data?.docs[i].data());

                      }
                      //we will loop through documents and put all the data for each document
                      //in a List so the list will contain list of maps alldata[{from...,to:..},{from:...,to:...}]
                    ////////////////////////////////////////////////////////
                      return
                        StreamBuilder(
                          stream:dbchatcontroller.alluser(),
                          builder: (
                              BuildContext context,
                              snapshot2,
                              ) {
                            if (snapshot2.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot2.connectionState == ConnectionState.active
                                || snapshot2.connectionState == ConnectionState.done) {
                              if (snapshot2.hasError) {
                                return const Text('Error');
                              } else if (snapshot2.hasData) {
                                List alluser=[];
                                var b=snapshot2.data?.docs;
                                for(var i=0;i<b!.length;i++){

                                    alluser.add(snapshot2.data?.docs[i].data());
                                //  }
                                }

                     ////////////////////  /////////////////////////////////////////////

                                return
                                  StreamBuilder(
                                    stream:dbchatcontroller.usertogroupbelong(),
                                    builder: (
                                        BuildContext context,
                                        snapshot3,
                                        ) {
                                      if (snapshot3.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot3.connectionState == ConnectionState.active
                                          || snapshot3.connectionState == ConnectionState.done) {
                                        if (snapshot3.hasError) {
                                          return const Text('Error');
                                        } else if (snapshot3.hasData) {
                                          ////////////////////  /////////////////////////////////////////////

                                          //we will loop through documents and put all the data for each document
                                          //in a List so the list will contain list of maps alldata[{from...,to:..},{from:...,to:...}]
                                         List y=[];
                                          Map d={};
                                          for(var k=0;k<alluser.length;k++){
                                            d={
                                              "touseremail":alluser[k]["useremail"],
                                              "online":alluser[k]["online"],
                                              "count" :0,
                                              "lastmessage" : "",
                                              "timesent" :null,
                                              "type" : "user",
                                           };
                                            for(var j=0;j<alldata.length;j++){
                                               if(alldata[j]["type"]=="user"){

                                                var t=alldata[j]["tousers"];
                                               for(var x=0;x<t.length;x++){
                                               if(t[x]["name"]==loginController.useremail){


                                                 if(alldata[j]["from"]==alluser[k]["useremail"])
                                           {

                                                   d={"touseremail":alluser[k]["useremail"],
                                                 "online":alluser[k]["online"],
                                                 "count" : t[x]["count"],
                                                 "lastmessage" : alldata[j]["lastmessage"],
                                                 "timesent" :alldata[j]["timesent"],
                                                 "type" : "user",
                                                             };

                                                             }

                                                             }
                                                             }
                                                             }

                                          }
                                            y.add(d);
                                          }


                                          //////for groups//////
                                          List allgroupstouser=[];
                                          Map m={};
                                          num s=0;
                                          num v=0;


                                            var c=snapshot3.data?.docs;
                                          for(var i=0;i<c!.length;i++){
                                           allgroupstouser.add(snapshot3.data?.docs[i].data());
                                         };

                                         for(var i=0;i<allgroupstouser.length;i++){


                                        for(var j=0;j<alldata.length;j++){
                                        if(alldata[j]["type"]=="group"){
                                        if(allgroupstouser[i]["groupnameid"]==alldata[j]["to"] ){


                                        var t=[];
                                        t=alldata[j]["tousers"];
                                         for(var x=0;x<t.length;x++){
                                        if(t[x]["name"]==loginController.useremail){
                                        v=t[x]["count"];
                                         }
                                         }

                                          allgroupstouser[i]["count"]=v;
                                          allgroupstouser[i]["lastmessage"]=alldata[j]["lastmessage"];
                                          allgroupstouser[i]["timesent"]=alldata[j]["timesent"];

                                        }
                                        }
                                        }

                                        }

                                          var userandgroup = new List.from(y)..addAll(allgroupstouser);
                                          print(userandgroup);
                                          return
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: userandgroup.length,
                                                  itemBuilder:(context,index3){
                                                    return  InkWell(onTap:(){
                                                      if(userandgroup![index3]["type"]=="user" ) {

                                                        dbchatcontroller.updateuserthengo(userandgroup![index3]["touseremail"], "user");

                                                      }
                                                      else
                                                      {
                                                        dbchatcontroller
                                                            .updateuserthengo(
                                                            userandgroup![index3]["touseremail"],"group");
                                                      }

                                                    } ,
                                                      child: Card(
                                                        child: Row(
                                                          children: [

                                                            Badge(
                                                              showBadge:userandgroup![index3]["count"].toString()=="null"?false:userandgroup![index3]["count"].toString()=="0"?false:true,
                                                              position: BadgePosition.topEnd(top:0, end: 0),
                                                              badgeColor:Color(0xff25D366),
                                                              badgeContent: Text(userandgroup![index3]["count"].toString(),style: TextStyle(color: Colors.white),),
                                                              child:CircleAvatar(
                                                                backgroundColor:Color(userandgroup![index3]["online"]=="1"?0xff25D366:999900000000),
                                                                radius:25,
                                                                child: CircleAvatar(
                                                                  radius:20,
                                                                  backgroundImage:userandgroup![index3]["type"]=="user"? AssetImage('assets/img2.png'):AssetImage('assets/g.png'),
                                                                ),
                                                              )
                                                             ),

                                                            Column(children: [
                                                              Text(userandgroup![index3]["type"]=="user"?userandgroup![index3]["touseremail"]:userandgroup![index3]["groupname"]),

                                                              Text(userandgroup![index3]["lastmessage"]==null?"":userandgroup![index3]["lastmessage"].length>30?userandgroup![index3]["lastmessage"].substring(0,30):userandgroup![index3]["lastmessage"]),


                                                            ],),
                                                              Spacer(),


                                                              Column(
                                                                children: [
                                                                  Text(userandgroup![index3]["timesent"]==null?"":DateFormat.yMd().add_jm().format(userandgroup![index3]["timesent"].toDate().add(Duration(hours: 0))),style: TextStyle(fontSize:10 ),),

                                                                ],
                                                              ),

                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            );

                                            } else {
                                          return const Text('Empty data');
                                        }
                                      } else {
                                        return Text('State: ${snapshot.connectionState}');
                                      }
                                    },
                                  );

                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        );

                  } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
           ],
          ) ,
    ),
        ),
      );
  }
}
