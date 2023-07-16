import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/tile_item_model.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/doctor/consult_doctor_screen.dart';
import 'package:icare/pages/profile/account_details_screen.dart';
import 'package:icare/pages/profile/doctor_request_list_screen.dart';
import 'package:icare/pages/profile/donate_requests_screen.dart';
import 'package:icare/pages/profile/my_appointment_list.dart';
import 'package:icare/pages/profile/my_order_list_screen.dart';
import 'package:icare/pages/profile/profile_widgets.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/items/tile_item.dart';

class ProfileScreen extends StatelessWidget{
  ProfileScreen({Key? key}) : super(key: key);
  UserModel user =Get.put(UserController()).userData.value;
  File? profilePic;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            appColor.withOpacity(0.2),
            Colors.transparent,
            appColor.withOpacity(0.1),
            appColor.withOpacity(0.3),
            appColor.withOpacity(0.6),
          ],
        )
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: Sizes.heightScreen(context)*0.05),
        children:[
          Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              GestureDetector(
                onTap: (){
                  if(user.picture!=null){
                    expandProfileImage(user.picture??'');
                  }
                },
                child: Container(
                  height: Sizes.widthScreen(context)*0.35,
                  width:  Sizes.widthScreen(context)*0.35,
                  margin: EdgeInsets.only(
                      top: Sizes.heightScreen(context)*0.05,
                      bottom: Sizes.heightScreen(context)*0.01
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: appColor,width: 3),
                    shape: BoxShape.circle,
                    image:(profilePic==null||profilePic!.path.isEmpty) && user.picture!=null
                        ? DecorationImage(
                        image: NetworkImage(user.picture??''),
                      fit: BoxFit.cover
                    )
                        : user.picture==null
                        ? const DecorationImage(
                      image: AssetImage(
                        ImagePath.emptyProfile,
                      ),
                      fit: BoxFit.cover
                    )
                    : DecorationImage(
                      image: FileImage(profilePic?? File('')),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              tileItem(context, TileItemModel(
                value: 'Account Details',
                leadingIcon: Icons.manage_accounts,
                onTap: (){
                  Get.to(AccountDetailsScreen());
                }
              ),),
              tileItem(context, TileItemModel(
                value: 'My Orders',
                leading: SvgPicture.asset('${ImagePath.icons}medicine.svg',
                    height: 22,
                  color: Get.isDarkMode?whiteColor:blackColor,

                ),
                onTap: (){
                  Get.to(OrderListScreen());
                }
              ),),
              tileItem(context, TileItemModel(
                value: 'Appointment History',
                leadingIcon: Icons.history,
                onTap: (){
                  Get.to(AppointmentListScreen());
                }
              ),),
              tileItem(context, TileItemModel(
                  value: 'Consultation history',
                  leadingIcon: CupertinoIcons.chat_bubble_2,
                  onTap: (){
                    Get.to(const ConsultDoctorList());
                  }
              ),),
              if(user.administration==Administration.pharmacy.name)
                tileItem(context, TileItemModel(
                  value: 'Donate requests',
                  leadingIcon: Icons.request_quote_outlined,
                  onTap: (){
                    Get.to(DonateRequestsScreen());
                  }
              ),),
              if(user.administration==Administration.admin.name)
                tileItem(context, TileItemModel(
                    value: 'Doctor requests',
                    leadingIcon: Icons.request_quote_outlined,
                    onTap: (){
                      Get.to(DoctorRequestsScreen());
                    }
                ),),
              const SwitchThemeWidget(),
              tileItem(context, TileItemModel(
                  value: 'Sign Out',
                  leadingIcon: CupertinoIcons.square_arrow_left,
                  color: errorColor,
                  onTap: (){
                    FirebaseMethods().signOut(context);
                  }
              ),),
            ],
          ),
        ],
      )
    );
  }
}
