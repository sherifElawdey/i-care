import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/medicine.dart';
import 'package:icare/modules/order_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/profile/my_order_list_screen.dart';
import 'package:icare/pages/scanner/qr_scanner.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:icare/widgets/loading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderItem extends StatelessWidget {
  OrderModel order;
  OrderItem({Key? key,required this.order}) : super(key: key);
  var currentUser=Get.put(UserController()).userData.value;

  isPharmacy()=> currentUser.administration==Administration.pharmacy.name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:const EdgeInsets.all(8),
      child: GestureDetector(
        onTap:(){
          orderDetails(context);
        },
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                if(isPharmacy()){
                  scanQrCode();
                }
              },
              child: QrImage(data: order.id??'',
                size: 120,
                backgroundColor: whiteColor,
              ),
            ),
            const SizedBox(width: 4,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: order.name??'order name',
                    size: Sizes.textSize(context)['h2'],
                  ),
                  const Divider(
                    endIndent: 30,
                  ),
                  CustomTextIcon(
                    context: context,
                    text: 'price : ${order.price??'order price'}',
                    icon: Icons.attach_money,
                  ),
                  CustomText(
                    text: 'amount : ${order.amount??'order amount'}',
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: (){deleteItem(context);},
              icon:const Icon(Icons.delete_outline,color: errorColor,size: 30,),
            )
          ],
        ),
      ),
    );
  }

  void deleteItem(BuildContext context) {
    customDialog(
      title: 'Delete Item',
      contentText: 'Do you want delete this item',
      okText: 'yes',
      cancelText: 'Cancel',
      okTap: ()async{
        showLoading(context: context, dismissible: false);
        if(isPharmacy()){
          await FirebaseMethods().removeModel(
            '${currentUser.reference?.path}/$ordersCollection/${order.id}'
          ).whenComplete(() async {
            await DataBaseSql().deleteItem(sqlOrderTable, order.id??'').whenComplete((){
              Get.back();
              Get.back();
              goToPageReplace(context, OrderListScreen());
              customSnackBar(
                  title: 'this order was deleted successfully'
              );
            });
          });
        }else{
          await DataBaseSql().deleteItem(sqlOrderTable, order.id??'').whenComplete((){
            Get.back();
            Get.back();
            goToPageReplace(context, OrderListScreen());
            customSnackBar(
                title: 'this order was deleted successfully'
            );
          });
        }
      }
    );
  }

  orderDetails(BuildContext context){
    customBottomSheet(context,
        FutureBuilder<Map<String,dynamic>>(
          future: getOrderDetails(),
          builder: (context,snapshot){
            if(snapshot.hasData && snapshot.data!=null && snapshot.data!.isNotEmpty){
              var medicine=MedicineModel.fromJson(snapshot.data??{});
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.heightScreen(context)*0.03),
                    child: IconButton(
                      icon:const Icon(Icons.keyboard_arrow_down_outlined,size: 40,),
                      onPressed: (){
                        Get.back();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: Sizes.paddingTextFieldHorizontal(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isPharmacy()
                                  ? CustomButton(
                                context: context,
                                text: 'Scan Qr Code',
                                onTap: (){
                                  scanQrCode();
                                },
                              )
                              : QrImage(data: order.id.toString(),size: 200,backgroundColor: whiteColor,),
                            ],
                          ),
                          const Divider(),
                          CustomTextIcon(
                            context: context,
                            icon: CupertinoIcons.square,
                            text: 'Name : ${order.name}',
                            textSize: Sizes.textSize(context)['h2'],
                          ),
                          CustomTextIcon(
                            context: context,
                            icon: Icons.attach_money,
                            text: 'price : ${order.price}',
                            textSize: Sizes.textSize(context)['h2'],
                          ),
                          CustomTextIcon(
                            context: context,
                            icon: Icons.numbers,
                            text: 'amount : ${order.amount}',
                            textSize: Sizes.textSize(context)['h2'],
                          ),
                          const Divider(),

                          CustomText(
                            text:isPharmacy()?'Buyer info :- ': 'Pharmacy info :- ',
                            size: Sizes.textSize(context)['h2'],
                            fontWeight: FontWeight.w600,
                            color: appColor,
                          ),
                         isPharmacy()
                             ? FutureBuilder<Map<String,dynamic>>(
                           future: getBuyerData(buyerPath:order.buyerReference ?? ''),
                           builder: (context, snapshot) {
                             if(snapshot.hasData && snapshot.data!=null){
                               UserModel buyer =UserModel.fromJson(snapshot.data??{});
                               return Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   CustomText(
                                     text: '>>  Name : ${buyer.name}',
                                     size: Sizes.textSize(context)['h2'],
                                   ),
                                   const SizedBox(height: 8,),
                                   CustomText(
                                     text: '>>  Address :',
                                     size: Sizes.textSize(context)['h2'],
                                     color: appColor,
                                   ),
                                   CustomText(
                                     text: '${buyer.address}',
                                     size: Sizes.textSize(context)['h2'],
                                     maxLines: 3,
                                   ),
                                   const SizedBox(height: 8,),
                                   CustomText(
                                     text: '>>  Phone Number : ',
                                     size: Sizes.textSize(context)['h2'],
                                     color: appColor,
                                   ),
                                   CustomText(
                                     text: '${buyer.phoneNumber}',
                                     size: Sizes.textSize(context)['h2'],
                                   ),
                                 ],
                               );
                             }else if(snapshot.connectionState==ConnectionState.waiting){
                               return const Center(child: CircularProgressIndicator(),);
                             }else{
                               return Center(child: CustomText(text: 'No Data',),);
                             }
                           },
                         )
                             : FutureBuilder<Map<String,dynamic>>(
                            future: getPharmacyData(pharmacyId:medicine.pharmacyId?.split(',').first??''),
                            builder: (context, snapshot) {
                              if(snapshot.hasData && snapshot.data!=null){
                                UserModel pharmacy =UserModel.fromJson(snapshot.data??{});
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: '>>  Name : ${pharmacy.name}',
                                      size: Sizes.textSize(context)['h2'],
                                    ),
                                    CustomText(
                                      text: '>>  Rating : ${pharmacy.rating}',
                                      size: Sizes.textSize(context)['h2'],
                                    ),
                                    const SizedBox(height: 8,),
                                    CustomText(
                                      text: '>>  Address :',
                                      size: Sizes.textSize(context)['h2'],
                                      color: appColor,
                                    ),
                                    CustomText(
                                      text: '${pharmacy.address}',
                                      size: Sizes.textSize(context)['h2'],
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 8,),
                                    CustomText(
                                      text: '>>  Days of work : ',
                                      size: Sizes.textSize(context)['h2'],
                                      color: appColor,
                                    ),
                                    CustomText(
                                      text: '${pharmacy.daysOfWork}',
                                      size: Sizes.textSize(context)['h2'],
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 8,),
                                    CustomText(
                                      text: '>>  Times of work : ${pharmacy.timesOfWork}',
                                      size: Sizes.textSize(context)['h2'],
                                      color: appColor,
                                    ),
                                  ],
                                );
                              }else if(snapshot.connectionState==ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator(),);
                              }else{
                                return Center(child: CustomText(text: 'No Data',),);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }else if(snapshot.hasError){
              return Center(child: CustomText(text: ',${snapshot.error}Please try again',maxLines: 5,),);
            }else if (snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else{
              return Center(child: CustomText(text: 'No Data Yet',),);
            }
          }
        ),
      isScroll: true,
    );
  }

  Future<Map<String,dynamic>> getOrderDetails()async{
    Map<String, dynamic> model={};
    await FirebaseMethods().getModelFromFirestore(
      medicinesCollection,
      order.medicineId.toString(),
    ).then((value) async{
      if(value!=null){
        model=value;
      }else{
        model = await DataBaseSql().getItem(sqlOrderTable, order.id.toString())??{};

      }
    });
     return model;
  }

  Future<Map<String,dynamic>>getPharmacyData({required String pharmacyId}) async{
    return await FirebaseMethods().getModelFromFirestore(pharmacyCollection, pharmacyId);
  }

  Future<Map<String,dynamic>> getBuyerData({required String buyerPath}) async{
    return await FirebaseMethods().getModelFromFirestore(
        buyerPath.split('/').first,
        buyerPath.split('/').last
    );
  }

  void scanQrCode(){
    Get.to(QrScanner(list:[order],screen: ordersCollection,));
  }

}
