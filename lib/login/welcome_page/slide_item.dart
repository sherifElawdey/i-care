import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/login/welcome_page/slider_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/widgets/custom_text.dart';


class SlideItem extends StatelessWidget {
  final int index;
  const SlideItem(this.index, {super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: Sizes.widthScreen(context) * 0.7,
          width: Sizes.heightScreen(context) * 0.4,
          margin: EdgeInsets.only(bottom: Sizes.heightScreen(context)*0.05),
          child: SvgPicture.asset(sliderList[index].sliderImageUrl),
        ),
        CustomText(
          text:sliderList[index].sliderHeading,
          size: Sizes.textSize(context)['h3'],
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15.0),
        Center(
          child: Padding(
            padding:const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderList[index].sliderSubHeading,
              style: customTextStyle(size: 14),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
