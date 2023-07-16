import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/helper/validators.dart';
import 'package:icare/modules/medicine.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/buttons.dart';
import 'package:icare/widgets/custom_images.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/dialog.dart';
import 'package:icare/widgets/items/medicine_item.dart';
import 'package:icare/widgets/loading.dart';
import 'package:icare/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class MedicineScreen extends StatefulWidget {
  MedicineScreen({Key? key}) : super(key: key);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  List<Map<String, dynamic>?> medicinesList = [];
  List<Map<String, dynamic>?> medicinesListFiltered = [];

  final _pharmacyController = TextEditingController();

  FirebaseMethods methods = FirebaseMethods();

  List pharmacySearchList = [];

  MedicineModel medicineModel = MedicineModel();

  File? medicinePicture;

  UserModel? selectedPharmacy;

  Map<String, String> filtered = {};

  bool showFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          StatefulBuilder(builder: (context, onState) {
            return SliverAppBar(
              floating: true,
              snap: true,
              title: CustomText(
                text: 'Find Your Medicine',
                size: Sizes.textSize(context)['h3'],
                fontWeight: FontWeight.w500,
                color: whiteColor,
              ),
              titleSpacing: 0,
              expandedHeight: showFilter
                  ? Sizes.heightScreen(context) * 0.3
                  : Sizes.heightScreen(context) * 0.2,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    bottom: showFilter
                        ? Sizes.heightScreen(context) * 0.06
                        : Sizes.heightScreen(context) * 0.04,
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50)),
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
                        suffixIcon: const Icon(Icons.search),
                        hintText: 'search',
                        maxLines: 1,
                        onChanged: (value){
                          setState(() {
                            if(value.isEmpty||value==''){
                              medicinesListFiltered =medicinesList;
                            }
                            medicinesListFiltered=medicinesListFiltered
                                .where((element) =>
                                element!['name'].toString().toUpperCase().contains(value.toUpperCase())).toList();
                          });
                        },
                        textInputAction: TextInputAction.search,
                        backgroundColor: Get.isDarkMode
                            ? Theme.of(context).cardColor
                            : whiteColor,
                        underFieldWidget: showFilter
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomText(
                                    text: 'filter : ',
                                  ),
                                  PopupMenuButton(
                                    initialValue: filtered['price'] ??
                                        Prices.price.name,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: Sizes.borderRadius(
                                            context)['r2']!),
                                    onSelected: (nValue) {
                                      onState(() {
                                        filtered['price'] = nValue.toString();
                                      });
                                    },
                                    position: PopupMenuPosition.under,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      margin:
                                          Sizes.paddingScreenHorizontal(
                                              context),
                                      decoration: BoxDecoration(
                                        borderRadius: Sizes.borderRadius(
                                            context)['r1'],
                                        border:
                                            Border.all(color: appColor),
                                      ),
                                      child: CustomTextIcon(
                                        context: context,
                                        icon: Icons.keyboard_arrow_down,
                                        iconColor: appColor,
                                        textColor: appColor,
                                        text:
                                            filtered['price'] ?? 'price',
                                      ),
                                    ),
                                    itemBuilder: (context) =>
                                        List.generate(
                                      Prices.values.length,
                                      (index) => PopupMenuItem(
                                        value: Prices.values[index].name,
                                        child: CustomText(
                                          text: Prices.values[index].name,
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomButton(
                                      text: 'Get', context: context,
                                    onTap: (){
                                        setState(() {
                                          if(filtered['price']==Prices.free.name){
                                            medicinesListFiltered= medicinesList
                                                .where((element) => element!['price']==Prices.free.name).toList();
                                          }else{
                                            medicinesListFiltered= medicinesList
                                                .where((element) => element!['price']!=Prices.free.name).toList();
                                          }
                                          showFilter=false;
                                        });
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    onState(() {
                      if (showFilter) {
                        showFilter = false;
                      } else {
                        showFilter = true;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: whiteColor,
                  ),
                )
              ],
              leading: CustomBackButton(
                context,
                color: whiteColor,
              ),
            );
          }),
        ],
        body: FutureBuilder(
              future: medicinesList.isEmpty && (filtered['price']==null||filtered['price']!.isEmpty)
                  ? getAllMedicines()
                  : null,
              builder: (context, snapshot) {
                if((snapshot.hasData && snapshot.data!.isNotEmpty)
                    ||medicinesList.isNotEmpty){
                  return CustomScrollView(
                    slivers: [
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                              var medicine =MedicineModel.fromJson(medicinesListFiltered[index]??{});
                              return MedicineItem(medicine: medicine);
                            },
                            childCount: medicinesListFiltered.length),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.5),
                      ),
                    ],
                  );
                }else if(medicinesList.isEmpty){
                  return Center(child:  CustomText(text: 'No Medicine Yet',),);
                }else{
                 return const Center(child: CircularProgressIndicator(),);
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        onPressed: () => addMedicineWidget(context),
        child: Icon(Icons.add,color: Theme.of(context).textTheme.bodyMedium!.color,),
      ),
    );
  }

  Future<List> getAllMedicines() async {
    medicinesList= await FirebaseMethods().getListFromFirestore(medicinesCollection);
    medicinesListFiltered=medicinesList;
    return medicinesList;
  }

  addMedicineWidget(BuildContext context) {
    customBottomSheet(
      context,
      StatefulBuilder(builder: (context, onState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              GestureDetector(
                onTap:(){
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
                    image:
                        medicinePicture == null || medicinePicture!.path.isEmpty
                            ? const DecorationImage(
                                image: AssetImage(ImagePath.emptyMedicine),
                                fit: BoxFit.fitWidth)
                            : DecorationImage(
                                image: FileImage(medicinePicture ?? File('')),
                              ),
                  ),
                  alignment: Alignment.bottomRight,
                  child: medicinePicture == null
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
                labelText: Strings.medicineName,
                prefix: const Icon(Icons.medical_services_outlined),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  medicineModel.name = value;
                },
              ),
              Row(
                children:[
                  Expanded(
                    child: CustomTextField(
                      context,
                      validator: Validators.instance.validateName(context),
                      labelText: 'Amount',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        medicineModel.amount = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      context,
                      validator: Validators.instance.validateName(context),
                      labelText: 'Price',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        medicineModel.amount = value;
                      },
                    ),
                  ),
                ],
              ),
              addPharmacyField(),
              CustomButton(
                context: context,
                text: 'Donate',
                color: checkDone()?appColor:greyColor,
                onTap: () async{
                  if(checkDone()){
                    medicineModel.donorName=Get.put(UserController()).userData.value.name;
                    medicineModel.amount ??= '1';
                    var methods =FirebaseMethods();
                    showLoading(context: context, dismissible: false);
                    await methods.addModelToFirestore(
                        collection: '$pharmacyCollection/${selectedPharmacy?.id}/$requestsCollection',
                        model: medicineModel.toJson()
                    ).then((id)async{
                      await methods.uploadFile(
                        '$medicinesCollection/${selectedPharmacy?.id}/$id',
                        medicinePicture!,
                      ).then((value) async{
                        await methods.updateModel(
                          path: '$pharmacyCollection/${selectedPharmacy?.id}/$requestsCollection/$id',
                          data:{'picture':value},
                        ).whenComplete((){
                          Get.back(closeOverlays: true);
                          customSnackBar(
                            title: 'Medicine added to pharmacy requests successfully',
                            position: SnackPosition.BOTTOM
                          );
                        });
                      });
                    });
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Future getImage() async {
    customDialog(
        title:
            '${medicinePicture != null ? 'Change' : 'Select'} Medicine picture',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextButton(
                text: 'Choose from gallery',
                onTap: () async {
                  var image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    medicinePicture = File(image.path);
                    Get.back();
                  }
                }),
            CustomTextButton(
              text: 'Take from camera',
              onTap: () async {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  medicinePicture = File(image.path);
                }
                Get.back();
              },
            )
          ],
        ));
  }

  addPharmacyField() {
    return StatefulBuilder(builder: (context, onState) {
      return Column(
        children: [
          CustomTextField(
            context,
            hintText: 'Add Pharmacy',
            prefix: const Icon(CupertinoIcons.person_3),
            controller: _pharmacyController,
            textInputAction: TextInputAction.done,
            suffixIcon: const Icon(Icons.search),
            onChanged: (value) async {
              if (value.isEmpty) {
                pharmacySearchList.clear();
              } else {
                await getPharmacyList(value);
              }
              onState(() {});
            },
            underFieldWidget: Container(
              height: pharmacySearchList.isNotEmpty
                  ? Sizes.heightScreen(context) * 0.2
                  : 0,
              decoration: BoxDecoration(
                  border: Border.all(color: appColor),
                  borderRadius: Sizes.borderRadius(context)['r2']),
              child: ListView.builder(
                itemCount: pharmacySearchList.length,
                itemBuilder: ((context, index) {
                  UserModel pharmacy = pharmacySearchList[index];
                  return ListTile(
                    title: CustomText(
                      text: pharmacy.name.toString(),
                    ),
                    leading: profilePicture(pharmacy.picture.toString(), 40),
                    trailing: CustomText(
                      text: pharmacy.address!.split(',')[1].toString(),
                      size: Sizes.textSize(context)['h1'],
                    ),
                    onTap: () {
                      selectedPharmacy = pharmacy;
                      medicineModel.pharmacyId =
                          '${pharmacy.id},${pharmacy.name}';
                      pharmacySearchList.clear();
                      onState(() {});
                    },
                  );
                }),
              ),
            ),
          ),
          ListTile(
            title: CustomText(
              text: selectedPharmacy?.name.toString()?? '',
            ),
            leading: profilePicture(selectedPharmacy?.picture.toString()??'', 40),
            trailing: CustomText(
              text: selectedPharmacy?.address!.split(',')[1].toString()??'',
              size: Sizes.textSize(context)['h1'],
            ),
            onTap: () {
              customDialog(
                title: 'Do you want delete this item',
                okTap: (){
                  selectedPharmacy=null;
                  onState((){});
                }
              );
            },
          )
        ],
      );
    });
  }

  getPharmacyList(String name) async {
    pharmacySearchList = (await methods.getListFromFirestore(pharmacyCollection,
            whereField: 'name', conditionContains: name.toUpperCase()))
        .map((e) => UserModel.fromJson(e!))
        .where((user) =>
            user.administration == Administration.doctor.name ||
            user.administration == Administration.pharmacy.name)
        .toList();
  }

  bool checkDone() {
    if(medicineModel.name!=null || medicinePicture!=null ||selectedPharmacy!=null){
      medicineModel.amount ??= 1.toString();
      medicineModel.price ??=Prices.free.name;
      return true;
    }else{
      return false;
    }
  }
}
