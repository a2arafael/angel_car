import 'package:angel_car/global/model/social_media.dart';

class Singleton {
  static final Singleton _instance = Singleton._internal();
  SocialMedia? _socialMedia;

  factory Singleton() {
    return _instance;
  }

  Singleton._internal() {
    // initialization logic
  }

  void setSocialMedia(SocialMedia medias){
    _socialMedia = medias;
  }

  SocialMedia? getSocialMedia(){
    return _socialMedia;
  }

  void clearSingleton(){
    _socialMedia = null;
  }
}