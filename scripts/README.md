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

## remove-git.sh

Git設定（`.git`ディレクトリ）を削除し、Gitの履歴をクリーンな状態にするスクリプトです。テンプレートから新しいプロジェクトを作成し、独自のGit履歴を開始したい場合に使用します。

### 使い方

```bash
./scripts/remove-git.sh
```

### 機能

このスクリプトは以下の操作を対話形式で行います：

1. **現在のGit情報の表示**
   - リモートリポジトリURL
   - 現在のブランチ名
   - 総コミット数
   - 最新コミット情報

2. **Git設定の削除**
   - `.git`ディレクトリの完全削除
   - すべてのGit履歴の削除
   - ブランチ情報の削除
   - リモートリポジトリ接続情報の削除

3. **次のステップのガイダンス**
   - 新しいGitリポジトリの初期化方法
   - リモートリポジトリの追加方法
   - 初回コミットの方法

### 実行フロー

```bash
$ ./scripts/remove-git.sh

╔════════════════════════════════════════════════════════════╗
║   Git Configuration Removal Script                        ║
╔════════════════════════════════════════════════════════════╗

Current Git repository information:

Remote repositories:
  origin  git@github.com:kei-1111/android-template.git (fetch)
  origin  git@github.com:kei-1111/android-template.git (push)

Current branch: main

Total commits: 42

Last commit:
  2d9b3f6 fix: convert-project.shでApplicationクラス名が正しくリネームされない問題を修正 v2

════════════════════════════════════════════════════════════
Warning: This action will:
  • Delete the entire .git directory
  • Remove all Git history and commits
  • Remove all branch information
  • Remove all remote repository connections

This action will NOT:
  • Delete .gitignore or other Git-related files
  • Delete any of your project source files

⚠ This action cannot be undone!
════════════════════════════════════════════════════════════

Are you sure you want to remove Git configuration? [y/N]: y

Removing Git configuration...

Deleting .git directory...
✓ .git directory removed successfully

════════════════════════════════════════════════════════════
✓ Git configuration removed successfully!
════════════════════════════════════════════════════════════

Next steps:
  1. Initialize a new Git repository (if needed):
     git init
  2. Add your remote repository:
     git remote add origin <your-repository-url>
  3. Make your initial commit:
     git add .
     git commit -m "Initial commit"
  4. Push to remote repository:
     git branch -M main
     git push -u origin main

Removing this script...
✓ Script removed
```

### 削除されるもの

- `.git` ディレクトリ（すべてのGit履歴、ブランチ、リモート情報）

### 保持されるもの

- `.gitignore` ファイル
- `.gitattributes` などのGit関連設定ファイル
- すべてのプロジェクトソースコード

### 重要な注意事項

1. **元に戻せない操作**
   - このスクリプトの実行は取り消しできません
   - 削除前に重要なコミットをバックアップしてください
   - 必要に応じてリモートリポジトリにpushしておいてください

2. **実行タイミング**
   - テンプレートから新しいプロジェクトを作成した直後
   - 独自のGit履歴を開始したいとき
   - `convert-project.sh`実行後に実行するのが一般的です

3. **実行後の手順**
   - 新しいGitリポジトリを初期化（`git init`）
   - 自分のリモートリポジトリを設定
   - 初回コミットを作成

### 自動削除機能

このスクリプトは実行完了後、自分自身を自動的に削除します。これにより：
- プロジェクトに不要なスクリプトが残りません
- 新しいプロジェクトが綺麗な状態に保たれます
- 誤って2回実行してしまうリスクがありません

### トラブルシューティング

**Q: スクリプトの途中でキャンセルしたい**
A: 確認プロンプト（Are you sure...? [y/N]）で `N` を入力してください。`.git`ディレクトリは削除されません。

**Q: .gitディレクトリが存在しない場合**
A: スクリプトは警告メッセージを表示して正常終了します。エラーにはなりません。

**Q: 削除後に元のGit履歴を復元したい**
A: `.git`ディレクトリを削除すると復元できません。実行前にプロジェクト全体のバックアップを取ることを強く推奨します。

### 使用例

#### テンプレートから新規プロジェクトを作成する場合

```bash
# 1. プロジェクトの変換
./scripts/convert-project.sh

# 2. Git履歴のクリーンアップ
./scripts/remove-git.sh

# 3. 新しいGitリポジトリの初期化
git init
git add .
git commit -m "Initial commit"

# 4. リモートリポジトリへのプッシュ
git remote add origin <your-repository-url>
git branch -M main
git push -u origin main
```