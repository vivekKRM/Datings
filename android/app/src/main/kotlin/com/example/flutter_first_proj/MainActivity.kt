package com.dating

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FacebookSdk.sdkInitialize(applicationContext)
        AppEventsLogger.activateApp(application)
    }
}

