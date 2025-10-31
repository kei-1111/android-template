package io.github.kei_1111.androidtemplate

import com.android.build.api.dsl.CommonExtension
import org.gradle.api.JavaVersion
import org.gradle.api.Project
import org.gradle.kotlin.dsl.withType
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile

internal fun Project.configureAndroidKotlin(
    commonExtensions: CommonExtension<*, *, *, *, *, *>
) {
    commonExtensions.apply {
        compileSdk = libs.versions("compileSdk").toInt()

        defaultConfig.minSdk = libs.versions("minSdk").toInt()

        compileOptions {
            sourceCompatibility = JavaVersion.VERSION_21
            targetCompatibility = JavaVersion.VERSION_21
        }
    }

    tasks.withType<KotlinJvmCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_21)
        }
    }
}
