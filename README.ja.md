# AID Diary

[English](README.md) | [简体中文](README.zh-CN.md) | **日本語** | [한국어](README.ko.md)

Flutter で作られた、Windows と Android 向けのプライベートな日記アプリです。

AID Diary は Demizo ほかによる [Daily You](https://github.com/Demizo/Daily_You)（GPL-3.0）の改変版で、Daily You の公式アプリでは**ありません**。上流のバージョンとライセンスは [SOURCE.md](SOURCE.md) を参照してください。

最新の `main` のビルドは [nightly プレリリース](https://github.com/playeriv65/AID-AIDiary/releases/tag/nightly)にあります（Android APK と Windows 用 ZIP）。デバッグ鍵で署名されているため新規インストールはできますが、リリース鍵で署名されたインストールを上書きすることはできません。

これは簡略版です。機能の詳細は[英語の README](README.md) が正で、開発ドキュメントも英語です。

## スクリーンショット

| タブレット / PC | スマートフォン |
|---|---|
| ![日記](artifacts/ui-tablet-journal.png) | ![日記](artifacts/ui-phone-journal.png) ![日記の表示](artifacts/ui-phone-entry.png) |
| ![カレンダー](artifacts/ui-tablet-calendar.png) | ![カレンダー](artifacts/ui-phone-calendar.png) ![メディア](artifacts/ui-phone-media.png) |
| ![エディター](artifacts/ui-tablet-editor.png) | ![エディター](artifacts/ui-phone-editor.png) ![検索](artifacts/ui-phone-search.png) |

## 主な機能

- **日記**：日ごとにまとめた日記カード（時刻、タイトル、要約、気分、場所、天気、タグ）。上には「今日」、過去のこの日、ランダムウォーク、週・年の振り返りなどのストーリー。
- **日記の日付**：書いた時刻と、その日記がどの日のものかを別々に記録します。深夜に書いたものは既定で前日扱いで、書いた時刻を変えずにいつでも日付を変更できます。
- **エディター**：タイトルは任意。Markdown、写真、動画、ボイスメモ、手書きに対応し、新しい日記には場所と天気を自動で入れます。
- **コメントと引用**：過去の日記で文字を選ぶと、その一節を保存したりコメントしたりできます。日記全体へのコメントも可能です。コメントは今日の日記として保存され、応える元の文を引用します。数行の短いコメントから、全画面のエディターに広げることもできます。どの日記も他の日記を引用でき、日記の下にはそれに応えた日記が並びます。
- **カレンダー**：日記画面でその場で開き、日付をタップすると一覧がその日まで移動します。
- **地図**：場所のある日記を OpenStreetMap 上に表示します。複数の日記がある地点を開くと、その日記の一覧になります。
- **タグ**：新しい日記帳にはタグがありません。並び順は長押しでドラッグして決め、日記カードにタグ名が表示されます。
- **写真**：既定では元の写真を保存します。新しい写真を約 1 MB の WebP で保存することも、既存の写真を一度に圧縮することもできます（元に戻せません）。
- **非表示の日記**：「設定 › セキュリティ」で端末上の認証をしてから開きます。通常の一覧、検索、ウィジェット、エクスポートには出ず、同期先の端末でも非表示のままです。
- **同期（任意）**：常にエンドツーエンド暗号化で、日記用のアカウントやパスワードはありません。自分の Google Drive、WebDAV、または `server/` の AID 同期サーバーを使えます。同じネットワーク上の端末は直接転送します。新しい端末はペアリングコードか QR で追加し、すべての端末を失ったときは復元コードで戻せます。
- **インポート / エクスポート**：One Diary v3 のバックアップ、Journey、Day One、Daylio などを読み込み、JSON、Markdown、Journey と Day One 形式、完全バックアップを書き出せます。
- **コマンドライン**：アプリのすべての機能はアクションとして、ボタン、コマンドパレット、`aid` コマンドラインで共通に使え、スクリプトや AI エージェントの操作がその場でアプリに表示されます。
- **Android ホーム画面ウィジェット**：今日の状態、毎日の写真、連続日数、書くためのお題、クイック気分。

## プライバシーと通信

日記、写真、座標は端末に保存されます。同期をオンにした場合だけ、選んだストレージと信頼した端末へ暗号化して送られます。以下の通信はすべて任意で、宛先は [assets/config/app_config.json](assets/config/app_config.json) で設定します。

- OpenStreetMap の地図タイルと、Nominatim による地名検索。
- Overpass による近くの場所の検索（場所の選択を開いたとき）。
- Open-Meteo の天気（座標と日付だけを送信）。
- Google Drive で同期するときの Google ログインと Drive API。

## 開発

主に Windows で開発しています。[ドキュメント索引](docs/INDEX.md)と[引き継ぎ](docs/HANDOFF.md)から始め、新しい PC のツールチェーン、署名、テスト端末は[セットアップ](docs/SETUP.md)を参照してください。よく使うコマンドは[英語の README](README.md#development) にあります。

## ライセンス

GPL-3.0-only（[LICENSE.txt](LICENSE.txt)）、追加条項は [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md) を参照してください。
