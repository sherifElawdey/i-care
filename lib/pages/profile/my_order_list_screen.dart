import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/order_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/scanner/qr_scanner.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/order_item.dart';
import 'package:icare/widgets/loading.dart';

class OrderListScreen extends StatelessWidget {
  OrderListScreen({Key? key}) : super(key: key);
  var currentUser=Get.put(UserController()).userData.value;
  List orderList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'My Orders',
          size: Sizes.textSize(context)['h3'],
        ),
        leading: CustomBackButton(context),
        actions: [
          if(currentUser.administration==Administration.pharmacy.name)
              IconButton(
            onPressed: ()async{

              Get.to(QrScanner(list: orderList,screen: ordersCollection,));
            },
            icon: Icon(Icons.qr_code_scanner,color: appColor,)),
          IconButton(
            onPressed: () async {
              showLoading(context: context, dismissible: false);
              await DataBaseSql().deleteAll(sqlOrderTable).whenComplete(() async{
                if(currentUser.administration==Administration.pharmacy.name){
                  await FirebaseMethods().removeCollection('${currentUser.reference?.path}/$ordersCollection');
                }
              }).whenComplete((){
                Get.back();
                goToPageReplace(context, OrderListScreen());
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
                  var order= OrderModel.fromJson(snapshot.data?[index] ?? {});
                  return OrderItem(order : order);
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          }else if(snapshot.hasError){
            return Center(child: CustomText(text: 'Something Error ,${snapshot.error}Please try again',),);
          }else if (snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else{
            return Center(child: CustomText(text: 'No Order Yet',),);
          }
        }
      )
    );
  }
  Future<List> getOrderList()async{
    if(currentUser.administration==Administration.pharmacy.name){
      List list= await FirebaseMethods().getListFromFirestore(
        '${currentUser.reference?.path}/$ordersCollection'
      );
      orderList=list;
      return list ;
    }else{
      try{
        return await DataBaseSql().getAllItems(sqlOrderTable);
      }catch(e){
        //customSnackBar(title: '$e');
        return [];
      }
    }

  }
}
