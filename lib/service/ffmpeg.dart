import 'package:auto_subtitle/service/file_provider.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';

Future<String> convertVideotoMP3(String path) async {
  if (path != "") {
    String mp3 = "${path.split('.').first}.mp3";
    await FFmpegKit.execute("-y -i '$path' -vn -ar 16000 -b:a 192k '$mp3'")
        .then(
      (value) async {
        final returnCode = await value.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
        } else {}
      },
    );
    return mp3;
  } else {
    throw Exception("Please select a video");
  }
}

Future embedSubtitle(
    String path, String srtFile, int resolution, int extend) async {
  int width = 1920;
  int height = 1080;
  switch (resolution) {
    case 0:
      width = 640;
      height = 480;
      break;
    case 1:
      width = 1280;
      height = 720;
      break;
    case 2:
      break;
  }
  String ext = (extend == 0) ? "mov" : "mp4";

  //1920 x 1080
  if (path != "") {
    String outputFileName = "${path.split('.').first}-output.$ext";
    await FFmpegKit.execute(
            '''-y -i "$path" -vf "yadif=deint=interlaced, scale=w=trunc(ih*dar/2)*2:h=trunc(ih/2)*2, setsar=1/1, scale=w=$width:h=$height:force_original_aspect_ratio=1, pad=w=$width:h=$height:x=(ow-iw)/2:y=(oh-ih)/2:color=#000000, subtitles=$srtFile" -pix_fmt yuv420p "$outputFileName"''')
        .then(
      (value) async {
        final returnCode = await value.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          //return mp4file;
        } else {
          throw Exception("FAIL");
        }
      },
    );
    deleteFile(srtFile);
  } else {
    throw Exception("Please select a video");
  }
}
