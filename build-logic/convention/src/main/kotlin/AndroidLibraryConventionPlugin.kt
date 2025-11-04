import com.android.build.gradle.LibraryExtension
import io.github.kei_1111.androidtemplate.configureAndroidKotlin
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.configure

class AndroidLibraryConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            with(pluginManager) {
                apply("com.android.library")
                apply("org.jetbrains.kotlin.android")
                apply("androidtemplate.detekt")
            }

            extensions.configure<LibraryExtension> {
                configureAndroidKotlin(this)

                defaultConfig.consumerProguardFiles("consumer-rules.pro")
            }
        }
    }
}