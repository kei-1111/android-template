# Scripts

このディレクトリには、プロジェクト開発を効率化するスクリプトが含まれています。

## convert-project.sh

テンプレートプロジェクトを新しいプロジェクトに変換するスクリプトです。このスクリプトは**一度だけ実行**し、テンプレートから新規プロジェクトを作成する際に使用します。

### 使い方

```bash
./scripts/convert-project.sh
```

### 機能

このスクリプトは以下の変換を対話形式で行います：

1. **パッケージ名の変更**
   - 形式: `com.example.myapp` (小文字、ドット区切り)
   - すべてのKotlinファイル、ビルドファイル、XMLファイルを更新

2. **プロジェクト名の変更**
   - 形式: `my-app` (小文字、ハイフン区切り)
   - `settings.gradle.kts` などの設定ファイルを更新

3. **Convention Plugin IDの変更**
   - 形式: `myapp` (小文字、特殊文字なし)
   - すべてのプラグイン定義とビルドファイルを更新

4. **テーマ名の変更**
   - 形式: `MyApp` (PascalCase)
   - XMLリソースファイルとComposeテーマファイルを更新

5. **Applicationクラス名の変更**
   - 形式: `MyAppApplication` (PascalCase)
   - AndroidManifestとApplicationクラスファイルを更新

### 実行フロー

```bash
$ ./scripts/convert-project.sh

╔════════════════════════════════════════════════════════════╗
║   Android Template → New Project Conversion Script        ║
╔════════════════════════════════════════════════════════════╗

1. New Package Name
   Format: com.example.myapp (lowercase, dot-separated)
   Current: io.github.kei_1111.androidtemplate
   Enter new package name: com.example.myapp

2. New Project Name
   Format: my-app (lowercase, hyphen-separated)
   Current: android-template
   Enter new project name: my-app

3. New Convention Plugin ID
   Format: myapp (lowercase, no special characters)
   Current: androidtemplate
   Enter new plugin ID: myapp

4. New Theme Name
   Format: MyApp (PascalCase)
   Current: AndroidTemplate
   Enter new theme name: MyApp

5. New Application Class Name
   Format: MyAppApplication (PascalCase, typically ends with 'Application')
   Current: AndroidTemplateApplication
   Enter new application class name: MyAppApplication

════════════════════════════════════════════════════════════
Summary of Changes
════════════════════════════════════════════════════════════
Package Name:       io.github.kei_1111.androidtemplate → com.example.myapp
Project Name:       android-template → my-app
Plugin ID:          androidtemplate → myapp
Theme Name:         AndroidTemplate → MyApp
Application Class:  AndroidTemplateApplication → MyAppApplication
════════════════════════════════════════════════════════════

Continue with conversion? [y/N]: y
```

### 変更される内容

- **22+ Kotlinソースファイル** - パッケージ宣言とimport文
- **6+ build.gradle.ktsファイル** - namespace、group設定
- **5つのプラグインID定義** - libs.versions.toml内
- **14+ Convention Pluginファイル** - プラグインID参照
- **3つのXMLリソースファイル** - テーマ名、アプリ名
- **2つのスクリプト/ドキュメント** - create-module.sh、README.md
- **ディレクトリ構造** - パッケージフォルダの再編成

### 重要な注意事項

1. **実行は一度だけ**
   - このスクリプトは新規プロジェクト作成時に一度だけ実行します
   - 実行後、スクリプトは自動的に削除されます

2. **実行前の準備**
   - 未コミットの変更がある場合は、事前にコミットしてください
   - 万が一に備えてプロジェクト全体のバックアップを推奨します

3. **実行後の手順**
   - プロジェクトルートディレクトリ名を手動で変更（必要に応じて）
   - Android Studioでプロジェクトを同期
   - `./gradlew clean build` でビルドが通ることを確認
   - README.md を自分のプロジェクト用に更新

### 自動削除機能

このスクリプトは実行完了後、自分自身を自動的に削除します。これにより：
- テンプレートから移行後の不要なファイルが残りません
- 新しいプロジェクトが綺麗な状態に保たれます
- 誤って2回実行してしまうリスクがありません

### トラブルシューティング

**Q: スクリプトの途中でキャンセルしたい**
A: 確認プロンプト（Continue with conversion? [y/N]）で `N` を入力してください。変更は適用されません。

**Q: 変換後にビルドエラーが出る**
A: Android Studioでプロジェクトを同期し、`./gradlew clean build` を実行してください。エラーが続く場合は、パッケージ名の置換が正しく行われているか確認してください。

**Q: ディレクトリ名を変更し忘れた**
A: 以下のコマンドで手動変更できます：
```bash
cd ..
mv 現在のディレクトリ名 新しいディレクトリ名
cd 新しいディレクトリ名
```

## create-module.sh

新しいAndroidモジュールを作成するスクリプトです。

### 使い方

```bash
./scripts/create-module.sh
```

### 機能

1. **モジュールタイプの選択**
   - Core Library (`core:*`) - 基盤となるライブラリモジュール
   - Feature Module (`feature:*`) - 機能単位のモジュール
   - Custom path - カスタムパスでのモジュール作成

2. **自動生成されるファイル**
   - `build.gradle.kts` - モジュールのビルド設定
   - ディレクトリ構造 (`src/main/kotlin`)

3. **自動設定**
   - `settings.gradle.kts` への自動追加
   - 適切なConvention Pluginの適用
   - 正しいパッケージ構造の生成

### 例

#### Core Libraryモジュールの作成

```bash
$ ./scripts/create-module.sh
Select module type:
1) Core Library (core:*)
2) Feature Module (feature:*)
3) Custom path
Enter choice [1-3]: 1

Does this module use Jetpack Compose?
1) Yes - Use android.library.compose
2) No  - Use android.library
Enter choice [1-2]: 2
Enter module name: network

Creating module:
  Path: core/network
  Package: io.github.kei_1111.androidtemplate.core.network
  Plugin: androidtemplate.android.library
Continue? [y/N]: y
```

これにより、以下が作成されます：
- `core/network/build.gradle.kts`
- `core/network/src/main/kotlin/io/github/kei_1111/androidtemplate/core/network/`
- `settings.gradle.kts` に `include(":core:network")` が追加される

**Note**:
- Core Libraryでは、Composeを使う場合は `android.library.compose` が選択されます
- Composeを使わないライブラリ（例: network, database）は `android.library` を選択してください

#### Feature Moduleの作成

```bash
$ ./scripts/create-module.sh
Select module type:
1) Core Library (core:*)
2) Feature Module (feature:*)
3) Custom path
Enter choice [1-3]: 2
Enter module name: login

Creating module:
  Path: feature/login
  Package: io.github.kei_1111.androidtemplate.feature.login
  Plugin: androidtemplate.android.feature
Continue? [y/N]: y
```

### 注意事項

- モジュール名は小文字とハイフンのみ使用してください（例: `auth`, `network-api`）
- 既存のモジュールと同じ名前は使用できません
- スクリプト実行後、Android Studioでプロジェクトを同期してください

### トラブルシューティング

**Q: "Module already exists" エラーが出る**
A: 同じパスにモジュールが既に存在します。別の名前を使用してください。

**Q: Gradle syncでエラーが出る**
A: `settings.gradle.kts` に正しく追加されているか確認してください。必要に応じて手動で修正してください。

**Q: Convention Pluginが見つからない**
A: `build-logic` モジュールに該当するConvention Pluginが定義されているか確認してください。