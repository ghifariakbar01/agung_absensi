import 'package:face_net_authentication/constants/assets.dart';
import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader({this.onBackPressed});
  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBackPressed,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              height: 50,
              width: 50,
              child: Center(
                  child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
            ),
          ),
          SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(Assets.iconLogo),
              )),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
