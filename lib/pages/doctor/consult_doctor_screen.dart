import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/consultation_item.dart';

class ConsultDoctorList extends StatelessWidget {
  const ConsultDoctorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: CustomText(
          text: 'Consultations',
          size: Sizes.textSize(context)['h4'],
        ),
        leading: CustomBackButton(context),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                appColor.withOpacity(0.2),
                Colors.transparent,
                appColor.withOpacity(0.1),
                appColor.withOpacity(0.3),
                appColor.withOpacity(0.6),
              ],
            )
        ),
        child: FutureBuilder<List>(
            future: getConsultationList(),
            builder: (context,snapshot) {
              if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
                return ListView.builder(
                  itemBuilder:(context, index) {
                    return ConsultationItem(consultModel: ConsultModel.fromJson(snapshot.data![index]),);
                  },
                  itemCount: snapshot.data?.length ?? 0,
                );
              }else if(snapshot.hasError){
                return Center(child: CustomText(text: 'Something Error ,${snapshot.error}Please try again',),);
              }else if (snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else{
                return Center(child: CustomText(text: 'No Consultations Yet',),);
              }
            }
        ),
      ),
    );
  }

  Future<List> getConsultationList() async{
    var user =Get.put(UserController()).userData.value;

    return await FirebaseMethods().getListFromFirestore('${user.reference?.path}/$consultationsCollection');

  }
}
