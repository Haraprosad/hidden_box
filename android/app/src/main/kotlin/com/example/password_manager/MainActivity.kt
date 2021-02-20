package com.example.hidden_box
import androidx.annotation.NonNull;
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
GeneratedPluginRegistrant.registerWith(flutterEngine);
}
}
