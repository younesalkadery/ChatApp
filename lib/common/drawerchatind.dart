import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import '../screen/alltask.dart';
import '../screen/chatgroup.dart';
import '../screen/chatind.dart';
import '../screen/emoji.dart';
import '../screen/task.dart';
class drawerchatind extends StatelessWidget {
  drawerchatind(this.taskkey);
  final taskkey;
  @override
  Widget build(BuildContext context) {
    logincontroller loginController=Get.find<logincontroller>();

    databasechat dbchatcontroller=Get.put(databasechat(),permanent:true);
    return Drawer(backgroundColor: Colors.white,

      child: ListView(

        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff25D366),
            ),
            child: Text(loginController.useremail.toString(),style: TextStyle(color: Colors.white),),
          ),


          ListTile(
            title:  Text('Tasks'),
            onTap: () {
              dbchatcontroller.setonlinetooffline();
              Get.offAll(task(taskkey));
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title:  Text('emoji'),
            onTap: () {
              dbchatcontroller.setonlinetooffline();
              Get.offAll(em());
              //Navigator.pop(context);
            },
          ),

        ],
      ),
    ) ;
  }
}
