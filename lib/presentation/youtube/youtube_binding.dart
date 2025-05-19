import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/youtube_player_controller.dart';

class YoutubeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YoutubePlayerGetxController>(() => YoutubePlayerGetxController());
  }
}
