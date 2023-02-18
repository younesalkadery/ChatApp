
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../controller/databasechat.dart';
import '../controller/logincontroller.dart';
import 'chatuser.dart';
class chatgroup extends StatelessWidget {

  GlobalKey<FormState> formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
print("in builder");
    logincontroller loginController=Get.find<logincontroller>();

    databasechat dbchatcontroller=Get.put(databasechat());
    TextEditingController message=TextEditingController();
    TextEditingController location=TextEditingController();
    TextEditingController tousierid=TextEditingController();


    FocusNode myFocusNode = FocusNode();
    TextEditingController group=TextEditingController();



    return Scaffold(appBar: AppBar(title:Center(child: Text("Add Group")),backgroundColor:Color(0xff25D366),actions: [
      IconButton(iconSize: 30, icon: Icon(Icons.arrow_forward),onPressed:() async{
        Get.off(chatusers());

      }),
    ],),body:
    Form(
      key:formkey ,
      child: Column(children: [
       GetBuilder<databasechat>( // specify type as Controller
        init: databasechat(), // intialize with the Controller
        builder: (value) => TextFormField(
          controller: group,
          onTap: (){
            if(value.testload==0) {
              print('will add user');
              dbchatcontroller.changeloadstate();
             dbchatcontroller.getuserbelonggroup();
            }
          },
          //controller:controller.email ,
          decoration: const InputDecoration(suffixIcon:Icon(Icons.group),border: OutlineInputBorder(borderRadius:BorderRadius.zero),label:Text('group')
          ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter Group name';
    }
    return null;
    },

        )),
       Row(
              children: [
                Text('Add user to group:'),
                Spacer(),
                Container(
                  child:
                  GetBuilder<databasechat>( // specify type as Controller
                      init: databasechat(), // intialize with the Controller
                      builder: (mvalue) =>
                          DropdownButton(
                            //put this value null or will give error
                            value:null,
                            onChanged: (newValue) {
                              print(newValue);
                              dbchatcontroller.setSelected(newValue.toString());
                            },

                            items: mvalue.listofuser.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          )),
                ),


              ],
            ),
        SizedBox(height: 20,),
            Expanded(
              child:
              GetBuilder<databasechat>( // specify type as Controller
                  init: databasechat(), // intialize with the Controller
                  builder: (mvalue) =>
              ListView.builder(
                  itemCount:mvalue.listusergroup.length,
                  itemBuilder: (context,index){
                    return
                    Container(color:Color(0xff25D366),
                      child: Row(children: [
                      Center(child: Text(mvalue.listusergroup.elementAt(index).toString())),
                      Spacer(),
                      IconButton(iconSize: 30, icon: Icon(Icons.delete),onPressed:() {
                         dbchatcontroller.removeuser(mvalue.listusergroup.elementAt(index));
                        })
                      ],),
                    );

                  })),
            ),


        FloatingActionButton(backgroundColor:Color(0xff25D366),onPressed: () async{
      if(formkey.currentState!.validate()){
        await  dbchatcontroller.checkgroupid(loginController.useremail,group.text).then((value) {
          Future.delayed(const Duration(seconds: 2), () {

            Get.off(chatusers()); // Prints after 1 second.
          });
        });
      }


        },child: Text("Submit"),),


      ],),
    ),);
  }
}
