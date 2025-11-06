package io.github.kei_1111.androidtemplate.core.ui.preview

import android.content.res.Configuration
import androidx.compose.ui.tooling.preview.Preview

@Preview(
    name = "Light - Standard Font",
    showBackground = true,
)
@Preview(
    name = "Light - Large Font",
    showBackground = true,
    fontScale = 1.5f,
)
@Preview(
    name = "Dark - Standard Font",
    showBackground = true,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
)
@Preview(
    name = "Dark - Large Font",
    showBackground = true,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
    fontScale = 1.5f,
)
annotation class PreviewComponent
