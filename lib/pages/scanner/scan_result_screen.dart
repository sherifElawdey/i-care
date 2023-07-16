import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_images.dart';
import 'package:icare/widgets/custom_text.dart';

class ScannerResultScreen extends StatelessWidget {
  dynamic item;
  String screen;

  ScannerResultScreen({Key? key, required this.item, required this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: '$screen Details ',
          size: Sizes.textSize(context)['h3'],
        ),
        leading: CustomBackButton(context),
      ),
      body: screen == ordersCollection
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                CustomTextIcon(
                  context: context,
                  icon: CupertinoIcons.square,
                  text: 'Name : ${item.name}',
                  textSize: Sizes.textSize(context)['h2'],
                ),
                CustomTextIcon(
                  context: context,
                  icon: Icons.attach_money,
                  text: 'price : ${item.price}',
                  textSize: Sizes.textSize(context)['h2'],
                ),
                CustomTextIcon(
                  context: context,
                  icon: Icons.numbers,
                  text: 'amount : ${item.amount}',
                  textSize: Sizes.textSize(context)['h2'],
                ),
                const Divider(),
                CustomText(
                  text: 'Buyer info :- ',
                  size: Sizes.textSize(context)['h2'],
                  fontWeight: FontWeight.w600,
                  color: appColor,
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: getBuyerData(buyerPath: item.buyerReference ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      UserModel buyer = UserModel.fromJson(snapshot.data ?? {});
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              expandProfileImage(buyer.picture ?? '');
                            },
                            child: ClipRRect(
                              borderRadius: Sizes.borderRadius(context)['r5'],
                              child: Image.network(
                                buyer.picture ?? '',
                                height: Sizes.widthScreen(context) * 0.3,
                                width: Sizes.widthScreen(context) * 0.3,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    ImagePath.emptyProfile,
                                    height: Sizes.widthScreen(context) * 0.3,
                                    width: Sizes.widthScreen(context) * 0.3,
                                  );
                                },
                              ),
                            ),
                          ),
                          CustomText(
                            text: '>>  Name : ${buyer.name}',
                            size: Sizes.textSize(context)['h2'],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
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
                          const SizedBox(
                            height: 8,
                          ),
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
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: CustomText(
                          text: 'No Data',
                        ),
                      );
                    }
                  },
                )
              ],
            )
          : FutureBuilder<Map<String, dynamic>>(
              future: getOrderDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  var user = UserModel.fromJson(snapshot.data ?? {});
                  return SingleChildScrollView(
                    padding: Sizes.paddingTextFieldHorizontal(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            expandProfileImage(user.picture ?? '');
                          },
                          child: profilePicture(user.picture??'', Sizes.widthScreen(context) * 0.3,)
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomText(
                          text: '${user.name}',
                          size: Sizes.textSize(context)['h2'],
                          fontWeight: FontWeight.w600,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: '>>  payed : ${item.payed}',
                          size: Sizes.textSize(context)['h2'],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: '>>  date : ${item.appointmentDate}',
                          size: Sizes.textSize(context)['h2'],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: '>> state : ${item.appointmentState}',
                          size: Sizes.textSize(context)['h2'],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: '>>  Address :',
                          size: Sizes.textSize(context)['h2'],
                          color: appColor,
                        ),
                        CustomText(
                          text: '${user.address}',
                          size: Sizes.textSize(context)['h2'],
                          maxLines: 3,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: CustomText(
                      text:
                          'Something Error ,${snapshot.error}Please try again',
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: CustomText(
                      text: 'No Data Yet',
                    ),
                  );
                }
              }),
    );
  }

  Future<Map<String, dynamic>> getOrderDetails() async {
    if (screen == ordersCollection) {
      return await FirebaseMethods().getModelFromFirestore(
        medicinesCollection,
        item.medicineId.toString(),
      );
    } else {
      return await FirebaseMethods().getModelFromFirestore(
        userCollection,
        item.patientId.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> getBuyerData({required String buyerPath}) async {
    return await FirebaseMethods().getModelFromFirestore(
        buyerPath.split('/').first, buyerPath.split('/').last);
  }
}
