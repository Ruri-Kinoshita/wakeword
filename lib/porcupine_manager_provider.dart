import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';

final detectedNumberProvider = StateProvider<bool>((ref) => false);

final porcupineManagerProvider = FutureProvider<PorcupineManager>((ref) async {
  await dotenv.load(fileName: '.env');
  String accessKey = dotenv.get('APIKEY');
  PorcupineManager _manager;
  final detectedNum = ref.watch(detectedNumberProvider.notifier);

  void _detectedCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      print('start'); // ばったりいただき
    } else if (keywordIndex == 1) {
      print('stop'); // ばったりごちそう
    }
    detectedNum.state = true;
  }

  _manager = await PorcupineManager.fromKeywordPaths(
    accessKey,
    [
      "assets/wakewords/ばったりいただき_ja_android_v3_0_0.ppn", // キーワード1
      "assets/wakewords/ばったりごちそう_ja_android_v3_0_0.ppn", // キーワード2
    ],
    _detectedCallback,
    modelPath: 'assets/wakewords/porcupine_params_ja.pv',
  );
  _manager.start();
  ref.onDispose(() async {
    await _manager.delete();
  });
  return _manager;
});
