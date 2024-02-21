import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usefulmoney/utils/overlays/loading_screen/loading_controller.dart';

class LoadingOverlay {
  static final LoadingOverlay _shared = LoadingOverlay._internal();
  LoadingOverlay._internal();
  factory LoadingOverlay() => _shared;

  LoadingController? controller;

  void show({required BuildContext context, required String text}) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }

  void close() {
    controller?.close();
    controller = null;
  }

  LoadingController showOverlay(
      {required BuildContext context, required String text}) {
    final StreamController<String> textController = StreamController<String>();
    textController.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minHeight: size.height * 0.5,
                minWidth: size.width * 0.5,
              ),
              decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder(
                      stream: textController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final text = snapshot.data as String;
                          return Text(text);
                        } else {
                          return const CircularProgressIndicator.adaptive();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator.adaptive()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    return LoadingController(
      update: (text) {
        textController.add(text);
        return true;
      },
      close: () {
        overlayEntry.remove();
        textController.close();
        return true;
      },
    );
  }
}
