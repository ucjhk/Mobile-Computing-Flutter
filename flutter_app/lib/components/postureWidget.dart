import 'package:flutter/material.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostureWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posture = ref.watch(postureProvider);
    return GestureDetector(
      onTap: posture.toggleImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(posture.isGoodPosture ? ImagePaths.goodPosture : ImagePaths.badPosture),
          ),
        ),
      ),
    );
  }
}