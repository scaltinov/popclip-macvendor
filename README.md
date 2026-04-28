# MAC Vendor - PopClip Extension

MACアドレスのベンダー（製造元）情報を表示するPopClip拡張機能

## 機能

- **ベンダー名**: MACアドレスの製造元会社名
- **OUI**: MACプレフィックス（先頭3バイト）
- **国**: 製造元の国
- **住所**: 製造元の住所（オプション）
- **ブロックタイプ**: MA-L / MA-M / MA-S（オプション）
- **プライベートフラグ**: ローカル管理アドレス判定（オプション）

## 対応MACアドレス形式

- `AA:BB:CC:DD:EE:FF`（コロン区切り）
- `AA-BB-CC-DD-EE-FF`（ハイフン区切り）
- `AABB.CCDD.EEFF`（Cisco ドット表記）

## インストール

### リリース版（推奨）

[Releases](https://github.com/scaltinov/popclip-macvendor/releases) から `MACVendor.popclipextz` をダウンロードしてダブルクリック。PopClipがインストールを促す。

### ソースから

```bash
git clone git@github.com:scaltinov/popclip-macvendor.git
cd popclip-macvendor
make install
```

`make install` は同階層に `MACVendor.popclipext` を生成し、`open` でPopClipのインストールダイアログを起動する。

## 使い方

1. 任意のアプリでMACアドレスを選択
2. PopClipメニューの「MAC」ボタンをクリック
3. ベンダー情報をダイアログまたはPopClipポップアップで確認

## 設定オプション

- **MACアドレスを表示** — デフォルト: ON
- **ベンダー名を表示** — デフォルト: ON
- **OUI（MACプレフィックス）を表示** — デフォルト: ON
- **国を表示** — デフォルト: ON
- **住所を表示** — デフォルト: OFF
- **ブロックタイプ（MA-L/M/S）を表示** — デフォルト: OFF
- **プライベート/ローカル管理フラグを表示** — デフォルト: OFF
- **クリップボードにコピー** — デフォルト: ON
- **ダイアログで確認** — デフォルト: ON

## 要件

- macOS
- PopClip
- インターネット接続（[api.maclookup.app](https://maclookup.app) 使用）
- `python3`（macOS標準）

## ライセンス

MIT

## 作者

Created with [Claude Code](https://claude.com/claude-code)
