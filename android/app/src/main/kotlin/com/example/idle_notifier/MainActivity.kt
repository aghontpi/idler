package com.example.idle_notifier

import android.view.ViewGroup
import android.view.Window
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
   private val TAG = "MainActivity"
   private val CHANNEL = "android-communication-channel"


    override fun getWindow(): Window {
        var window = super.getWindow()
        window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,900)
        return window
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            when(call.method) {
                "notify" -> {
                    Log.v(TAG,"arguments ${call.arguments}")
                }
            }

            Log.v(TAG, "dart to android-native :: channel call")
        }
    }
}
