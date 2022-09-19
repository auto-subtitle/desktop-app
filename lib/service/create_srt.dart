import 'dart:io';

createSrtFile(List sentenceList, String savePath) async {
  String srtText = await createSrtText(sentenceList);
  String filePath = "${savePath.split(".").first}.srt";
  File file = File(filePath);
  file.writeAsStringSync(srtText);
  return filePath;
}

createSrtText(List sentenceList) async {
  var srt = "";
  int count = 1;
  for (var centence in sentenceList) {
    String line = centence["sentence"];
    String startTime = secToDuration(centence["startTime"]);
    String endTime = secToDuration(centence["endTime"]);
    srt += "$count\n";
    srt += "$startTime --> $endTime\n";
    srt += "$line\n";
    srt += "\n";
    count++;
  }
  return srt;
}

// s から hh:mm:ss,msmsmsの形にする
String secToDuration(int sec) {
  Duration duration = Duration(seconds: sec);
  String durationString = duration.toString();
  if (durationString.length == 14) {
    durationString = "0$durationString";
  }
  String durationWithComma = durationString.replaceAll(".", ",");
  String roundedDuration = durationWithComma.substring(0, 12);
  return roundedDuration;
}
