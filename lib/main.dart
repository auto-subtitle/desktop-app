import 'package:auto_subtitle/service/constants.dart';
import 'package:auto_subtitle/service/create_srt.dart';
import 'package:auto_subtitle/service/ffmpeg.dart';
import 'package:auto_subtitle/service/speech_to_text.dart';
import 'package:auto_subtitle/widgets/custom_tile.dart';
import 'package:auto_subtitle/widgets/tile_with_toggle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowFrame(const Rect.fromLTWH(200, 100, 900, 600));
  setWindowMinSize(const Size(900, 600));
  setWindowMaxSize(const Size(900, 600));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Subtitle',
      theme: ThemeData(
        primarySwatch: primaryColor,
        textTheme: GoogleFonts.murechoTextTheme(),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dir = "";
  String path = "";
  int resolution = 2;
  int extend = 1;
  String waterMarkPath = "";
  int progress = 0;
  String progressMessage = "idle";

  void selectSaveFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        dir = selectedDirectory;
      });
    }
  }

  void selectVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null && result.files.first.path != null) {
      setState(() {
        path = result.files.single.path!;
      });
    }
  }

  void selectWaterMark() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.first.path != null) {
      setState(() {
        waterMarkPath = result.files.single.path!;
      });
    }
  }

  void changeProgress(int value, String message) {
    setState(() {
      progress = value;
      progressMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Image.asset("lib/assets/header.png", height: 50),
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Required",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ),
              CustomTile(
                text: "保存先のフォルダ",
                description: (dir == "") ? "未選択" : dir,
                leading: Icons.save_as,
                buttonText: "フォルダを選択",
                onPressed: selectSaveFolder,
              ),
              Icon(Icons.arrow_downward, color: secondaryColor),
              CustomTile(
                text: "動画を選択",
                description: (path == "") ? "未選択" : path,
                leading: Icons.file_present,
                buttonText: "ファイルを選択",
                onPressed: (dir != "") ? selectVideo : null,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Options",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor),
                ),
              ),
              TileWithToggle(
                text: "解像度",
                leading: Icons.hd,
                initialLabelIndex: resolution,
                totalSwitches: 3,
                activeBgColor:
                    (path != "") ? primaryColor : const Color(0xff303132),
                activeFgColor: (path != "") ? secondaryColor : accentColor,
                labels: const ["480p", "720p", "1080p"],
                onToggle: (index) {
                  resolution = index;
                },
              ),
              TileWithToggle(
                text: "拡張子",
                leading: Icons.drive_file_rename_outline,
                initialLabelIndex: extend,
                totalSwitches: 2,
                activeBgColor:
                    (path != "") ? primaryColor : const Color(0xff303132),
                activeFgColor: (path != "") ? secondaryColor : accentColor,
                labels: const ["MOV", "MP4"],
                onToggle: (index) {
                  extend = index;
                },
              ),
              CustomTile(
                text: "カスタムロゴ",
                description: (waterMarkPath == "") ? "未選択" : waterMarkPath,
                leading: Icons.branding_watermark,
                buttonText: "ファイルを選択",
                onPressed: (path != "") ? selectWaterMark : null,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "progress: $progress/5",
                      style: TextStyle(color: secondaryColor),
                    ),
                  ),
                  Text(
                    " $progressMessage",
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,
        onPressed: (dir != "" && path != "")
            ? () async {
                changeProgress(1, "Coverting MP4 to MP3");
                var mp3 = await convertVideotoMP3(path);
                changeProgress(2, "Transcribing MP3 in progress");
                var sentenceList = await convert(mp3);
                changeProgress(3, "Generating SRT file");
                createSrtFile(sentenceList, path).then(
                  (value) async {
                    changeProgress(4, "Embedding Subtitles");
                    await embedSubtitle(path, value, resolution, extend).then(
                      (value) async {
                        changeProgress(5, "All done!");
                        final result =
                            await FlutterPlatformAlert.showCustomAlert(
                          windowTitle: "エンコードが完了しました",
                          text: "保存先のフォルダを開きますか？",
                          positiveButtonTitle: "開く",
                          negativeButtonTitle: "キャンセル",
                          options: FlutterPlatformAlertOption(),
                        );
                        if (result == CustomButton.positiveButton) {
                          launchUrl(Uri.directory(dir));
                        }
                      },
                    );
                  },
                );
              }
            : () => {
                  FlutterPlatformAlert.playAlertSound(),
                  FlutterPlatformAlert.showAlert(
                    windowTitle: "エラー",
                    text: "Requiredの項目を全て入力してください",
                  ),
                },
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        label: const Text(
          "実行",
          style: TextStyle(color: Colors.green),
        ),
      ),
    );
  }
}
