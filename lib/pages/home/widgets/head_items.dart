import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/modules/offerModel.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/doctor/consult_doctor_screen.dart';
import 'package:icare/pages/medicines/medicine_screen.dart';
import 'package:icare/pages/profile/my_appointment_list.dart';
import 'package:icare/pages/profile/my_order_list_screen.dart';
import 'package:icare/pages/reminder_medicine/reminder_screen.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class HeadItemsWidget extends StatelessWidget {
  HeadItemsWidget({Key? key}) : super(key: key);
  var offer = OfferModel();
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  var user = Get.put(UserController()).userData.value;
  File? offerPicture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.heightScreen(context) * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          headItem(
              context,
              Icon(
                CupertinoIcons.calendar_badge_plus,
                size: 25,
                color: whiteColor,
              ),
              'Reminder', () {
            Get.to(ReminderScreen());
          }, backgroundColor: appColor),
          user.administration ==
                  Administration.doctor.name
              ? headItem(
                  context,
                  backgroundColor: appColor,
                  Icon(
                    Icons.local_offer_outlined,
                    size: 25,
                    color: whiteColor,
                  ),
                  'add Offer', () {
                  addOfferWidget(context);
                })
              : headItem(
                  context,
                  SvgPicture.asset(
                    '${ImagePath.icons}medicine.svg',
                    color: Get.isDarkMode ? whiteColor : blackColor,
                    width: 25,
                  ),
                  'Donate', () {
                  Get.to(MedicineScreen());
                }),
          headItem(
              context,
              const Icon(
                CupertinoIcons.time,
                size: 25,
              ),
              'Dates', () {
            Get.to(AppointmentListScreen());
          }),
          headItem(
              context,
              const Icon(
                CupertinoIcons.chat_bubble_2,
                size: 25,
              ),
              'Consult', () {
            Get.to(const ConsultDoctorList());
          }),
        ],
      ),
    );
  }

  Widget headItem(
      BuildContext context, Widget icon, String text, VoidCallback onTap,
      {Color? backgroundColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Theme.of(context).cardColor,
              boxShadow: [customShadow()],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: icon,
          ),
          CustomText(
            text: text,
          ),
        ],
      ),
    );
  }

  addOfferWidget(BuildContext context) {
    customBottomSheet(
      context,
      StatefulBuilder(builder: (context, onState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: formStateKey,
            child: Column(
              children:[
                GestureDetector(
                  onTap: () {
                    getImage().whenComplete(() => onState(() {}));
                  },
                  child: Container(
                    height: Sizes.widthScreen(context) * 0.2,
                    width: Sizes.widthScreen(context) * 0.2,
                    margin: EdgeInsets.only(
                        top: Sizes.heightScreen(context) * 0.05,
                        bottom: Sizes.heightScreen(context) * 0.01),
                    decoration: BoxDecoration(
                      border: Border.all(color: greyColor, width: 2),
                      shape: BoxShape.circle,
                      image: offerPicture == null || offerPicture!.path.isEmpty
                          ? const DecorationImage(
                              image: AssetImage(ImagePath.emptyMedicine),
                              fit: BoxFit.fitWidth)
                          : DecorationImage(
                              image: FileImage(offerPicture ?? File('')),
                            ),
                    ),
                    alignment: Alignment.bottomRight,
                    child: offerPicture == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 25,
                          )
                        : null,
                  ),
                ),
                CustomTextField(
                  context,
                  validator: Validators.instance.validateName(context),
                  labelText: 'Offer title',
                  prefix: const Icon(Icons.local_offer_outlined),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    offer.title = value;
                  },
                ),
                CustomTextField(
                  context,
                  validator: Validators.instance.validateName(context),
                  labelText: 'description',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    offer.description = value;
                  },
                ),
                CustomButton(
                  context: context,
                  text: 'publish',
                  color: checkDone() ? appColor : greyColor,
                  onTap: () async {
                    var data = formStateKey.currentState;
                    if (data != null && data.validate()) {}
                    if (checkDone()) {
                      offer.writer = user.reference;

                      var methods = FirebaseMethods();
                      showLoading(context: context, dismissible: false);
                      await methods
                          .addModelToFirestore(
                        collection: offersCollection,
                        model: offer.toJson(),
                      )
                          .then((id) async {
                        await methods
                            .uploadFile(
                          '$offersCollection/${user.id}/$id',
                          offerPicture!,
                        )
                            .then((value) async {
                          await methods.updateModel(
                            path: '$offersCollection/$id',
                            data: {'picture': value},
                          ).whenComplete(() {
                            Get.back(closeOverlays: true);
                            customSnackBar(
                                title: 'Offer added to successfully',
                                position: SnackPosition.BOTTOM);
                          });
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool checkDone() {
    if (offer.title != null || offer.picture != null || offer.writer != null) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {
    customDialog(
        title: '${offerPicture != null ? 'Change' : 'Select'} Medicine picture',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextButton(
                text: 'Choose from gallery',
                onTap: () async {
                  var image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    offerPicture = File(image.path);
                    Get.back();
                  }
                }),
            CustomTextButton(
              text: 'Take from camera',
              onTap: () async {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  offerPicture = File(image.path);
                }
                Get.back();
              },
            )
          ],
        ));
  }
}
