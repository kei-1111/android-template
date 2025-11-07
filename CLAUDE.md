# Android Template - Project Guide

このプロジェクトは、マルチモジュール構成のAndroidアプリケーションです。

## プロジェクト構造

```
project-root/
├── app/                          # メインアプリケーションモジュール
├── core/
│   ├── designsystem/            # テーマ、カラー、タイポグラフィ
│   └── ui/                      # 再利用可能なUIコンポーネント
├── build-logic/convention/       # Convention Plugins
├── config/detekt/                # Detekt設定ファイル
├── scripts/create-module.sh      # 新規モジュール作成スクリプト
└── gradle/libs.versions.toml     # バージョンカタログ
```

## Convention Plugins

Gradleの設定を一元管理するカスタムプラグイン（`build-logic/convention/`）：

| プラグインID | 用途 |
|-------------|------|
| `androidtemplate.android.application` | アプリモジュールの設定 |
| `androidtemplate.android.library` | 基本ライブラリモジュール |
| `androidtemplate.android.library.compose` | Compose対応ライブラリ |
| `androidtemplate.android.feature` | フィーチャーモジュール |
| `androidtemplate.detekt` | コード品質チェック |

使用例：
```kotlin
plugins {
    alias(libs.plugins.androidtemplate.android.library.compose)
}
```

## 主要なコマンド

### 新規モジュール作成
```bash
./scripts/create-module.sh
```

### ビルドとテスト
```bash
./gradlew build
./gradlew test
```

### Detekt（静的解析）
```bash
./gradlew detekt
```

## プレビューアノテーション

`core:ui`モジュールに2種類のカスタムプレビューアノテーションがあります：

- **@PreviewScreen**: 画面用（ライト/ダーク、Phone/Tablet、標準/大フォント）
- **@PreviewComponent**: コンポーネント用（ライト/ダーク、標準/大フォント）

使用例：
```kotlin
@ScreenPreview
@Composable
fun HomeScreenPreview() {
    AndroidTemplateTheme {
        HomeScreen()
    }
}
```

## 依存関係の管理

`gradle/libs.versions.toml`でバージョンを一元管理：

```toml
[versions]
myLibrary = "1.0.0"

[libraries]
my-library = { group = "com.example", name = "my-library", version.ref = "myLibrary" }
```

使用：
```kotlin
dependencies {
    implementation(libs.my.library)
    implementation(projects.core.ui)
}
```

## 参考ドキュメント

- 命名規則: `docs/NAMING_CONVENTION.md`
- Detekt設定: `config/detekt/detekt.yml`