import 'package:flutter/material.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///------------------------------------------------------------------------///
/// Posture Widget that display the current posture based on the provider
///------------------------------------------------------------------------///

class PostureWidget extends ConsumerWidget {

  const PostureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posture = ref.watch(postureProvider);
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(posture.isGoodPosture ? ImagePaths.goodPosture : ImagePaths.badPosture),
        ),
      ),
    );
  }
}