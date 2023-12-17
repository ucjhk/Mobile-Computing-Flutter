import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';

class PostureWidget extends StatefulWidget {
  const PostureWidget({Key? key}) : super(key: key);

  @override
  _PostureWidgetState createState() => _PostureWidgetState();
}

class _PostureWidgetState extends State<PostureWidget> {
  String imagePath = goodPosture;

  void toggleImage() {
    setState(() {
      imagePath = imagePath == goodPosture ? badPosture : goodPosture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}