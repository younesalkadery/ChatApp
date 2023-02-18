
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/logincontroller.dart';
import 'login.dart';
class signup extends StatelessWidget {
  GlobalKey<FormState> formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    logincontroller controller=Get.find<logincontroller>();
    TextEditingController user_email=TextEditingController();
    TextEditingController user_password=TextEditingController();
    return Scaffold(backgroundColor:Colors.black,resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.white,elevation: 0.0,centerTitle: true,title: Text('Signup',style:TextStyle(color:Colors.black)),actions: [
          IconButton(iconSize: 30, icon: Icon(Icons.person,color: Colors.black,),onPressed:(){
            Get.to(login());
          })
        ],),
        body:WillPopScope(onWillPop:(){
          Get.defaultDialog(
              title: 'Alarm',
              middleText: 'do you want to exit from app',
              actions: [

                ElevatedButton(onPressed:(){

                }, child: Text('Yes')),

                ElevatedButton(onPressed:(){
                  Get.back();
                },
                    child: Text('NO')),
              ]
          );
          return Future.value(true);
        },child: Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/ch1.png'),
              fit: BoxFit.fill,
            ),
          ),
          margin: EdgeInsets.all(20),
          child:Form(
            key:formkey,
            child: Column(children: [
              TextFormField(
                controller: user_email,
                // validator:(val){
                //  return validateindata(val!,5,50,"email");
                //  },
                //controller:controller.email ,
                decoration: InputDecoration(filled: true, fillColor: Colors.white,suffixIcon:Icon(Icons.email),border: OutlineInputBorder(borderRadius:BorderRadius.circular(30)),label:Text('Email')
                ),
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: user_password,
                //  validator:(val){
                //    return validateindata(val!,5,50,"password");
                //   },
                obscureText: true,
                // controller:controller.password ,
                decoration: InputDecoration(filled: true, fillColor: Colors.white,suffixIcon:Icon(Icons.lock_clock_outlined),border: OutlineInputBorder(borderRadius:BorderRadius.circular(30)),label:Text('Password')),
              ),


              SizedBox(height: 30,),
              SizedBox(width: 100,height: 30,
                child: MaterialButton(
                  onPressed:() async{
                     User result= await controller.signup(user_email.text, user_password.text);
                       if(result!=null){
                         Get.to(login());
                      }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text('Signup'),
                  color: Colors.white,

                ),
              ),

            ],),
          ),) ,));
  }
}

