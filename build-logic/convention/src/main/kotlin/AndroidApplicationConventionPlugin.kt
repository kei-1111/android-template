import com.android.build.api.dsl.ApplicationExtension
import io.github.kei_1111.androidtemplate.configureAndroidCompose
import io.github.kei_1111.androidtemplate.configureAndroidKotlin
import io.github.kei_1111.androidtemplate.implementation
import io.github.kei_1111.androidtemplate.libs
import io.github.kei_1111.androidtemplate.versions
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.configure
import org.gradle.kotlin.dsl.dependencies

class AndroidApplicationConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            with(pluginManager) {
                apply("com.android.application")
                apply("org.jetbrains.kotlin.android")
                apply("org.jetbrains.kotlin.plugin.compose")
                apply("androidtemplate.detekt")
            }

            dependencies {
                implementation(project(":core:designsystem"))
            }

            extensions.configure<ApplicationExtension> {
                configureAndroidKotlin(this)
                configureAndroidCompose(this)

                defaultConfig.targetSdk = libs.versions("targetSdk").toInt()

                packaging.resources.excludes += "/META-INF/{AL2.0,LGPL2.1}"
            }
        }
    }
}