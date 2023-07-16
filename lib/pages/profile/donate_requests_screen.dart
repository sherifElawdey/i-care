import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/medicine.dart';
import 'package:icare/modules/order_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/medicine_request_item.dart';
import 'package:icare/widgets/items/order_item.dart';

class DonateRequestsScreen extends StatelessWidget {
  DonateRequestsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Donate Requests',
            size: Sizes.textSize(context)['h3'],
          ),
          leading: CustomBackButton(context),
          actions: [
            IconButton(
                onPressed: ()async{
                  //await LocalDatabase().clear(ordersCollection).whenComplete(() => Get.back());
                },
                icon: const Icon(Icons.clear_all,color: errorColor,))
          ],
        ),
        body: FutureBuilder<List>(
            future: getRequestsList(),
            builder: (context,snapshot) {
              if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
                return ListView.builder(
                  itemBuilder:(context, index) {
                    var medicine= MedicineModel.fromJson(snapshot.data?[index] ?? {});
                    return MedicineRequestItem(medicineModel:medicine);
                  },
                  itemCount: snapshot.data?.length ?? 0,
                );
              }else if(snapshot.hasError){
                return Center(child: CustomText(text: 'Something Error ,Please try again',),);
              }else if (snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else{
                return Center(child: CustomText(text: 'No Requests Yet',),);
              }
            }
        )
    );
  }
  Future<List> getRequestsList()async{
    var user =Get.put(UserController()).userData.value;
    return await FirebaseMethods().getListFromFirestore('$pharmacyCollection/${user.id}/$requestsCollection');
  }


}
