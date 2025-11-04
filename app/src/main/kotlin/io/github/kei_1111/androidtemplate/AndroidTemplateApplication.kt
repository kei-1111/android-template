package io.github.kei_1111.androidtemplate

import android.app.Application
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.GlobalContext.startKoin

class AndroidTemplateApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        startKoin {
            androidContext(this@AndroidTemplateApplication)
            // 各モジュールで作成したモジュールを追加
            // modules()
        }
    }
}
