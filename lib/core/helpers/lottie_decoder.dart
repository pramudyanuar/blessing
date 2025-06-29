import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Future<LottieComposition?> customDecoder(List<int> bytes) async {
  final composition = await LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      final file = files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
      if (file == null) {
        return null;
      }
      return file;
    },
  );
  if (composition == null) {
    return null;
  }
  return composition;
}
