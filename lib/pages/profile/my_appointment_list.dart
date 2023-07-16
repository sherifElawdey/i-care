import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/appointment_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/scanner/qr_scanner.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/appointment_item.dart';
import 'package:icare/widgets/loading.dart';

class AppointmentListScreen extends StatelessWidget {
  AppointmentListScreen({Key? key,}) : super(key: key);
  var currentUser=Get.put(UserController()).userData.value;
  List appointmentList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'My Appointment List',
            size: Sizes.textSize(context)['h3'],
          ),
          leading: CustomBackButton(context),
          actions: [
            if(currentUser.administration==Administration.doctor.name)
              IconButton(
                  onPressed: ()async{
                    Get.to(QrScanner(list:appointmentList,screen: appointmentsCollection,));
                  },
                  icon: Icon(Icons.qr_code_scanner,color: appColor,)),
            IconButton(
                onPressed: () async {
                  showLoading(context: context, dismissible: false);
                  await DataBaseSql().deleteAll(sqlAppointmentTable).whenComplete(() async{
                    if(currentUser.administration==Administration.doctor.name){
                      await FirebaseMethods().removeCollection('${currentUser.reference?.path}/$ordersCollection');
                    }
                  }).whenComplete((){
                    Get.back();
                    goToPageReplace(context, AppointmentListScreen());
                  });
                },
                icon: const Icon(Icons.clear_all,color: errorColor,)),
          ],
        ),
        body: FutureBuilder<List>(
            future: getOrderList(),
            builder: (context,snapshot){
              if(snapshot.hasData && snapshot.data!=null && (snapshot.data?.isNotEmpty??false)){
                return ListView.builder(
                  itemBuilder:(context, index) {
                    var appointment = AppointmentModel.fromJson(snapshot.data?[index] ?? {});
                    return AppointmentItem(appointment:appointment);
                  },
                  itemCount: snapshot.data?.length ?? 0,
                );
              }else if(snapshot.hasError){
                return Center(child: CustomText(text: 'Something Error ,${snapshot.error}Please try again',),);
              }else if (snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else{
                return Center(child: CustomText(text: 'No appointment Yet',),);
              }
            }
        )
    );
  }

  Future<List> getOrderList()async{
    if(currentUser.administration==Administration.doctor.name){
      List list = await FirebaseMethods().getListFromFirestore('${currentUser.reference?.path}/$appointmentsCollection');
      appointmentList=list;
      return list;
    }else{
      return await DataBaseSql().getAllItems(sqlAppointmentTable);
    }

  }
}
