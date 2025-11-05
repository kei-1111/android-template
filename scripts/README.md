# Scripts

このディレクトリには、プロジェクト開発を効率化するスクリプトが含まれています。

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
  Package: com.example.myapp.core.network
  Plugin: androidtemplate.android.library
Continue? [y/N]: y
```

これにより、以下が作成されます：
- `core/network/build.gradle.kts`
- `core/network/src/main/kotlin/com.example.myapp/core/network/`
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
  Package: com.example.myapp.feature.login
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