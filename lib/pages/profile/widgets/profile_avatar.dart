import 'package:flutter/material.dart';

import '../../../style/style.dart';

class ProfileAvatarItem extends StatelessWidget {
  const ProfileAvatarItem({Key? key, required this.url, this.color})
      : super(key: key);

  final String? url;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          CircleAvatar(
              radius: 36,
              backgroundColor: color ?? Palette.primaryColor,
              child: url == null
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    )
                  : Image.network(
                      '$url',
                      fit: BoxFit.cover,
                    )),
          // Positioned(
          //     bottom: 0,
          //     right: 0,
          //     child: CircleAvatar(
          //         backgroundColor: color ?? Palette.primaryColor,
          //         radius: 15,
          //         child: TextButton(
          //             style: ButtonStyle(
          //                 padding: MaterialStateProperty.all(EdgeInsets.zero)),
          //             onPressed: () {},
          //             child: Icon(
          //               Icons.edit,
          //               color: Colors.white,
          //             ))))
        ],
      ),
    );
  }
}
