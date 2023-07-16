import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/items/doctor_item.dart';
import 'package:icare/widgets/text_field.dart';

class DoctorsScreen extends StatefulWidget {
  DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Map<String,dynamic>?> doctorList = [];
  List<Map<String,dynamic>?> doctorListFiltered = [];

  FirebaseMethods methods =FirebaseMethods();

  List doctorSearchList =[];

  Map<String,String> filtered={};

  bool showFilter=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            StatefulBuilder(
              builder: (context,onState) {
                return SliverAppBar(
                  floating: true,
                  snap: true,
                  title: CustomText(
                    text: 'Find Your Doctor',
                    size: Sizes.textSize(context)['h3'],
                    fontWeight: FontWeight.w500,
                    color: whiteColor,
                  ),
                  titleSpacing: 0,
                  expandedHeight:showFilter?Sizes.heightScreen(context) * 0.3: Sizes.heightScreen(context) * 0.2,
                  flexibleSpace: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        bottom:showFilter?Sizes.heightScreen(context) * 0.06 : Sizes.heightScreen(context) * 0.04,
                        top:0,
                        right:0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:const BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
                            color: appColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            context,
                            suffixIcon:const Icon(Icons.search),
                            hintText: 'search',
                            maxLines: 1,
                            onChanged: (value){
                              setState(() {
                                if(value.isEmpty||value==''){
                                  doctorListFiltered= doctorList;
                                }
                                doctorListFiltered=doctorListFiltered
                                    .where((element) =>
                                    element!['name'].toString().toUpperCase().contains(value.toUpperCase())).toList();
                              });
                            },
                            textInputAction: TextInputAction.search,
                            backgroundColor:Get.isDarkMode?Theme.of(context).cardColor: whiteColor,                            underFieldWidget:showFilter? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomText(
                                  text:'filter : ',
                                ),
                                PopupMenuButton(
                                  initialValue: filtered['specialization'] ?? specialization.first,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: Sizes.borderRadius(context)['r2']!),
                                  onSelected: (nValue) {
                                    onState((){
                                      filtered['specialization'] = nValue.toString();
                                    });
                                  },
                                  position: PopupMenuPosition.under,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: Sizes.paddingScreenHorizontal(context),
                                    decoration: BoxDecoration(
                                      borderRadius: Sizes.borderRadius(context)['r1'],
                                      border: Border.all(color: appColor),
                                    ),
                                    child: CustomTextIcon(
                                      context: context,
                                      icon: Icons.keyboard_arrow_down,
                                      iconColor: appColor,
                                      textColor: appColor,
                                      text: filtered['specialization'] ?? 'Specialization',
                                    ),
                                  ),
                                  itemBuilder: (context) => List.generate(
                                    specialization.length,
                                        (index) => PopupMenuItem(
                                      value: specialization[index],
                                      child: CustomText(
                                        text: specialization[index],
                                      ),
                                    ),
                                  ),
                                ),
                                CustomButton(text: 'Get', context: context,
                                  onTap: (){
                                    setState(() {
                                      doctorListFiltered= doctorList
                                          .where((element) => element!['specialization']==filtered['specialization']).toList();
                                      showFilter=false;
                                    });
                                  },
                                ),
                              ],
                            ):null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions:[
                    IconButton(
                      onPressed: (){
                        onState((){
                          if(showFilter){
                            showFilter=false;
                          }else{
                            showFilter=true;
                          }
                        });
                      },
                      icon:Icon(
                        Icons.filter_alt_outlined,
                        color: whiteColor,
                      ),
                    )
                  ],
                  leading: CustomBackButton(context,color: whiteColor,),
                );
              }
            ),
          ],
          body: FutureBuilder(
              future:doctorList.isEmpty && (filtered['specialization']==null||filtered['specialization']!.isEmpty)
                  ? getAllDoctors()
                  : null,
              builder: (context,snapshot) {
                if((snapshot.hasData && snapshot.data!.isNotEmpty)||doctorList.isNotEmpty){
                  return CustomScrollView(
                    cacheExtent: 2,
                    slivers:[
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate((context,index){
                            var doctor= UserModel.fromJson(doctorListFiltered[index]??{});
                            return DoctorItem(doctor: doctor);
                          },
                          childCount: doctorListFiltered.length
                        ),
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.1
                        ),
                      ),
                    ],
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: CustomText(text: 'Something Error',),
                  );
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }else{
                  return Center(
                    child: CustomText(text: 'No Doctors Yet',),
                  );
                }
              }
          ),
      ),
    );
  }

  Future getAllDoctors()async{
    doctorList= await FirebaseMethods().getListFromFirestore(doctorsCollection,
      whereField: 'verified',
      conditionEqual: true
    );
    doctorListFiltered=doctorList;
    return doctorList;
  }

}
