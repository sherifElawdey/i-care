import 'package:flutter/material.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/widgets/home_page_view.dart';
import 'package:icare/widgets/custom_text.dart';

class HomeHeader extends StatelessWidget {
  UserModel user;
  HomeHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.heightScreen(context)*0.4,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children:[
          Positioned.fill(
            bottom: Sizes.heightScreen(context)*0.1,
            child: Container(
              alignment: Alignment.topLeft,
              width: Sizes.widthScreen(context),
              decoration: BoxDecoration(
                  borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                  color: appColor
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Sizes.widthScreen(context)*0.02,
                  right: 16,
                  top: Sizes.heightScreen(context)*0.07,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Hello ${user.name!=null?user.name?.split(' ').first:'Dear'},'.padLeft(15),
                      size: Sizes.textSize(context)['h3'],
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                    CustomTextIcon(
                      context: context,
                      text: 'In: ${user.address?.split(',')[1]},${user.address?.split(',')[2]}',
                      icon: Icons.location_on_outlined,
                      iconColor: whiteColor,
                      textSize: Sizes.textSize(context)['h2'],
                      textColor: whiteColor,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            child: PageViewWidget(),
          ),
        ],
      ),
    );
  }

}
