import 'package:flutter/material.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/home/methods.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/doctor_item_horizontal.dart';

class TopRatedDoctors extends StatelessWidget {
  const TopRatedDoctors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>?>?>(
        future: getTopRated(limit: 5),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return Container(
              height: snapshot.data!.length == 1
                ? Sizes.heightScreen(context) * 0.15
                : Sizes.heightScreen(context) * 0.3,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: Sizes.borderRadius(context)['r2'],
                border: Border.all(color: greyColor),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                itemBuilder: (context, index) => Row(
                  children: [
                    CustomText(
                      text: '${index + 1}',
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                    Expanded(
                        child: DoctorItemHorizontal(
                            user: UserModel.fromJson(
                                snapshot.data!.toList()[index]!))),
                  ],
                ),
                itemCount: snapshot.data?.length ?? 0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CustomText(
                text: 'Something Error',
              ),
            );
          } else {
            return Container(
              height: Sizes.heightScreen(context) * 0.3,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: Sizes.borderRadius(context)['r2'],
                border: Border.all(color: greyColor),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => Row(
                  children: [
                    CustomText(
                      text: '${index + 1}',
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                    Expanded(
                        child: Container(
                      height: Sizes.widthScreen(context) * 0.2,
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: greyColor.withOpacity(0.7),
                      child: CustomText(
                        text: 'Loading...',
                      ),
                    )),
                  ],
                ),
                itemCount: 3,
              ),
            );
          }
        });
  }
}
