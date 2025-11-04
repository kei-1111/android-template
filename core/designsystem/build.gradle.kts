plugins {
    alias(libs.plugins.androidtemplate.android.library.compose)
}

android {
    namespace = "io.github.kei_1111.androidtemplate.core.designsystem"
}

dependencies {
    implementation(libs.androidx.material3)
}