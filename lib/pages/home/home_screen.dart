import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/widgets/home_body.dart';
import 'package:icare/pages/home/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  UserModel user =Get.put(UserController()).userData.value;
  @override
  Widget build(BuildContext context){

    return FutureBuilder<UserModel?>(
      future:user.name==null
          ? getData()
          : null,
      builder: (context,snapshot) {
        if(user.name!=null){
          return SingleChildScrollView(
            padding:const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                HomeHeader(user: user),
                const SizedBox(height: 32,),
                HomeBody(),
              ],
            ),
          );

        } else if(snapshot.hasError){
          return const Center(child: Text(' something error'),);
        }else{
          return const Center(child:  CircularProgressIndicator());
        }
      }
    );
  }

  Future<UserModel?> getData()async{
    if(user.name==null){
      user = await Get.put(UserController()).getUserData();
     return user;
    }else{
      return  null;
    }

  }
/*  uploadAll()async{
    List<UserModel> list =[
      UserModel(
        title: 'doctor title ',
        picture: 'https://familydoctor.org/wp-content/uploads/2018/02/41808433_l.jpg',
      ),
      UserModel(
        title: 'Offer title Offer title Offer title',
        description: ' description description description description description description description description description description description description',
        picture: 'https://mybayutcdn.bayut.com/mybayut/wp-content/uploads/Pharmacies-in-Dubai-Cover-02-07.jpg',

      ),
      UserModel(
        title: 'Offer title Offer title Offer title',
        description: ' description description description description description description description description description description description description',
        picture: 'https://mybayutcdn.bayut.com/mybayut/wp-content/uploads/Pharmacies-in-Dubai-Cover-02-07.jpg',

      ),
      UserModel(
        title: 'Offer title Offer title Offer title',
        description: ' description description description description description description description description description description description description',
        picture: 'https://media.capc.org/images/AdobeStock_274131656.original.original.jpg',
      ),
      UserModel(
        title: 'Offer title Offer title Offer title',
        description: ' description description description description description description description description description description description description',
        picture: 'https://indoreinstitute.com/wp-content/uploads/2021/09/pharmaceutical-industry.jpg',

      ),
    ];
    await FirebaseMethods().uploadListToFirestore(offersCollection, list,);
  }*/
}
