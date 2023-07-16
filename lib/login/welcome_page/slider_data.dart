import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/paths/strings.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {required this.sliderImageUrl,
        required this.sliderHeading,
        required this.sliderSubHeading});
}


final sliderList = [
  Slider(
      sliderImageUrl: '${ImagePath.boarding}doctor.svg',
      sliderHeading: Strings.sliderHeading1,
      sliderSubHeading: Strings.sliderDesc1),
  Slider(
      sliderImageUrl: '${ImagePath.boarding}pharmacy.svg',
      sliderHeading: Strings.sliderHeading3,
      sliderSubHeading: Strings.sliderDesc3),
  Slider(
      sliderImageUrl: '${ImagePath.boarding}medicine_remember.svg',
      sliderHeading: Strings.sliderHeading2,
      sliderSubHeading: Strings.sliderDesc2),

];
