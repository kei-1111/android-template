# Android Template

[English](#english) | [日本語](#japanese)

---

<a name="english"></a>

## English

### Overview

A modern and scalable Android application template. Provides production-ready multi-module environment, best practices, automated tooling, and comprehensive development utilities.

**Design Philosophy:**
- Flexible architecture supporting both standalone Android projects and KMP (Kotlin Multiplatform) library integration
- Modern tech stack with Jetpack Compose
- Comprehensive development tooling and automation
- Accessibility-first approach with built-in preview support

### Features

#### 🏗️ Modern Architecture
- **Modular Structure**: Clean separation with `app`, `core`, and `feature` modules
- **Convention Plugins**: Reusable Gradle configuration with type-safe accessors
- **Build Optimization**: Parallel execution, configuration cache, and optimized R classes

#### 🔧 Developer Tools
- **Automation Scripts**:
  - `convert-project.sh` - Convert template to your project
  - `create-module.sh` - Generate new modules interactively
- **Code Quality**: Detekt with Compose rules and auto-formatting
- **CI/CD**: GitHub Actions workflows for testing and static analysis

#### 🧩 UI Components
- **Design System Module** (`core:designsystem`): Theme and styling
- **UI Module** (`core:ui`): Reusable components and utilities
  - `DebouncedClickable` - Prevents double-click issues
  - Preview annotations for screens and components

#### 📱 Preview System

Two types of preview annotations for efficient UI development:

**PreviewScreen** - For screen-level composables (8 previews)
- Light/Dark themes × Phone/Tablet devices × Standard/Large font scales
- Shows system UI and device frames
- Ensures responsive design and accessibility

**PreviewComponent** - For component-level composables (4 previews)
- Light/Dark themes × Standard/Large font scales
- Quick preview without device frames
- Focuses on component behavior

### Tech Stack

- **Kotlin**: 2.2.21
- **Gradle**: 8.13 with version catalogs
- **Android Gradle Plugin**: 8.12.3
- **Compose BOM**: 2025.10.01
- **Min SDK**: 29 (Android 10)
- **Target SDK**: 36
- **Dependency Injection**: Koin 4.1.1
- **Serialization**: Kotlinx Serialization 1.9.0
- **Code Quality**: Detekt 1.23.8 with Compose rules

### Quick Start

#### 1. Create Repository from Template

Create a new repository from this template on GitHub:

1. Click the **"Use this template"** button at the top of this repository
2. Choose **"Create a new repository"**
3. Enter your repository name and settings
4. Click **"Create repository"**
5. Clone your new repository locally:
   ```bash
   git clone git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
   cd YOUR_REPO_NAME
   ```

#### 2. Convert to Your Project

Run the conversion script to customize the template:

```bash
./scripts/convert-project.sh
```

The script will interactively ask for:
- Package name (e.g., `com.example.myapp`)
- Project name (e.g., `my-app`)
- Convention plugin ID (e.g., `myapp`)
- Theme name (e.g., `MyApp`)
- Application class name (e.g., `MyAppApplication`)

#### 3. Sync and Build

Open the project in Android Studio and sync Gradle:

```bash
./gradlew clean build
```

#### 4. Start Developing

Create new modules using the module creation script:

```bash
./scripts/create-module.sh
```

### Project Structure

```
android-template/
├── app/                          # Main application module
├── core/
│   ├── designsystem/            # Theme, colors, typography
│   └── ui/                      # Reusable UI components and previews
├── build-logic/                 # Convention plugins
│   └── convention/              # Gradle convention plugins
├── config/                      # Configuration files (Detekt)
├── scripts/                     # Automation scripts
├── .github/workflows/           # CI/CD workflows
└── gradle/                      # Gradle wrapper and version catalog
```

### Convention Plugins

Custom Gradle plugins for consistent module configuration:

| Plugin | Purpose | Usage |
|--------|---------|-------|
| `androidtemplate.android.application` | App module setup | Main application |
| `androidtemplate.android.library` | Basic library module | Data, domain layers |
| `androidtemplate.android.library.compose` | Compose library module | UI libraries with Compose |
| `androidtemplate.android.feature` | Feature module setup | Feature modules |
| `androidtemplate.detekt` | Static analysis | Code quality checks |

### Available Scripts

#### `convert-project.sh`
Converts the template to your project with custom naming. **Run once** when starting a new project.

```bash
./scripts/convert-project.sh
```

#### `create-module.sh`
Interactively creates new modules with proper package structure.

```bash
./scripts/create-module.sh
```

Options:
- Core Library (compose/non-compose)
- Feature Module
- Custom path

### CI/CD

Two GitHub Actions workflows are included:

- **Test Workflow** (`.github/workflows/test.yml`) - Runs on PR/push
  - Unit tests with coverage
  - Test reports uploaded as artifacts

- **Detekt Workflow** (`.github/workflows/detekt.yml`) - Static analysis
  - Code quality checks
  - Compose-specific rules

### Development Guide

#### Creating a New Feature

1. Create a feature module:
   ```bash
   ./scripts/create-module.sh
   ```
   Select "Feature Module" option.

2. Add dependencies in the module's `build.gradle.kts`

#### Adding Dependencies

Edit `gradle/libs.versions.toml` for centralized dependency management:

```toml
[versions]
mylib = "1.0.0"

[libraries]
mylib = { group = "com.example", name = "mylib", version.ref = "mylib" }
```

Then use in modules:
```kotlin
dependencies {
    implementation(libs.mylib)
}
```

#### Code Quality

Run Detekt before committing:

```bash
./gradlew detekt
```

### Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

---

<a name="japanese"></a>

## 日本語

### 概要

モダンでスケーラブルなAndroidアプリケーションテンプレート。本番環境で使用可能なマルチモジュール環境、ベストプラクティス、自動化ツール、包括的な開発ユーティリティを提供します。

**設計思想：**
- 単体のAndroidプロジェクトとKMP（Kotlin Multiplatform）ライブラリ統合の両方に対応できる柔軟なアーキテクチャ
- Jetpack Composeを使用したモダンな技術スタック
- 包括的な開発ツールと自動化
- アクセシビリティファーストのアプローチとプレビューサポート

### 主な機能

#### 🏗️ モダンなアーキテクチャ
- **モジュール構造**: `app`、`core`、`feature`モジュールによる明確な分離
- **Convention Plugins**: 型安全なアクセサによる再利用可能なGradle設定
- **ビルド最適化**: 並列実行、設定キャッシュ、最適化されたRクラス

#### 🔧 開発者ツール
- **自動化スクリプト**:
  - `convert-project.sh` - テンプレートをプロジェクトに変換
  - `create-module.sh` - 対話的に新規モジュールを生成
- **コード品質**: Composeルールと自動フォーマット対応のDetekt
- **CI/CD**: テストと静的解析用のGitHub Actionsワークフロー

#### 🧩 UIコンポーネント
- **Design Systemモジュール** (`core:designsystem`): テーマとスタイリング
- **UIモジュール** (`core:ui`): 再利用可能なコンポーネントとユーティリティ
  - `DebouncedClickable` - ダブルクリック防止
  - 画面とコンポーネント用のプレビューアノテーション

#### 📱 プレビューシステム

効率的なUI開発のための2種類のプレビューアノテーション：

**PreviewScreen** - 画面レベルのComposable用（8パターン）
- ライト/ダークテーマ × スマホ/タブレット × 標準/大フォント
- システムUIとデバイスフレームを表示
- レスポンシブデザインとアクセシビリティを確保

**PreviewComponent** - コンポーネントレベルのComposable用（4パターン）
- ライト/ダークテーマ × 標準/大フォント
- デバイスフレームなしの素早いプレビュー
- コンポーネントの動作に焦点

### 技術スタック

- **Kotlin**: 2.2.21
- **Gradle**: 8.13（バージョンカタログ使用）
- **Android Gradle Plugin**: 8.12.3
- **Compose BOM**: 2025.10.01
- **Min SDK**: 29（Android 10）
- **Target SDK**: 36
- **依存性注入**: Koin 4.1.1
- **シリアライゼーション**: Kotlinx Serialization 1.9.0
- **コード品質**: Detekt 1.23.8（Composeルール含む）

### クイックスタート

#### 1. テンプレートからリポジトリを作成

GitHubでこのテンプレートから新しいリポジトリを作成：

1. このリポジトリの上部にある **"Use this template"** ボタンをクリック
2. **"Create a new repository"** を選択
3. リポジトリ名と設定を入力
4. **"Create repository"** をクリック
5. 新しいリポジトリをローカルにクローン：
   ```bash
   git clone git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
   cd YOUR_REPO_NAME
   ```

#### 2. プロジェクトに変換

変換スクリプトを実行してテンプレートをカスタマイズ：

```bash
./scripts/convert-project.sh
```

スクリプトは以下を対話的に入力させます：
- パッケージ名（例：`com.example.myapp`）
- プロジェクト名（例：`my-app`）
- Convention plugin ID（例：`myapp`）
- テーマ名（例：`MyApp`）
- Applicationクラス名（例：`MyAppApplication`）

#### 3. 同期とビルド

Android Studioでプロジェクトを開き、Gradleを同期：

```bash
./gradlew clean build
```

#### 4. 開発開始

モジュール作成スクリプトで新しいモジュールを作成：

```bash
./scripts/create-module.sh
```

### プロジェクト構造

```
android-template/
├── app/                          # メインアプリケーションモジュール
├── core/
│   ├── designsystem/            # テーマ、カラー、タイポグラフィ
│   └── ui/                      # 再利用可能なUIコンポーネントとプレビュー
├── build-logic/                 # Convention plugins
│   └── convention/              # Gradle convention plugins
├── config/                      # 設定ファイル（Detekt）
├── scripts/                     # 自動化スクリプト
├── .github/workflows/           # CI/CDワークフロー
└── gradle/                      # Gradleラッパーとバージョンカタログ
```

### Convention Plugins

一貫したモジュール設定のためのカスタムGradleプラグイン：

| プラグイン | 用途 | 使用場所 |
|--------|---------|-------|
| `androidtemplate.android.application` | アプリモジュール設定 | メインアプリケーション |
| `androidtemplate.android.library` | 基本ライブラリモジュール | データ、ドメイン層 |
| `androidtemplate.android.library.compose` | Composeライブラリモジュール | Compose使用のUIライブラリ |
| `androidtemplate.android.feature` | フィーチャーモジュール設定 | 機能モジュール |
| `androidtemplate.detekt` | 静的解析 | コード品質チェック |

### 利用可能なスクリプト

#### `convert-project.sh`
カスタム名でテンプレートをプロジェクトに変換します。新規プロジェクト開始時に**1回だけ実行**します。

```bash
./scripts/convert-project.sh
```

#### `create-module.sh`
適切なパッケージ構造で新しいモジュールを対話的に作成します。

```bash
./scripts/create-module.sh
```

オプション：
- Coreライブラリ（Compose有/無）
- Featureモジュール
- カスタムパス

### CI/CD

2つのGitHub Actionsワークフローが含まれています：

- **テストワークフロー** (`.github/workflows/test.yml`) - PR/push時に実行
  - カバレッジ付きユニットテスト
  - テストレポートをアーティファクトとしてアップロード

- **Detektワークフロー** (`.github/workflows/detekt.yml`) - 静的解析
  - コード品質チェック
  - Compose固有のルール

### 開発ガイド

#### 新しい機能の作成

1. フィーチャーモジュールを作成：
   ```bash
   ./scripts/create-module.sh
   ```
   「Feature Module」オプションを選択。

2. モジュールの`build.gradle.kts`に依存関係を追加


#### 依存関係の追加

一元管理のため`gradle/libs.versions.toml`を編集：

```toml
[versions]
mylib = "1.0.0"

[libraries]
mylib = { group = "com.example", name = "mylib", version.ref = "mylib" }
```

モジュールで使用：
```kotlin
dependencies {
    implementation(libs.mylib)
}
```

#### コード品質

コミット前にDetektを実行：

```bash
./gradlew detekt
```

### コントリビューション

コントリビューションを歓迎します！IssueやPull Requestをお気軽に提出してください。

---

## Documentation

- [Scripts Documentation](scripts/README.md) - Detailed script usage
- [Workflows Documentation](.github/workflows/README.md) - CI/CD setup

## Links

- [Issues](https://github.com/kei-1111/android-template/issues)
- [Pull Requests](https://github.com/kei-1111/android-template/pulls)