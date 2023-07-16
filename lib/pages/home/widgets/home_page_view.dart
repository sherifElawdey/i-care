import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/offerModel.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/page_view_dots.dart';
import 'package:icare/widgets/user_details.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({Key? key}) : super(key: key);

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final PageController _pageController = PageController();
  List<Map<String,dynamic>?>? offerList;
  int _currentPage = 0;

  @override
  void initState(){
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < (offerList?.length ?? 1) - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if(_pageController.hasClients){
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInCubic,
        );
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: Sizes.heightScreen(context) * 0.25,
        width: Sizes.widthScreen(context)-Sizes.widthScreen(context)*0.07,
        child: FutureBuilder<List<Map<String, dynamic>?>?>(
          future:offerList==null
              ? getOffers()
              : null,
          builder: (context,snapshot) {
            if(snapshot.hasData && snapshot.data!=null ){
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        controller: _pageController,
                        pageSnapping: true,
                        onPageChanged: (pos) {
                          setState(() {
                            _currentPage = pos;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          OfferModel offer =OfferModel.fromJson(snapshot.data![index]!);
                          return GestureDetector(
                              onTap: () async{
                                await getOfferDetails(context, offer);
                              },
                              child: Container(
                                margin:const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: Sizes.borderRadius(context)['r3'],
                                    image: DecorationImage(
                                      image: NetworkImage('${offer.picture}'),
                                      fit: BoxFit.fill,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black26.withOpacity(0.2), BlendMode.darken),
                                    )),
                                alignment: Alignment.center,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: Sizes.paddingScreenHorizontal(context),
                                    child: CustomText(
                                      text: '${offer.title}',
                                      color: Colors.white,
                                      size: Sizes.textSize(context)['h2'],
                                      fontWeight: FontWeight.w600,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ));
                        }),
                  ),
                  if(snapshot.data!.isNotEmpty)
                    pageViewDots(currentPage: _currentPage, length:offerList?.length ?? 0),
                ],
              );
            }else if(snapshot.hasError){
              return Center(child: CustomText(text: 'Something Error',),);
            }else{
              return Container(
                margin:const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: Sizes.borderRadius(context)['r3'],
                  color: greyColor.withOpacity(0.7),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Loading..',
                ),
              );
            }

          }
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>?>?> getOffers()async{
   offerList= await FirebaseMethods().getListFromFirestore(offersCollection,limit: 5);

   return offerList;
  }
  getOfferDetails(BuildContext context,OfferModel offerModel)async{
     await FirebaseMethods().getUserFromReference(offerModel.writer!).then((writer) {
      getDoctorDetails(context, writer,offerModel: offerModel);
    });
  }
}
