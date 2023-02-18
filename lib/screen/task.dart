


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import '../controller/task.dart';
import 'chatind.dart';
class task extends StatelessWidget {
 task(this.scaffoldKey);
 final scaffoldKey;
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey=GlobalKey<FormState>();
    TextEditingController tasknamecontroller=TextEditingController();
    TextEditingController taskdetailscontroller=TextEditingController();
    TextEditingController fromdatecontroller=TextEditingController();
    TextEditingController todatecontroller=TextEditingController();
    taskcontroller taskController=Get.put(taskcontroller());
    logincontroller loginController=Get.find<logincontroller>();
    databasechat dbchatcontroller=Get.find<databasechat>();
    return  Form(
      key: formkey,
      child: Card(
        child: ListView(
          children: [

            TextFormField(
              controller: tasknamecontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {

                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: taskdetailscontroller,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task Details',

              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              onTap: () async{

                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  fromdatecontroller.text =
                      formattedDate;

                } else {}


              },
              controller: fromdatecontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fromdate',

              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              onTap: () async{
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                todatecontroller.text =
                      formattedDate;

                } else {}

              },
              controller: todatecontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Todate',
              ),
            ),



            FloatingActionButton(backgroundColor:Color(0xff25D366),child:Text("Submit"),onPressed:(){

              if (formkey.currentState!.validate()) {
                taskController.createtask(
                    dbchatcontroller.touser,
                    loginController.useremail,
                    tasknamecontroller.text,
                    taskdetailscontroller.text,
                    fromdatecontroller.text,
                    todatecontroller.text,
                    "new"
                ).then((value) {
                  if(scaffoldKey.currentState!.isDrawerOpen){
                    scaffoldKey.currentState!.closeDrawer();
                    //close drawer, if drawer is open
                  }
                  formkey.currentState?.reset();});
              }



            }),
            SizedBox(height: 50,),
            FloatingActionButton(backgroundColor:Colors.green,child:Text("Cancel"),onPressed:(){
              Get.offAll(chatind());
            }),



          ],
        ),
      ),
    );
  }
}
