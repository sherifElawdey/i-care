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
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/loading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MedicineItem extends StatefulWidget {

  MedicineModel medicine;
  MedicineItem({Key? key,required this.medicine}) : super(key: key);

  @override
  State<MedicineItem> createState() => _MedicineItemState();
}

class _MedicineItemState extends State<MedicineItem> {
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: Sizes.borderRadius(context)['r1']!
      ),
      child: GestureDetector(
        onTap: (){
          getMedicineDetails(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Expanded(
              child: ClipRRect(
                borderRadius: Sizes.borderRadius(context)['r1'],
                child: Image.network(
                  widget.medicine.picture ?? '',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.medicine.name ?? 'Name',
                  ),
                  Row(
                    children: [
                      CustomTextIcon(
                        context: context,
                        text: widget.medicine.price==Prices.free.name? widget.medicine.price ?? 'price': '${ widget.medicine.price } EGP',
                        //textSize: Sizes.textSize(context)['h2'],
                        textColor: Colors.green,
                        iconSize: 18,
                        icon: Icons.attach_money,
                      ),

                    ],
                  ),
                  CustomTextIcon(
                    context: context,
                    text: widget.medicine.pharmacyId?.split(',')[1] ?? 'Pharmacy',
                    textSize: Sizes.textSize(context)['h1'],
                    icon: Icons.location_on_outlined,
                  ),
                  CustomText(
                    text: 'amount : ',
                    size: Sizes.textSize(context)['h1'],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed:(){
                          setState(() {
                            if(amount>1){
                              --amount;
                            }
                          });
                        },
                        icon:const Icon(Icons.arrow_back_ios,size: 15,),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: appColor),
                            borderRadius: Sizes.borderRadius(context)['r1']
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: '$amount',
                        ),
                      ),
                      IconButton(
                        onPressed:(){
                          setState((){
                            if(amount<int.parse(widget.medicine.amount??'0')){
                              ++amount;
                            }
                          });
                        },
                        icon:const Icon(Icons.arrow_forward_ios,size: 15,),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: CustomText(text: 'Buy Now',),
                          onPressed: ()async {
                            buyNowDetails(context,pharmacyId:widget.medicine.pharmacyId ?? '');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMedicineDetails(BuildContext context) {
    customBottomSheet(context,
      Padding(
          padding:const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(widget.medicine.picture??'',
                      height: Sizes.widthScreen(context)*0.4,
                      width:  Sizes.widthScreen(context)*0.4,
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                CustomText(
                  text: '>> Name : ${widget.medicine.name}',
                  size: Sizes.textSize(context)['h2'],
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    CustomText(
                      text: '>> Price : ${widget.medicine.price}',
                      size: Sizes.textSize(context)['h2'],
                    ),
                    const SizedBox(width: 16,),
                    CustomText(
                      text: widget.medicine.availableNow! ?'available Now ':'Not available',
                      size: Sizes.textSize(context)['h2'],
                      color: widget.medicine.availableNow! ? Colors.green:errorColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                CustomText(
                  text: '>> Amount : ${widget.medicine.amount}',
                  size: Sizes.textSize(context)['h2'],
                ),
                const Divider(),
                CustomText(
                  text: 'Pharmacy info :- ',
                  size: Sizes.textSize(context)['h2'],
                  fontWeight: FontWeight.w600,
                  color: appColor,
                ),
                FutureBuilder<Map<String,dynamic>>(
                  future: getPharmacyData(pharmacyId:widget.medicine.pharmacyId?.split(',').first??''),
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
      isScroll: true,
    );
  }

  Future<Map<String,dynamic>>getPharmacyData({required String pharmacyId}) async{
    return await FirebaseMethods().getModelFromFirestore(pharmacyCollection, pharmacyId);
  }

  Future buyNowDetails(BuildContext context,{required String pharmacyId}) async{
    var user =Get.put(UserController()).userData.value;
    if(user.administration==Administration.user.name){
      showLoading(context: context, dismissible: false);

      var order =OrderModel(
        isDone:false.toString(),
        name: widget.medicine.name.toString(),
        price: widget.medicine.price,
        buyerReference: user.reference?.path.toString(),
        amount: amount.toString(),
        medicineId: widget.medicine.id,
      ).toJson();

      if(widget.medicine.amount=='1' || int.parse(widget.medicine.amount??'0')==amount){
        await FirebaseMethods().addModelToFirestore(
            collection: '$pharmacyCollection/${pharmacyId.split(',').first.toString()}/$ordersCollection',
            model: order
        ).then((value) async{
          await FirebaseMethods().removeModel(
              '$medicinesCollection/${widget.medicine.id}'
          ).whenComplete(() {
            setState(() {
              Get.back();
            });
          });
          order['id']=value;
          DataBaseSql().addItem(ordersCollection, order).then((value)=> print(value)).whenComplete(()=>customBottomSheet(context,
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    CustomText(
                      text: 'Your Order is Done',
                      size: Sizes.textSize(context)['h3'],
                      fontWeight: FontWeight.w600,
                      color: appColor,
                    ),
                    QrImage(
                      data: 'value',
                      size: 200,
                    ),
                    const SizedBox(height: 30,),
                    CustomButton(
                      text: 'Go To My Orders',
                      context: context,
                      onTap: (){
                        Get.back();
                        Get.to(OrderListScreen());
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
        });
      }else{
        await FirebaseMethods().addModelToFirestore(
            collection: '$pharmacyCollection/${pharmacyId.split(',').first.toString()}/$ordersCollection',
            model: order
        ).then((value) async{
          order['id']=value;
          await FirebaseMethods().updateModel(
            path: '$pharmacyCollection/${pharmacyId.split(',').first.toString()}/$ordersCollection/$value',
            data: {
              'amount': (int.parse(widget.medicine.amount ?? '0')-amount).toString()
            },
          );
          setState(() {
            Get.back();
          });
          DataBaseSql().addItem(ordersCollection, order)
              .then((value)=> print(value)).whenComplete(()=>customBottomSheet(context,
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    CustomText(
                      text: 'Your Order is Done',
                      size: Sizes.textSize(context)['h3'],
                      fontWeight: FontWeight.w600,
                      color: appColor,
                    ),
                    QrImage(
                      data: 'value',
                      size: 200,
                      backgroundColor: whiteColor,
                    ),
                    const SizedBox(height: 30,),
                    CustomButton(
                      text: 'Go To My Orders',
                      context: context,
                      onTap: (){
                        Get.back();
                        Get.to(OrderListScreen());
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
        });
      }

    }else{
      customSnackBar(title: 'sorry, you cant bay this medicine');
    }

  }

}