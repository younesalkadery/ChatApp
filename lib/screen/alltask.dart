import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/logincontroller.dart';
import '../controller/task.dart';
import 'chatuser.dart';



class alltasks extends StatelessWidget {

  // GlobalKey<FormState> formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("in build task");
    logincontroller loginController=Get.find<logincontroller>();

    taskcontroller taskController=Get.put(taskcontroller());


    return Scaffold(
        appBar: AppBar(backgroundColor:Color(0xff25D366),elevation: 0.0,centerTitle: true,title: Text("Tasks",style:TextStyle(color: Colors.white)),actions: [
          IconButton(iconSize: 30, icon:
          Icon(Icons.arrow_forward,),onPressed:(){

            Get.to(chatusers());
          }),
        ],),
        body:WillPopScope(onWillPop:(){
          Get.to(chatusers());
          return Future.value(true);
        },child:
        Column(
          children: [StreamBuilder(
            stream:taskController.alltask(),
            builder: (  BuildContext context, snapshot,) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active
                  || snapshot.connectionState == ConnectionState.done) {
                if  (snapshot.hasData) {

                  return Expanded(
                    child: ListView.builder(
                        itemCount:snapshot.data!.docs.length ,
                        itemBuilder: (context,index){
                          return Container(margin: const EdgeInsets.all(10.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Container(color:Color(0xff075E54),
                                    child: Row(children: [

                                      Text(snapshot.data!.docs![index]["fromuser"],style: TextStyle(color: Colors.white),),
                                      Spacer(),
                                      Text(snapshot.data!.docs![index]["touser"],style: TextStyle(color: Colors.white)),
                                    ],),
                                  ),


                                  Text(snapshot.data!.docs![index]["takdetails"]),
                                  Row(children: [
                                    Text(snapshot.data!.docs![index]["fromdate"]),
                                    SizedBox(width: 50,),
                                    Text(snapshot.data!.docs![index]["todate"]),
                                    Spacer(),
                                    GetBuilder<taskcontroller>( // specify type as Controller
                                        init: taskcontroller(), // intialize with the Controller
                                        builder: (mvalue) =>DropdownButton(
                                          onChanged: (newValue) {
                                           if(snapshot.data!.docs![index]["touser"]==loginController.useremail){
                                             taskController.setSelected(newValue.toString(),snapshot.data!.docs![index].id);

                                           }

                                          },
                                          value:snapshot.data!.docs![index]["status"],
                                          items: mvalue.status.map((selectedType) {
                                            return DropdownMenuItem(
                                              value: selectedType,
                                              child: Text(
                                                selectedType,
                                              ),
                                            );
                                          }).toList(),
                                        ))


                                    //  Text(mappedData![index]["status"]),
                                  ],)
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return  Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),

          ],
        ),

        ));
  }
}
