import 'package:flutter/material.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/methods.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/pharmacy_item_horizontal.dart';

class NearbyPharmacy extends StatelessWidget {
  const NearbyPharmacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNearbyPharmacy(limit: 5),
      builder: (context,snapshot){
      if(snapshot.hasData &&snapshot.data!=null && snapshot.data!.isNotEmpty){
        return SizedBox(
          height: Sizes.heightScreen(context)*0.2,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder:((context, index){
                return PharmacyItemHorizontal(
                  userModel: UserModel.fromJson(snapshot.data!.toList()[index]!),
                );
              })
          ),
        );
      }else if(snapshot.hasData && snapshot.data!=null&& snapshot.data!.isEmpty){
        return Center(
          child: CustomText(text: 'There are no pharmacies in this area',),
        );
      }else if(snapshot.hasError){
        return Center(child: CustomText(text: 'Something Error',),);
      }else{
        return SizedBox(
          height: Sizes.heightScreen(context)*0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder:((context, index){
              return Container(
                width: Sizes.widthScreen(context)*0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: Sizes.borderRadius(context)['r2']!,
                  color: greyColor.withOpacity(0.7)
                ),
                child: CustomText(text: 'Loading',)
              );
            })
        ),
        );
      }
      },
    );
  }
}
