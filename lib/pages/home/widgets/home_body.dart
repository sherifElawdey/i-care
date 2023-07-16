import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/widgets/head_items.dart';
import 'package:icare/pages/home/widgets/nearby_pharmacy.dart';
import 'package:icare/pages/home/widgets/top_rated.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/pharmacy_item_horizontal.dart';

class HomeBody extends StatelessWidget {
  HomeBody({Key? key}) : super(key: key);
  UserModel user = Get.put(UserController()).userData.value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Sizes.paddingScreenHorizontal(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadItemsWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: '  Top Doctors rated :'.padLeft(11),
                size: Sizes.textSize(context)['h2'],
              ),
              CustomTextButton(
                text: 'see all',
                //size: Sizes.textSize(context)['h1'],
                onTap: (){},
              )
            ],
          ),
          const TopRatedDoctors(),
          const Divider(indent: 16,endIndent: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: '  Pharmacies in ${user.address?.split(',')[1]} :'.padLeft(11),
                size: Sizes.textSize(context)['h2'],
              ),
              CustomTextButton(
                text: 'see all',
                //size: Sizes.textSize(context)['h1'],
                onTap: (){},
              )
            ],
          ),
          const NearbyPharmacy(),
         /* SizedBox(
            height: Sizes.heightScreen(context)*0.2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder:((context, index){
                  return PharmacyItemHorizontal(
                    userModel: UserModel(
                        picture: 'https://i.pinimg.com/564x/3d/a6/e4/3da6e40bcf02113b63a6bac305d3646f.jpg',
                        name: 'صيدليات العزبي',
                        rating: 4.2
                    ),
                  );
                })
            ),
          ), *///for  test
        ],
      ),
    );
  }
}
