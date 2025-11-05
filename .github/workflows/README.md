# GitHub Actions Workflows

このディレクトリには、プロジェクトのCI/CDワークフローが含まれています。

## detekt.yml

静的コード解析ツール「Detekt」を実行するワークフローです。

### トリガー

- `main` ブランチへのプッシュ
- すべてのブランチへのプルリクエスト（作成時・更新時・再オープン時）
  - PRを作成したとき
  - PRに新しいコミットをプッシュしたとき
  - PRを再オープンしたとき

### 実行内容

1. **環境セットアップ**
   - Ubuntu最新版で実行
   - JDK 21をインストール
   - Gradleキャッシュの設定

2. **Detekt実行**
   - `./gradlew detekt` を実行
   - コードスタイルと潜在的なバグをチェック

3. **レポート生成**
   - HTMLレポートをArtifactとしてアップロード
   - 7日間保存される
   - GitHub ActionsのUIからダウンロード可能

4. **結果チェック**
   - エラーが見つかった場合、ワークフローが失敗

### レポートの確認方法

1. GitHub Actionsのワークフロー実行ページにアクセス
2. 「Artifacts」セクションから `detekt-reports` をダウンロード
3. HTMLファイルをブラウザで開いて詳細を確認

### ローカルでの実行

ワークフローと同じチェックをローカルで実行する場合：

```bash
./gradlew detekt
```

レポートの場所：
- HTML: `<module>/build/reports/detekt/detekt.html`
- XML: `<module>/build/reports/detekt/detekt.xml`

### カスタマイズ

#### タイムアウト時間の変更

```yaml
timeout-minutes: 15  # デフォルトは15分
```

#### トリガーブランチの追加

```yaml
on:
  push:
    branches:
      - main
      - develop  # 追加
```

#### 自動修正の有効化

Detektに自動修正を実行させる場合：

```yaml
- name: Run Detekt with auto-correct
  run: ./gradlew detekt --auto-correct

- name: Commit auto-corrections
  if: github.event_name == 'pull_request'
  run: |
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    git add -A
    git diff --staged --quiet || git commit -m "style: Apply Detekt auto-corrections"
    git push
```

### トラブルシューティング

**Q: ワークフローが失敗する**
A: Detektで問題が見つかった場合です。レポートを確認して修正してください。

**Q: キャッシュが効かない**
A: `cache-read-only` の設定を確認してください。mainブランチでは書き込み可能、それ以外は読み取り専用です。

**Q: JDKバージョンを変更したい**
A: `java-version` を変更してください。プロジェクトではJDK 21を使用しています。

## test.yml

ユニットテストを実行するワークフローです。

### トリガー

- `main` ブランチへのプッシュ
- すべてのブランチへのプルリクエスト（作成時・更新時・再オープン時）
  - PRを作成したとき
  - PRに新しいコミットをプッシュしたとき
  - PRを再オープンしたとき

### 実行内容

1. **環境セットアップ**
   - Ubuntu最新版で実行
   - JDK 21をインストール
   - Gradleキャッシュの設定

2. **ユニットテスト実行**
   - `./gradlew test` を実行
   - 全モジュールのテストを実行（app, core:designsystem, core:ui）

3. **レポート生成**
   - テストレポート（HTML）をArtifactとしてアップロード
   - テスト結果（XML）をArtifactとしてアップロード
   - 7日間保存される
   - GitHub ActionsのUIからダウンロード可能

4. **結果チェック**
   - テストが失敗した場合、ワークフローが失敗
   - テストが存在しない場合は警告を表示（失敗にはならない）

### レポートの確認方法

1. GitHub Actionsのワークフロー実行ページにアクセス
2. 「Artifacts」セクションから以下をダウンロード
   - `test-reports`: HTMLレポート
   - `test-results`: XMLレポート
3. HTMLファイルをブラウザで開いて詳細を確認

### ローカルでの実行

ワークフローと同じテストをローカルで実行する場合：

```bash
./gradlew test
```

特定のモジュールのみ実行：

```bash
./gradlew :app:test
./gradlew :core:designsystem:test
./gradlew :core:ui:test
```

レポートの場所：
- HTML: `<module>/build/reports/tests/test/index.html`
- XML: `<module>/build/test-results/test/*.xml`

### カスタマイズ

#### タイムアウト時間の変更

```yaml
timeout-minutes: 15  # デフォルトは15分
```

#### テストオプションの追加

並列実行を有効化する場合：

```yaml
- name: Run unit tests
  run: ./gradlew test --parallel --max-workers=4
```

#### カバレッジレポートの追加

JaCoCoなどのカバレッジツールを使用する場合：

```yaml
- name: Run tests with coverage
  run: ./gradlew test jacocoTestReport

- name: Upload coverage reports
  uses: actions/upload-artifact@v4
  with:
    name: coverage-reports
    path: '**/build/reports/jacoco/**'
```

### トラブルシューティング

**Q: ワークフローが失敗する**
A: テストが失敗している可能性があります。レポートを確認して修正してください。

**Q: テストが見つからないと表示される**
A: テストファイルがまだ作成されていません。`src/test/java` または `src/test/kotlin` にテストを追加してください。

**Q: 特定のテストのみ実行したい**
A: ワークフローファイルの `./gradlew test` を `./gradlew :app:test` などに変更してください。