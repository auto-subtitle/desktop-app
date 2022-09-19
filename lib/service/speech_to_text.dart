import 'package:auto_subtitle/service/file_provider.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';

List createRecognitionList(results, defaultWhileTime) {
  List<Map> sentences = [];
  for (var result in results) {
    var alternatives = result.alternatives;
    for (var alternative in alternatives) {
      String sentence = "";
      int startTime = 1;
      int endTime = 0;
      bool firstLoopFlag = true;
      for (var wordInfo in alternative.words) {
        String word = wordInfo.word.split("|").first;
        int wordStartTime = wordInfo.startTime.seconds.toInt();
        int wordEndTime = wordInfo.endTime.seconds.toInt();
        if (firstLoopFlag) {
          sentence += word;
          startTime = wordStartTime;
          endTime = wordEndTime;
          firstLoopFlag = false;
        } else {
          if (wordStartTime - endTime < defaultWhileTime) {
            // 1秒以内の場合は1つの文章としてみなす
            // 今後は、秒数を指定できるように
            // また、nanosで指定もしたい
            sentence += word;
            endTime = wordEndTime;
          } else {
            // 1秒以上の場合は、別の文章としてみなす
            // +1秒で字幕表示を遅延させる
            if (sentence.length > 30) {
              String leading = sentence.substring(0, 30);
              String trailing = sentence.substring(30, sentence.length);
              sentence = "$leading\n$trailing";
            }
            sentences.add({
              "sentence": sentence,
              "startTime": startTime,
              "endTime": endTime,
            });
            sentence = word;
            startTime = wordStartTime;
            endTime = wordEndTime;
          }
        }
        if (alternative.words.last == wordInfo) {
          if (sentence.length > 30) {
            String leading = sentence.substring(0, 30);
            String trailing = sentence.substring(30, sentence.length);
            sentence = "$leading\n$trailing";
          }
          sentences.add({
            "sentence": sentence,
            "startTime": startTime,
            "endTime": wordEndTime,
          });
        }
      }
    }
  }
  sentences[0]["startTime"] = 1;
  return sentences;
}

Future<List> convert(String path) async {
  final ServiceAccount serviceAccount = ServiceAccount.fromString(
      (await rootBundle.loadString('lib/assets/credentials.json')));

  final speech = SpeechToTextBeta.viaServiceAccount(serviceAccount);

  final config = RecognitionConfigBeta(
    encoding: AudioEncoding.ENCODING_UNSPECIFIED,
    sampleRateHertz: 16000,
    languageCode: 'ja-JP',
    enableWordTimeOffsets: true,
    enableAutomaticPunctuation: true,
  );

  final audio = await getFile(path);
  var value = await speech.recognize(config, audio);
  deleteFile(path);

  return createRecognitionList(value.results, 1);
}
