# 命名規則 (Naming Conventions)

このドキュメントは、このテンプレートプロジェクト固有の命名規則を定義します。

---

## ConventionPlugin

自作プラグインはプロジェクト固有の命名であるため他のプラグインとの命名差別化を図るためにConventionPluginをSuffixにつける

**実装クラス命名パターン**: `Android<Type>ConventionPlugin`

**例**:
- `AndroidApplicationConventionPlugin`
- `AndroidLibraryConventionPlugin`
- `AndroidLibraryComposeConventionPlugin`
- `AndroidFeatureConventionPlugin`
- `DetektConventionPlugin`

**Plugin ID命名パターン**: `<prefix>.<type>.<subtype>`

**例**:
- `androidtemplate.android.application`
- `androidtemplate.android.library`
- `androidtemplate.android.library.compose`
- `androidtemplate.android.feature`
- `androidtemplate.detekt`

---

## パッケージ名

プロジェクト名がmy-appであればパッケージ名はハイフンを除いたmyappとする

**ベースパッケージ**: `io.github.kei_1111.androidtemplate`

**サブパッケージ構造**:
```
io.github.kei_1111.androidtemplate
├── app
├── core
│   ├── designsystem.theme
│   ├── ui.modifier
│   ├── ui.preview
│   └── ui.provider
└── feature (今後の追加用)
```

---

## モジュール命名

**Coreモジュールパターン**: `core:<module-name>`
- 例: `core:designsystem`, `core:ui`

**Featureモジュールパターン**: `feature:<module-name>`
- 例: `feature:home`, `feature:settings`

**Appモジュール**: `app`

**settings.gradle.kts での記述例**:
```kotlin
include(":app")
include(":core:designsystem")
include(":core:ui")
```

---

## バージョンカタログ

- versionsはキャメルケース
- librariesはケバブケース
- pluginｓはケバブケース

**例**:
```toml
[versions]
androidGradlePlugin = "8.12.3"
kotlin = "2.2.21"

[libraries]
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version.ref = "androidxCore" }

[plugins]
android-application = { id = "com.android.application", version.ref = "androidGradlePlugin" }
```

---

## Composable関数

**Theme関数命名**: `<ProjectName>Theme`
- 例: `AndroidTemplateTheme`

**Screen関数命名**: `<FeatureName>Screen`
- 例: `HomeScreen`, `ProfileDetailScreen`

---

## Applicationクラス

**命名パターン**: `<ProjectName>Application`
- 例: `AndroidTemplateApplication`

---

## スクリプト

**命名パターン**: ケバブケース + `.sh`
- `convert-project.sh`
- `create-module.sh`