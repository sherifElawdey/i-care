import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/modules/offerModel.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/doctor/consultation_chat_screen.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/doctor_item.dart';
import 'package:icare/widgets/loading.dart';
import 'package:intl/intl.dart';

void getDoctorDetails(BuildContext context,UserModel doctor,{OfferModel? offerModel}) {
  var currentUser = Get.put(UserController()).userData.value;
  double rating=doctor.rating ?? 0;
  customBottomSheet(
    context,
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: Sizes.borderRadius(context)['r1'],
                  child: Image.network(
                    offerModel!=null
                        ? offerModel.picture ??''
                        : doctor.picture ?? '',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImagePath.emptyProfile,
                        height: Sizes.widthScreen(context) * 0.4,
                        width: Sizes.widthScreen(context) * 0.4,
                      );
                    },
                    height: Sizes.widthScreen(context) * 0.3,
                    width: Sizes.widthScreen(context) * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if(offerModel!=null)
              offerDetails(context, offerModel),
            const Divider(),
            Wrap(
              direction: Axis.horizontal,
              children:[
                CustomText(
                  text:doctor.administration==Administration.doctor.name
                      ?'Dr: ${doctor.name}':'Pharmacy: ${doctor.name}',
                  size: Sizes.textSize(context)['h2'],
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  width: 4,
                ),

              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  initialRating: doctor.rating ?? 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    rating=value;
                  },
                ),
                CustomTextButton(
                  text: 'set',
                  color: appColor,
                  onTap: ()async{
                    if(rating==doctor.rating){
                      customSnackBar(
                        title: 'Thanks for rating '
                      );
                    }else{
                      showLoading(context: context, dismissible: false);
                      if(rating > (doctor.rating ?? 0)){
                        if(doctor.rating!>=5){
                          await updateRating(doctor,doctor.rating!+0.03).whenComplete(() {
                            Get.back();
                            customSnackBar(
                                title: 'Thanks for rating '
                            );
                          });
                        }else{
                          await updateRating(doctor,doctor.rating!+0.1).whenComplete(() {
                            Get.back();
                            customSnackBar(
                                title: 'Thanks for rating '
                            );
                          });
                        }
                      }else if(rating < (doctor.rating ?? 0)){
                        if(doctor.rating!<=5){
                          await updateRating(doctor,doctor.rating!-0.03).whenComplete(() {
                            Get.back();
                            customSnackBar(
                                title: 'Thanks for rating '
                            );
                          });
                        }else{
                          await updateRating(doctor,doctor.rating!-0.1).whenComplete(() {
                            Get.back();
                            customSnackBar(
                                title: 'Thanks for rating '
                            );
                          });
                        }
                      }
                    }
                  },
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            if(currentUser.administration==Administration.doctor.name)
                CustomText(
                  text: '>> Title : ${doctor.title}',
                ),
            const SizedBox(
              height: 8,
            ),
            if(currentUser.administration==Administration.doctor.name)
                CustomText(
              text: '>> specialization : ${doctor.specialization}',
            ),
            Row(
              children: [
                if(currentUser.administration==Administration.doctor.name)
                  CustomText(
                  text: '>> Price : ${doctor.disclosurePrice}',
                  size: Sizes.textSize(context)['h2'],
                ),
                const SizedBox(
                  width: 16,
                ),
                CustomTextIcon(
                  context: context,
                  text: '(${doctor.rating ?? '0.0'})',
                  iconSize: 18,
                  icon: CupertinoIcons.star_lefthalf_fill,
                  iconColor: Colors.yellow.shade800,
                  widthBetween: 4,
                ),
              ],
            ),
            CustomText(
              text: '>>  Address :',
              size: Sizes.textSize(context)['h2'],
              color: appColor,
            ),
            CustomText(
              text: '${doctor.address}',
              size: Sizes.textSize(context)['h2'],
              maxLines: 3,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: '>>  Days of work : ',
              size: Sizes.textSize(context)['h2'],
              color: appColor,
            ),
            CustomText(
              text: '${doctor.daysOfWork}',
              size: Sizes.textSize(context)['h2'],
              maxLines: 3,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: '>>  Times of work : ${doctor.timesOfWork}',
              size: Sizes.textSize(context)['h2'],
              color: appColor,
            ),
            const SizedBox(
              height: 8,
            ),
            if(doctor.administration==Administration.doctor.name)
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: Sizes.borderRadius(context)['r1']!,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(8)),
                    ),
                    child: CustomTextIcon(
                      context: context,
                      text: 'Consult',
                      widthBetween: 4,
                      icon: CupertinoIcons.chat_bubble_2,
                    ),
                    onPressed: () {
                      if (doctor.id != currentUser.id) {
                        Get.to(ChatScreen(
                          receiver: ConsultModel(
                            receiverName: doctor.name,
                            receiverPicture: doctor.picture,
                            receiverPath: doctor.reference?.path,
                            senderPicture: currentUser.picture,
                            senderPath: currentUser.reference?.path,
                            senderName: currentUser.name,
                          ),
                        ));
                      }else{
                        customSnackBar(
                            title: 'This is You !!'
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    context: context,
                    text:offerModel!=null? 'Get Offer': 'Appointment',
                    radius: Sizes.borderRadius(context)['r1'],
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    textSize: Sizes.textSize(context)['h2'],
                    onTap: () async {
                      if (doctor.id != currentUser.id) {
                        await DoctorItem.appointment(context,doctor);
                      }else{
                        customSnackBar(
                            title: 'This is You !!'
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isScroll: true,
  );
}

Future updateRating(UserModel model,double rating) async{
  await FirebaseMethods().updateModel(
    path: model.reference?.path ??'',
    data: {
      'rating':rating,
    }
    );
}

offerDetails(BuildContext context , OfferModel offer){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children:[
        CustomText(
          text: '${offer.title}',
          size: Sizes.textSize(context)['h2'],
          fontWeight: FontWeight.w600,
        ),
        const Divider(),
        CustomText(
          text: '${offer.description}',
          maxLines: 5,
        ),
    ],
  );
}

