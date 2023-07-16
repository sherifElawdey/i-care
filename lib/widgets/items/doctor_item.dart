import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/appointment_model.dart';
import 'package:icare/modules/message.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/doctor/consultation_chat_screen.dart';
import 'package:icare/pages/profile/my_order_list_screen.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/user_details.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoctorItem extends StatelessWidget {
  UserModel doctor;

  DoctorItem({Key? key, required this.doctor}) : super(key: key);
  var currentUser = Get.put(UserController()).userData.value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Sizes.borderRadius(context)['r1'],
        color: Theme.of(context).cardColor,
        boxShadow: [customShadow()],
      ),
      margin: const EdgeInsets.all(8),
      height: 200,
      child: GestureDetector(
        onTap: () {
          getDoctorDetails(context, doctor);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: Sizes.borderRadius(context)['r1'],
                    child: Image.network(
                      doctor.picture ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(ImagePath.emptyProfile);
                      },
                      width: 120,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Dr: ${doctor.name ?? 'doctor name'}',
                          size: Sizes.textSize(context)['h2'],
                        ),
                        CustomText(
                          text: 'title : ${doctor.title ?? 'Title'}',
                        ),
                        CustomText(
                          text:
                              'specialization : ${doctor.specialization ?? specialization.first}',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomTextIcon(
                              context: context,
                              text: '${doctor.disclosurePrice ?? '00.00'} EGP',
                              iconSize: 18,
                              icon: Icons.attach_money,
                            ),
                            CustomTextIcon(
                              context: context,
                              text: '(${doctor.rating ?? '0.0'})',
                              iconSize: 18,
                              icon: CupertinoIcons.star_lefthalf_fill,
                              iconColor: Colors.yellow.shade800,
                              widthBetween: 4,
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
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
                        } else {
                          customSnackBar(title: 'This is You !!');
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      context: context,
                      text: 'Appointment',
                      radius: Sizes.borderRadius(context)['r1'],
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      textSize: Sizes.textSize(context)['h2'],
                      onTap: () async {
                        if (doctor.id != currentUser.id) {
                          await appointment(context, doctor);
                        } else {
                          customSnackBar(title: 'This is You !!');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future appointment(BuildContext context, UserModel doctor,{String? offer}) async {
    showLoading(context: context, dismissible: false);
    var currentUser = Get.put(UserController()).userData.value;

    var appointment = AppointmentModel(
      appointmentDate: DateFormat.Md().add_jm().format(DateTime.now()).toString(),
      doctorId: doctor.id,
      doctorName: doctor.name,
      patientName: currentUser.name,
      appointmentState: AppointmentState.waiting.name,
      payed: false.toString(),
      offer: offer,
      patientId: currentUser.id,
    ).toJson();
    await FirebaseMethods()
        .addModelToFirestore(
            collection:
                '$doctorsCollection/${doctor.id}/$appointmentsCollection',
            model: appointment)
        .then((value) async {
      /// add order to my order table in sql

      appointment['id']=value;
      await DataBaseSql()
          .addItem(appointmentsCollection, appointment)
          .whenComplete((){
            Get.back();
            customBottomSheet(
              context,
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomText(
                        text: 'Your Appointment is Done',
                        size: Sizes.textSize(context)['h3'],
                        fontWeight: FontWeight.w600,
                        color: appColor,
                      ),
                      QrImage(
                        data: value,
                        backgroundColor: whiteColor,
                        size: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        text: 'Go To My Appointments List',
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(OrderListScreen());
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
      });
    });
  }
}
