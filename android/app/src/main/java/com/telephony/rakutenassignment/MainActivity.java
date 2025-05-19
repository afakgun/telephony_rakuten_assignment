package com.telephony.rakutenassignment;
import android.os.Build;
import android.telecom.TelecomManager;
import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.telephony.rakutenassignment/end_call";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
      .setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("endCall")) {
            boolean success = endCall();
            result.success(success);
          }
        }
      );
  }

  private boolean endCall() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      TelecomManager telecomManager = (TelecomManager) getSystemService(Context.TELECOM_SERVICE);
      if (telecomManager != null && checkSelfPermission(android.Manifest.permission.ANSWER_PHONE_CALLS) == android.content.pm.PackageManager.PERMISSION_GRANTED) {
        return telecomManager.endCall();
      }
    }
    return false;
  }
}