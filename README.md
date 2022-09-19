![header](lib/assets/header_filled.png)
## :sparkles: About

このツールは、Flutterで作成されています。<br>
動画を選択することで、自動で1920x1080に変換し、オーディオから発言を検出、焼き付けができます。

## :speech_balloon: Platform Support
このアプリケーションは、現時点で**macOS**のみサポートしています。<br>
iOS、Andoridへの対応も予定しています。

## :arrow_down: Installation
1. リポジトリをローカルにクローン
```
$ git clone https://github.com/auto-subtitle/desktop-app.git
```
2. lib/assets/
2. リポジトリのフォルダへ移動し、必要なパッケージをインストール
```
$ cd desktop-app
$ flutter pub get
```
3. podで使用するリポジトリをインストール
```
$ cd macos
$ pod install
```
4. アプリケーションを実行
```
$ flutter run -d macOS --debug
```

## :warning: Warning
エンコードの際使用する一部のコーデックには、ライセンスが適用される場合があります。<br>
https://www.ffmpeg.org/legal.html
