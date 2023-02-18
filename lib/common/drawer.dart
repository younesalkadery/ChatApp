import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import '../screen/alltask.dart';
import '../screen/chatgroup.dart';
import '../screen/chatind.dart';
class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

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

            title:  Text('Add groups'),
            onTap: () {
              dbchatcontroller.setonlinetooffline();
              Get.offAll(chatgroup());
              //Navigator.pop(context);
            },
          ),

          ListTile(
            title:  Text('Tasks'),
            onTap: () {
              dbchatcontroller.setonlinetooffline();
              Get.offAll(alltasks());
              //Navigator.pop(context);
            },
          ),

        ],
      ),
    ) ;
  }
}
