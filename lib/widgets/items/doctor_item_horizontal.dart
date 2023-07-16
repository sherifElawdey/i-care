import 'package:flutter/material.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/user_details.dart';

class DoctorItemHorizontal extends StatelessWidget {
  UserModel user;
  DoctorItemHorizontal({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      height: Sizes.widthScreen(context)*0.24,
      width: double.infinity,
      margin:const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [customShadow()],
        borderRadius: Sizes.borderRadius(context)['r1'],
        color: Theme.of(context).cardColor,
      ),
      child: GestureDetector(
        onTap: (){
          getDoctorDetails(context, user);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: Sizes.borderRadius(context)['r1'],
              child: Image.network(user.picture??'',
                width: Sizes.widthScreen(context)*0.2,
                height: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(ImagePath.emptyProfile,
                    width: Sizes.widthScreen(context)*0.2,
                    height: double.infinity,
                    fit: BoxFit.fill,);
                },
              ),
            ),
            const SizedBox(width: 6,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  CustomText(
                    text: '${user.name}',
                  ),
                  CustomText(
                    text: 'Title: ${user.title}',
                    size: Sizes.textSize(context)['h1'],
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'specialization: ${user.specialization}',
                        size: Sizes.textSize(context)['h1'],
                      ),
                      CustomTextIcon(
                        context: context,
                        icon: Icons.star_half,
                        iconColor: Colors.yellow.shade800,
                        text: '(${user.rating ?? '0.0'})',
                      ),
                      const SizedBox()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
