import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String imglink;
  final double height;

  ImageBanner({@required this.imglink, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 300.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Image.network(
        this.imglink,
        width: 640,
        height: 480,
      ),
    );
  }
}
