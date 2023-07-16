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
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/profile/my_appointment_list.dart';
import 'package:icare/pages/scanner/qr_scanner.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppointmentItem extends StatelessWidget {
  AppointmentModel appointment;

  AppointmentItem({Key? key, required this.appointment}) : super(key: key);
  var currentUser = Get.put(UserController()).userData.value;

  bool isDoctor() => currentUser.administration == Administration.doctor.name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          appointmentDetails(context);
        },
        child: Row(
          children: [
            isDoctor()
                ? IconButton(
                    icon: Icon(Icons.qr_code_scanner,color: appColor,),
                    onPressed: () {
                      scanQrCode();
                    },
                  )
                : QrImage(
                    data: appointment.id ?? '',
                    size: 120,
                    backgroundColor: whiteColor,
                  ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: isDoctor()
                        ? appointment.patientName.toString()
                        : 'Dr:${appointment.doctorName}',
                    size: Sizes.textSize(context)['h2'],
                  ),
                  const Divider(
                    endIndent: 30,
                  ),
                  CustomTextIcon(
                    context: context,
                    text: ' date : ${appointment.appointmentDate ?? 'date'}',
                    icon: Icons.access_time,
                  ),
                  CustomText(
                    text:
                        'Payed ? ${appointment.payed == true.toString() ? 'Yes' : 'No'}',
                    color: appointment.payed == true.toString()
                        ? Colors.green
                        : errorColor,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                deleteItem(context);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: errorColor,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteItem(BuildContext context) {
    customDialog(
        title: 'Delete Item',
        contentText: 'Do you want delete this item',
        okText: 'yes',
        cancelText: 'Cancel',
        okTap: () async {
          if (isDoctor()) {
            await FirebaseMethods()
                .removeModel(
                    '${currentUser.reference?.path}/$appointmentsCollection/${appointment.id}')
                .whenComplete(() {
              Get.back();
              goToPageReplace(
                  context,
                  AppointmentListScreen());
              customSnackBar(
                  title: 'this appointment was deleted successfully');
            });
          } else {
            await DataBaseSql()
                .deleteItem(sqlAppointmentTable, appointment.id ?? '')
                .whenComplete(() {
              Get.back();
              goToPageReplace(
                  context,
                  AppointmentListScreen());
              customSnackBar(
                  title: 'this appointment was deleted successfully');
            });
          }
        });
  }

  appointmentDetails(BuildContext context) {
    customBottomSheet(
      context,
      FutureBuilder<Map<String, dynamic>>(
          future: getAppointmentDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              var user = UserModel.fromJson(snapshot.data ?? {});
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.heightScreen(context) * 0.03),
                    child: IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 40,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: Sizes.paddingTextFieldHorizontal(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isDoctor()
                                ? CustomButton(
                                    context: context,
                                    text: 'Scan Qr Code',
                                    leading: Icons.qr_code_scanner,
                                    onTap: () {
                                      scanQrCode();
                                    },
                                  )
                                : QrImage(
                                      data: appointment.id.toString(),
                                      backgroundColor: whiteColor,
                                      size: 200,
                                    ),
                            ],
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              expandProfileImage(user.picture ?? '');
                            },
                            child: ClipRRect(
                              borderRadius: Sizes.borderRadius(context)['r5'],
                              child: Image.network(
                                user.picture ?? '',
                                height: Sizes.widthScreen(context) * 0.3,
                                width: Sizes.widthScreen(context) * 0.3,
                                errorBuilder: (context, error, stackTrace) => Image.asset(ImagePath.emptyProfile,height: 100),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomText(
                            text: 'Dr: ${user.name}',
                            size: Sizes.textSize(context)['h2'],
                            fontWeight: FontWeight.w600,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: '>>  Address :',
                            size: Sizes.textSize(context)['h2'],
                            color: appColor,
                          ),
                          CustomText(
                            text: '${user.address}',
                            size: Sizes.textSize(context)['h2'],
                            maxLines: 3,
                          ),
                          if (isDoctor())
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: '>> Title : ${user.title}',
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomText(
                                  text:
                                      '>> specialization : ${user.specialization}',
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text:
                                          '>> Price : ${user.disclosurePrice}',
                                      size: Sizes.textSize(context)['h2'],
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    CustomTextIcon(
                                      context: context,
                                      text: '(${user.rating ?? '0.0'})',
                                      iconSize: 18,
                                      icon: CupertinoIcons.star_lefthalf_fill,
                                      iconColor: Colors.yellow.shade800,
                                      widthBetween: 4,
                                    ),
                                  ],
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
                                  text: '${user.daysOfWork}',
                                  size: Sizes.textSize(context)['h2'],
                                  maxLines: 3,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomText(
                                  text:
                                      '>>  Times of work : ${user.timesOfWork}',
                                  size: Sizes.textSize(context)['h2'],
                                  color: appColor,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: CustomText(
                  text: 'Something Error ,${snapshot.error}Please try again',
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: CustomText(
                  text: 'No Data Yet',
                ),
              );
            }
          }),
      isScroll: true,
    );
  }

  Future<Map<String, dynamic>> getAppointmentDetails() async {
    var user = Get.put(UserController()).userData.value;
    return await FirebaseMethods().getModelFromFirestore(
      appointment.doctorId == user.id ? userCollection : doctorsCollection,
      appointment.doctorId == user.id
         ? appointment.patientId.toString()
         : appointment.doctorId.toString(),
    );
  }

  void scanQrCode() {
    Get.to(QrScanner(list:[appointment],screen: appointmentsCollection,));
  }
}
