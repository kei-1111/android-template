# プロジェクトガイド - Claude Code向け

このドキュメントは、Claude Codeがこのプロジェクトで作業する際に必要な情報をまとめたものです。

## プロジェクト概要

このプロジェクトは、モダンなAndroidアプリケーションテンプレートから作成されています。
マルチモジュールを採用し、スケーラブルで保守性の高いコードベースを実現しています。

**特徴:**
- マルチモジュール（app, core, feature）
- Convention Pluginsによる統一された設定管理
- Jetpack Compose
- カスタムプレビューアノテーションによるアクセシビリティ対応
- 包括的なコード品質チェック（Detekt）

## 技術スタック

- **Kotlin**: 2.2.21
- **Gradle**: 8.13（Version Catalog使用）
- **Android Gradle Plugin**: 8.12.3
- **Compose BOM**: 2025.10.01
- **Min SDK**: 29（Android 10）
- **Target SDK**: 36
- **依存性注入**: Koin 4.1.1
- **コード品質**: Detekt 1.23.8（Composeルール含む）

## プロジェクト構造

```
project-root/
├── app/                          # メインアプリケーションモジュール
├── core/
│   ├── designsystem/            # テーマ、カラー、タイポグラフィ
│   └── ui/                      # 再利用可能なUIコンポーネントとプレビューアノテーション
├── build-logic/                 # Convention Plugins
│   └── convention/              # カスタムGradleプラグイン
├── config/
│   └── detekt/                  # Detekt設定ファイル
├── scripts/                     # 自動化スクリプト
│   └── create-module.sh         # 新規モジュール作成スクリプト
├── .github/
│   ├── workflows/               # CI/CDワークフロー
│   └── ISSUE_TEMPLATE/          # Issueテンプレート
├── docs/
│   └── NAMING_CONVENTION.md     # プロジェクト固有の命名規則
└── gradle/
    └── libs.versions.toml       # バージョンカタログ
```

## Convention Plugins（重要）

このプロジェクトでは、Gradleの設定を一元管理するためにConvention Pluginsを使用しています。

### 利用可能なプラグイン

`build-logic/convention/`に配置されたカスタムGradleプラグイン：

| プラグインID | 実装クラス | 用途 |
|-------------|-----------|------|
| `androidtemplate.android.application` | `AndroidApplicationConventionPlugin` | アプリモジュールの設定 |
| `androidtemplate.android.library` | `AndroidLibraryConventionPlugin` | 基本ライブラリモジュール |
| `androidtemplate.android.library.compose` | `AndroidLibraryComposeConventionPlugin` | Compose対応ライブラリ |
| `androidtemplate.android.feature` | `AndroidFeatureConventionPlugin` | フィーチャーモジュール |
| `androidtemplate.detekt` | `DetektConventionPlugin` | コード品質チェック |

### プラグインの使い方

モジュールの`build.gradle.kts`で使用：

```kotlin
plugins {
    alias(libs.plugins.androidtemplate.android.library.compose)
}

android {
    namespace = "com.example.myapp.feature.home"
}

dependencies {
    // 依存関係を追加
}
```

### プラグインが設定する内容

**AndroidApplicationConventionPlugin**:
- Kotlin設定（JVM target 21）
- Android SDK設定（compileSdk 36, minSdk 29）
- ビルド最適化（並列実行、キャッシュ）
- Lint設定

**AndroidLibraryComposeConventionPlugin**:
- 上記のライブラリ設定
- Compose設定（Compiler、強い省略モード）
- Compose依存関係

**AndroidFeatureConventionPlugin**:
- ライブラリ設定
- Compose設定
- Koin依存関係
- Navigation Compose依存関係

**DetektConventionPlugin**:
- Detekt設定の適用
- カスタム設定ファイルの指定
- 並列実行の有効化

### プラグインの編集

Convention Pluginsを編集する場合：

1. `build-logic/convention/src/main/kotlin/io/github/kei_1111/androidtemplate/`を編集
2. プロジェクトをSync
3. すべてのモジュールに変更が反映される

**重要**: プラグインの変更はプロジェクト全体に影響するため、慎重に行ってください。

## Detektによるコード品質管理

### Detektとは

Detektは、Kotlinコードの静的解析ツールです。このプロジェクトでは包括的な設定を使用しています。

### 設定ファイル

`config/detekt/detekt.yml` - 1,100行以上の詳細な設定

**有効なルールセット**:
- **complexity**: 複雑度チェック（循環的複雑度、関数の長さなど）
- **coroutines**: コルーチンのベストプラクティス
- **empty-blocks**: 空のブロックの検出
- **exceptions**: 例外処理のパターン
- **naming**: 命名規則（`docs/NAMING_CONVENTION.md`参照）
- **performance**: パフォーマンス最適化
- **potential-bugs**: 潜在的なバグの検出
- **style**: コードスタイル
- **formatting**: フォーマット（自動修正可能）
- **compose**: Compose固有のルール（detekt-compose-rules使用）

### Detektの実行

**コミット前に実行**:
```bash
./gradlew detekt
```

**自動修正**:
```bash
./gradlew detekt --auto-correct
```

**特定モジュールのみ**:
```bash
./gradlew :app:detekt
./gradlew :core:ui:detekt
```

### CI/CDでの実行

`.github/workflows/detekt.yml`で自動実行：
- PR作成時
- mainブランチへのpush時

### Detektエラーの対処

1. **エラーメッセージを確認**: 何が問題か理解する
2. **自動修正を試す**: `--auto-correct`で修正可能か確認
3. **手動修正**: 必要に応じてコードを修正
4. **suppressが必要な場合**: 正当な理由があれば`@Suppress`アノテーションを使用

```kotlin
@Suppress("MagicNumber")  // 正当な理由をコメントで説明
val timeout = 5000L
```

## プレビューアノテーション

### 概要

`core:ui`モジュールに2種類のカスタムプレビューアノテーションがあります。

**配置場所**: `core/ui/src/main/kotlin/.../core/ui/preview/`

### ScreenPreview

画面レベルのComposable用（8パターンのプレビュー）

**プレビュー内容**:
- ライト/ダークテーマ（2種類）
- Phone/Tablet（2種類）
- 標準/大フォント（2種類）
- = 2 × 2 × 2 = 8パターン

**特徴**:
- `showSystemUi = true` でシステムUIを表示
- デバイスフレーム表示
- 画面全体のレイアウト確認に最適

**使用例**:
```kotlin
@ScreenPreview
@Composable
fun HomeScreenPreview() {
    AndroidTemplateTheme {
        HomeScreen()
    }
}
```

### ComponentPreview

コンポーネントレベルのComposable用（4パターンのプレビュー）

**プレビュー内容**:
- ライト/ダークテーマ（2種類）
- 標準/大フォント（2種類）
- = 2 × 2 = 4パターン

**特徴**:
- デバイスフレームなし
- 軽量で素早いプレビュー
- 個別コンポーネントの確認に最適

**使用例**:
```kotlin
@ComponentPreview
@Composable
fun PrimaryButtonPreview() {
    AndroidTemplateTheme {
        PrimaryButton(onClick = {}) {
            Text("ボタン")
        }
    }
}
```

### プレビューアノテーションを使う理由

- **アクセシビリティ対応**: フォントスケールを自動テスト
- **デバイス対応**: Phone/Tabletで確認
- **一貫性**: プロジェクト全体で同じプレビュー基準
- **効率化**: 1つのアノテーションで包括的なプレビュー

## 命名規則

**重要**: `docs/NAMING_CONVENTION.md`に詳細な命名規則があります。

### クイックリファレンス

**Convention Plugins**:
- 実装クラス: `Android<Type>ConventionPlugin`
- Plugin ID: `<prefix>.<type>.<subtype>`

**モジュール**:
- Core: `core:<module-name>`
- Feature: `feature:<module-name>`

**Composable関数**:
- Theme: `<ProjectName>Theme`
- Screen: `<FeatureName>Screen`

**Applicationクラス**:
- `<ProjectName>Application`

**バージョンカタログ**:
- versions: camelCase
- libraries: kebab-case
- plugins: kebab-case

## 新規モジュールの作成

### スクリプトを使用（推奨）

```bash
./scripts/create-module.sh
```

対話形式で以下を選択：
1. モジュールタイプ（Core/Feature/Custom）
2. Composeの使用有無
3. モジュール名

スクリプトが自動的に：
- ディレクトリ構造を作成
- `build.gradle.kts`を生成
- `settings.gradle.kts`に追加
- パッケージ構造を作成

### 手動作成（非推奨）

スクリプトの使用を推奨しますが、手動で作成する場合：

1. ディレクトリ作成
2. `build.gradle.kts`作成
3. `settings.gradle.kts`に`include(":path:to:module")`追加
4. パッケージ構造作成
5. Gradle Sync

## 依存関係の管理

### バージョンカタログの編集

`gradle/libs.versions.toml`で一元管理：

```toml
[versions]
myLibrary = "1.0.0"  # camelCase

[libraries]
my-library = { group = "com.example", name = "my-library", version.ref = "myLibrary" }  # kebab-case

[plugins]
my-plugin = { id = "com.example.plugin", version.ref = "myPlugin" }  # kebab-case
```

### 依存関係の追加

モジュールの`build.gradle.kts`:

```kotlin
dependencies {
    implementation(libs.my.library)  // ドットでアクセス
    implementation(projects.core.ui)  // プロジェクト間依存
}
```

## 開発フロー

### 新規機能の作成

1. **フィーチャーモジュールを作成**:
   ```bash
   ./scripts/create-module.sh
   ```
   「Feature Module」を選択

2. **依存関係を追加**:
   ```kotlin
   dependencies {
       implementation(projects.core.ui)
       implementation(projects.core.designsystem)
       implementation(libs.koin.android)
   }
   ```

3. **画面を実装**:
   ```kotlin
   @Composable
   fun MyFeatureScreen() {
       // 実装
   }

   @ScreenPreview
   @Composable
   fun MyFeatureScreenPreview() {
       AndroidTemplateTheme {
           MyFeatureScreen()
       }
   }
   ```

4. **ViewModelを実装** (必要に応じて)
5. **テストを追加** (必要に応じて)

### UIコンポーネントの作成

1. **適切なモジュールに配置**:
   - 再利用可能: `core:ui`
   - 機能固有: `feature:*`

2. **プレビューアノテーションを追加**:
   ```kotlin
   @Composable
   fun MyComponent() {
       // 実装
   }

   @ComponentPreview
   @Composable
   fun MyComponentPreview() {
       AndroidTemplateTheme {
           MyComponent()
       }
   }
   ```

3. **アクセシビリティを考慮**:
   - プレビューで大フォント表示を確認
   - ダークモードでの見え方を確認

### コード品質チェック

**コミット前**:
```bash
./gradlew detekt
```

**問題があれば修正**:
```bash
./gradlew detekt --auto-correct  # 自動修正
# または手動で修正
```

## CI/CD

### GitHub Actions ワークフロー

**test.yml** - テスト実行:
- PR作成時/push時に実行
- ユニットテストを実行
- テストレポートをアーティファクトとしてアップロード

**detekt.yml** - 静的解析:
- PR作成時/push時に実行
- Detektでコード品質チェック
- 問題があればPRをブロック

### ワークフローの詳細

`.github/workflows/README.md`を参照してください。

## 重要なファイル

### 設定ファイル

- `gradle/libs.versions.toml` - すべての依存関係バージョン
- `config/detekt/detekt.yml` - Detekt設定
- `gradle.properties` - Gradle設定
- `settings.gradle.kts` - モジュール定義

### ドキュメント

- `README.md` - プロジェクト概要とクイックスタート
- `docs/NAMING_CONVENTION.md` - プロジェクト固有の命名規則
- `scripts/README.md` - スクリプト使用方法
- `.github/workflows/README.md` - CI/CD ドキュメント

### テーマシステム

- `core/designsystem/.../theme/Color.kt` - カラーパレット
- `core/designsystem/.../theme/Theme.kt` - メインテーマ
- `core/designsystem/.../theme/Type.kt` - タイポグラフィ

### プレビューシステム

- `core/ui/.../preview/ScreenPreview.kt` - 画面用プレビュー
- `core/ui/.../preview/ComponentPreview.kt` - コンポーネント用プレビュー

## よくあるタスク

### 新しいCoreモジュールの追加

```bash
./scripts/create-module.sh
# "Core Library"を選択
# Composeの使用有無を選択
# モジュール名を入力（例: common, data）
```

### 新しいFeatureの追加

```bash
./scripts/create-module.sh
# "Feature Module"を選択
# フィーチャー名を入力（例: home, profile）
```

### 依存関係の更新

1. `gradle/libs.versions.toml`を編集
2. `[versions]`セクションのバージョンを更新
3. Gradle Sync
4. テストを実行して確認

### テストの実行

```bash
./gradlew test                    # ユニットテスト
./gradlew :app:test              # 特定モジュールのテスト
```

## Claude Codeへのヒント

1. **命名規則を必ず確認**: `docs/NAMING_CONVENTION.md`を参照
2. **プレビューアノテーションを使用**: Composableを作成したら必ずプレビューを追加
3. **モジュールパターンに従う**: 既存のモジュール構造を参考に
4. **Convention Pluginsを活用**: モジュール作成時は適切なプラグインを使用
5. **Detektを実行**: コード作成後は必ずチェック
6. **スクリプトを活用**: 手動作成よりもスクリプト使用を優先
7. **アクセシビリティを考慮**: プレビューで大フォントとダークモードを確認

## トラブルシューティング

### ビルドエラー

1. **Clean Build**:
   ```bash
   ./gradlew clean build
   ```

2. **キャッシュクリア**:
   ```bash
   ./gradlew clean
   rm -rf .gradle
   ```

3. **Gradle Sync**: Android Studioで再同期

### Detektエラー

1. エラー内容を確認
2. 自動修正を試す: `./gradlew detekt --auto-correct`
3. 手動修正
4. 必要に応じて`@Suppress`を使用（理由をコメントで記載）

### プレビューが表示されない

1. Gradle Syncを実行
2. Android Studioを再起動
3. Build > Clean Project
4. プレビューアノテーションのimportを確認

## 参考リンク

- **Issue報告**: GitHubのIssueテンプレートを使用
- **ドキュメント**: `/docs`フォルダと`README.md`を参照
- **ワークフロー**: `.github/workflows/`でCI/CD詳細を確認