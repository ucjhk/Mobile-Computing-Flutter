const String _objectsPath = 'images/objects';
const String _backgroundPath = 'images/background';
const String _imagePath = 'images';

class ImagePaths {
  static const String goodPosture = '$_imagePath/good_posture.png';
  static const String badPosture = '$_imagePath/bad_posture.png';
  static const String backGroundImage = '$_backgroundPath/park.jpg';

  static const List<String> garbageImages = [
    GarbageImages.smallGarbage01,
    GarbageImages.smallGarbage02,
    GarbageImages.smallGarbage03,
    GarbageImages.smallGarbage04,
    GarbageImages.smallGarbage05,
    GarbageImages.smallGarbage06,
  ];

  static const List<String> bigGarbageImages = [
    GarbageImages.bigGarbage01,
    GarbageImages.bigGarbage02,
  ];

  static final List<String> flowerImages = [
    FlowerImages.flowerBabyBlue,
    FlowerImages.flowerBlue,
    FlowerImages.flowerGrey,
    FlowerImages.flowerLightBlue,
    FlowerImages.flowerLightGrey,
    FlowerImages.flowerLightPink,
    FlowerImages.flowerOceanBlue,
    FlowerImages.flowerOrange,
    FlowerImages.flowerPink,
    FlowerImages.flowerRed,
    FlowerImages.flowerRosa,
    FlowerImages.flowerTurkis,
  ];
}

class GarbageImages
{
  static const String smallGarbage01 = '$_objectsPath/small_garbage01.png';
  static const String smallGarbage02 = '$_objectsPath/small_garbage_02.png';
  static const String smallGarbage03 = '$_objectsPath/small_garbage_03.png';
  static const String smallGarbage04 = '$_objectsPath/small_garbage_04.png';
  static const String smallGarbage05 = '$_objectsPath/small_garbage_05.png';
  static const String smallGarbage06 = '$_objectsPath/small_garbage_06.png';
  static const String bigGarbage01 = '$_objectsPath/big_garbage_01.png';
  static const String bigGarbage02 = '$_objectsPath/big_garbage_02.png';
}

class FlowerImages{
  static const String flowerBabyBlue = '$_objectsPath/flower_babyblue.png';
  static const String flowerBlue = '$_objectsPath/flower_blue.png';
  static const String flowerGrey = '$_objectsPath/flower_gre.png';
  static const String flowerLightBlue = '$_objectsPath/flower_lightblue.png';
  static const String flowerLightGrey = '$_objectsPath/flower_lightgrey.png';
  static const String flowerLightPink = '$_objectsPath/flower_lightpink.png';
  static const String flowerOceanBlue = '$_objectsPath/flower_oceanblue.png';
  static const String flowerOrange = '$_objectsPath/flower_orange.png';
  static const String flowerPink = '$_objectsPath/flower_pink.png';
  static const String flowerRed = '$_objectsPath/flower_red.png';
  static const String flowerRosa = '$_objectsPath/flower_rosa.png';
  static const String flowerTurkis = '$_objectsPath/flower_turkis.png';
}

const int timeTillGarbage = 10;
const double timeTillGarbageDisposal = timeTillGarbage / 2;
const int timeTillBigGarbage = 30;
const double timeTillBigGarbageDisposal = timeTillBigGarbage / 2;
const int timeTillFlower = 5;
const double timeTillWarning = timeTillGarbage / 2.5; 