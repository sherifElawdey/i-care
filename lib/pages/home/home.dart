import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/pages/doctor/doctors_screen.dart';
import 'package:icare/pages/home/home_screen.dart';
import 'package:icare/pages/medicines/medicine_screen.dart';
import 'package:icare/pages/profile/profile_screen.dart';
import 'package:icare/widgets/custom_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox(
          height: Sizes.heightScreen(context),
          child:_currentPage==0
              ? HomeScreen()
              :_currentPage==1
              ? MedicineScreen()
              :_currentPage==2
              ? DoctorsScreen()
              : ProfileScreen()
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          fixedColor: appColor,
          currentIndex: _currentPage,
          onTap: (int index){
            setState(() {
              _currentPage=index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              backgroundColor: Theme.of(context).cardColor,
              icon:Padding(
                padding:const EdgeInsets.all(5),
                child: Icon(Icons.home_max_outlined,
                  color: Get.isDarkMode?whiteColor:blackColor,
                ),
              ),
              activeIcon: Container(
                  padding:const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius:Sizes.borderRadius(context)['r2']
                  ),
                  child: Icon(Icons.home_max_outlined,color: whiteColor,)
              ),
            ),
            BottomNavigationBarItem(
              label: 'medicines',
              backgroundColor: Theme.of(context).cardColor,
              icon: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/icons/medicine.svg',
                  height: 20,
                  width: 20,
                  color: Get.isDarkMode?whiteColor:blackColor,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: SvgPicture.asset(
                  'assets/images/icons/medicine.svg',
                  height: 20,
                  width: 20,
                  color: whiteColor,
                  allowDrawingOutsideViewBox: true,
                ),),
            ),
            BottomNavigationBarItem(
              label: 'doctors',
              backgroundColor:Theme.of(context).cardColor,
              icon: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/icons/doctor.svg',
                  height: 20,
                  width: 20,
                  color: Get.isDarkMode?whiteColor:blackColor,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: SvgPicture.asset(
                  'assets/images/icons/doctor.svg',
                  height: 20,
                  width: 20,
                  color: whiteColor,
                  allowDrawingOutsideViewBox: true,
                ),),
            ),
            BottomNavigationBarItem(
              label: 'profile',
              backgroundColor: Theme.of(context).cardColor,
              icon: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/icons/ic_profile.svg',
                  height: 20,
                  width: 20,
                  color: Get.isDarkMode?whiteColor:blackColor,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: SvgPicture.asset(
                  'assets/images/icons/ic_profile2.svg',
                  height: 20,
                  width: 20,
                  allowDrawingOutsideViewBox: true,
                ),),
            ),
          ]
      ),
    );
  }
}
