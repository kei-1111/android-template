@file:Suppress("MagicNumber")

package io.github.kei_1111.androidtemplate.core.ui.provider

import android.os.SystemClock
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.runtime.staticCompositionLocalOf

@Composable
fun DebouncedClickProvider(
    debounceMillis: Long = 500L,
    content: @Composable () -> Unit,
) {
    val debounceClicker = remember(debounceMillis) { DebounceClicker(debounceMillis) }
    CompositionLocalProvider(LocalDebounceClicker provides debounceClicker) {
        content()
    }
}

class DebounceClicker(private val debounceMillis: Long) {
    private var lastClickTime = 0L
    fun processClick(action: () -> Unit) {
        val currentTime = SystemClock.uptimeMillis()
        if (currentTime - lastClickTime >= debounceMillis) {
            lastClickTime = currentTime
            action()
        }
    }
}

@Suppress("CompositionLocalAllowlist")
val LocalDebounceClicker = staticCompositionLocalOf<DebounceClicker> { DebounceClicker(500L) }
