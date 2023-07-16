import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/profile/donate_requests_screen.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/loading.dart';

class DoctorRequestItem extends StatelessWidget {
  Map<String,dynamic> request;
  DoctorRequestItem({Key? key,required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Sizes.borderRadius(context)['r1'],
        color: Theme.of(context).cardColor,
        boxShadow: [customShadow()],
      ),
      margin:const EdgeInsets.all(8),
      height: 160,
      child:GestureDetector(
        onTap: (){
          expandProfileImage(request['idPicture']);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Expanded(
              child:Row(
                children:[
                  ClipRRect(
                    borderRadius: Sizes.borderRadius(context)['r1'],
                    child: Image.network(request['idPicture'],
                      fit: BoxFit.cover,
                      width: 120,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const SizedBox(
                          height: 4,
                        ),

                        CustomText(text:request['name'] ?? 'Doctor Name',
                          size: Sizes.textSize(context)['h2'],
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(text: request['title'],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            StatefulBuilder(
                builder: (context,onState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                side:const BorderSide(color: errorColor),
                                borderRadius: Sizes.borderRadius(context)['r1']!,),),
                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
                            ),
                            child: CustomTextIcon(
                              context: context,
                              text: 'Delete',
                              textColor: errorColor,
                              widthBetween: 4,
                              icon: CupertinoIcons.xmark,
                              iconColor: errorColor,
                            ),
                            onPressed: ()async{
                              showLoading(context: context, dismissible: false);
                              await deleteRequest(context,);
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            context: context,
                            text: 'Accept',
                            radius: Sizes.borderRadius(context)['r1'],
                            padding: const EdgeInsets.all(8),
                            margin:const EdgeInsets.all(8),
                            textSize: Sizes.textSize(context)['h2'],
                            onTap: ()async{
                              await acceptRequest(context).whenComplete(() => onState((){Get.back(closeOverlays: true);}));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
  Future<Map<String,dynamic>> getDoctorDetail()async{
    return await FirebaseMethods().getModelFromFirestore(
        doctorsCollection,
        request['doctorId']
    );
  }

  Future acceptRequest(BuildContext context) async{
    showLoading(context: context, dismissible: false);
    await FirebaseMethods().updateModel(
      path: '$doctorsCollection/${request['doctorId']}',
      data:{
        'administration':Administration.doctor.name,
        'verified':true
      },
    ).whenComplete(() async{
      await FirebaseMethods().removeModel(
          '$requestsCollection/${request['id']}'
      ).whenComplete(() {
        Get.back();
        goToPageReplace(context, DonateRequestsScreen());
      });
    });
  }

  Future deleteRequest(BuildContext context)async{
    await getDoctorDetail().then((value)async{
      await FirebaseMethods().addModelToFirestore(
        collection: userCollection,
        model: value,
      ).whenComplete(() async {
        await FirebaseMethods().removeModel(
            '$doctorsCollection/${request['doctorId']}'
        );
      }).whenComplete(() {
        Get.back();
        goToPageReplace(context, DonateRequestsScreen());
      });
    });

  }

}
