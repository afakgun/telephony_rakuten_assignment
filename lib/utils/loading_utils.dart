import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingUtils {
  static OverlayEntry? _overlayEntry;

  static void startLoading(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(16),
              child: Lottie.asset(
                'assets/lottie/loading.json',
                fit: BoxFit.contain,
                repeat: true,
                frameRate: FrameRate(60),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  static void stopLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
