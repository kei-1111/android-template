package io.github.kei_1111.androidtemplate.core.ui.modifier

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.Indication
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.Role
import io.github.kei_1111.androidtemplate.core.ui.provider.LocalDebounceClicker

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun Modifier.debouncedClickable(
    indication: Indication? = ripple(),
    enabled: Boolean = true,
    onClickLabel: String? = null,
    role: Role? = null,
    onClick: () -> Unit,
): Modifier {
    val debounceClicker = LocalDebounceClicker.current
    val interactionSource = remember { MutableInteractionSource() }
    return this then Modifier.clickable(
        interactionSource = interactionSource,
        indication = indication,
        enabled = enabled,
        onClickLabel = onClickLabel,
        role = role,
        onClick = { debounceClicker.processClick(onClick) },
    )
}
