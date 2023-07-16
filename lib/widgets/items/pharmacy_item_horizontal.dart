import 'package:flutter/material.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/user_details.dart';

class PharmacyItemHorizontal extends StatelessWidget {
  UserModel userModel;

  PharmacyItemHorizontal({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: Sizes.borderRadius(context)['r1']!,
      ),
      child: SizedBox(
        width: Sizes.widthScreen(context) * 0.5,
        child: GestureDetector(
            onTap: () {
              getDoctorDetails(context, userModel);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    //margin:const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: Sizes.borderRadius(context)['r1'],
                      image: userModel.picture == null
                          ? const DecorationImage(
                              image: AssetImage(ImagePath.emptyMedicine),
                              fit: BoxFit.fitHeight,
                            )
                          : DecorationImage(
                              image: NetworkImage('${userModel.picture}'),
                              fit: BoxFit.cover,
                            ),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: '${userModel.name} pharmacy ' ,
                          //size: Sizes.textSize(context)['h2'],
                          maxLines: 3,
                        ),
                      ),
                      CustomTextIcon(
                        context: context,
                        icon: Icons.star_half,
                        iconColor: Colors.yellow.shade800,
                        iconSize: Sizes.iconSize(context)['s1'],
                        textSize: Sizes.textSize(context)['h1'],
                        text: '(${userModel.rating ?? '0.0'})',
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
