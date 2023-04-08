import 'package:flutter/material.dart';

class Unknown404View extends StatelessWidget {
  const Unknown404View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: getPrimaryColor,
      body: Center(
        child: Text(
          '404',
          // style: TextThemeX.text56.copyWith(
          //   color: getColor21,
          // ),
        ),
      ),
    );
  }
}
