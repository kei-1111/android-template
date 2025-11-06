package io.github.kei_1111.androidtemplate.core.ui.preview

import android.content.res.Configuration
import androidx.compose.ui.tooling.preview.Devices
import androidx.compose.ui.tooling.preview.Preview

@Preview(
    name = "Phone - Light - Standard Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.PHONE,
)
@Preview(
    name = "Phone - Light - Large Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.PHONE,
    fontScale = 1.5f,
)
@Preview(
    name = "Phone - Dark - Standard Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.PHONE,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
)
@Preview(
    name = "Phone - Dark - Large Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.PHONE,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
    fontScale = 1.5f,
)
@Preview(
    name = "Tablet - Light - Standard Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.TABLET,
)
@Preview(
    name = "Tablet - Light - Large Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.TABLET,
    fontScale = 1.5f,
)
@Preview(
    name = "Tablet - Dark - Standard Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.TABLET,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
)
@Preview(
    name = "Tablet - Dark - Large Font",
    showBackground = true,
    showSystemUi = true,
    device = Devices.TABLET,
    uiMode = Configuration.UI_MODE_NIGHT_YES,
    fontScale = 1.5f,
)
annotation class ScreenPreview