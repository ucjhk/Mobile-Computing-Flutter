///------------------------------------------------------------------------///
/// GardenObject constants
///------------------------------------------------------------------------///

//in days
const int daysUntilDispose = 3;
//in %
const double disposeMultiplier = 0.1;
//Time longer for flowers to grow
const double garbageMultiplier = 0.1;
const double bigGarbageMultiplier = 0.5;
//in seconds
const int timeTillGarbage = 30;
const double timeTillGarbageDisposal = timeTillGarbage * 1.2;
const int timeTillBigGarbage = 150;
const double timeTillBigGarbageDisposal = timeTillBigGarbage * 1.5;
const int timeTillFlower = 60;
const double timeTillWarning = timeTillGarbage / 3; 

///------------------------------------------------------------------------///
/// Earable constants
/// ------------------------------------------------------------------------///

const String eSenseName = 'eSense-0723';
const angelThreshold = 4;
const samplingRate = 10;
const String warnSoundPath = 'sounds/warn.mp3';
const String sessionEndSoundPath = 'sounds/sessionEnd.mp3';

///------------------------------------------------------------------------///
/// StopWatch constants
///------------------------------------------------------------------------///

//in minutes
const int sessionTime = 40;
const int pauseTime = 5;

///------------------------------------------------------------------------///
/// Image paths
///------------------------------------------------------------------------///

const String _objectsPath = 'assets/images/objects';
const String _backgroundPath = 'assets/images/background';
const String _imagePath = 'assets/images';

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