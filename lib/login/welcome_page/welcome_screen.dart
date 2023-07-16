import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/paths/strings.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/login/login_screen.dart';
import 'package:icare/login/welcome_page/slide_item.dart';
import 'package:icare/login/welcome_page/slider_data.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/page_view_dots.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  _nextButton() {
    if (_currentPage == sliderList.length-1) {
      goToPageReplace(context, const LogInPage());
    } else if (_currentPage < sliderList.length) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: sliderList.length,
              itemBuilder: (ctx, i) => SlideItem(i),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          goToPageReplace(context, const LogInPage());
                        },
                        child: Text(
                          Strings.skip,
                          style: customTextStyle(size: 15),
                        ),
                      ),
                      pageViewDots(currentPage: _currentPage, length: sliderList.length),
                      TextButton(
                        onPressed: _nextButton,
                        child: CustomText(
                          text:
                              _currentPage == sliderList.length-1 ? Strings.start : Strings.next,
                          fontWeight: FontWeight.w500,
                          size: Sizes.textSize(context)['h2'],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
}
