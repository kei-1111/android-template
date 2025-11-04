import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile

plugins {
    `kotlin-dsl`
}

group = "io.github.kei_1111.androidtemplate.buildlogic"

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

tasks.withType<KotlinJvmCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_21)
    }
}

dependencies {
    compileOnly(libs.android.gradle)
    compileOnly(libs.detekt.gradle)
    compileOnly(libs.kotlin.gradle)
}

gradlePlugin {
    plugins {
        register("androidApplication") {
            id = libs.plugins.androidtemplate.android.application.get().pluginId
            implementationClass = "AndroidApplicationConventionPlugin"
        }
        register("androidLibrary") {
            id = libs.plugins.androidtemplate.android.library.asProvider().get().pluginId
            implementationClass = "AndroidLibraryConventionPlugin"
        }
        register("androidLibraryCompose") {
            id = libs.plugins.androidtemplate.android.library.compose.get().pluginId
            implementationClass = "AndroidLibraryComposeConventionPlugin"
        }
        register("detekt") {
            id = libs.plugins.androidtemplate.detekt.get().pluginId
            implementationClass = "DetektConventionPlugin"
        }
    }
}