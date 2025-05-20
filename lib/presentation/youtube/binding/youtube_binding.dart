import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/controller/youtube_player_controller.dart';

class YoutubeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YoutubePlayerGetxController>(() => YoutubePlayerGetxController());
  }
}
