import 'dart:math';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:video_streming/constant.dart';
import 'package:video_streming/home.dart';

class FloatingDemo extends ConsumerStatefulWidget {
  const FloatingDemo({super.key});

  @override
  ConsumerState<FloatingDemo> createState() => _FloatingDemoState();
}

class _FloatingDemoState extends ConsumerState<FloatingDemo>
    with WidgetsBindingObserver {
  final floating = Floating();

  late WebViewController webViewController;
  bool landscape = true;

  Future<void> enablePip(BuildContext context) async {
    const rational = Rational.landscape();
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final status = await floating.enable(
      aspectRatio: rational,
      sourceRectHint: Rectangle<int>(
        0,
        (screenSize.height ~/ 2) - (height ~/ 2),
        screenSize.width.toInt(),
        height,
      ),
    );
    debugPrint('PiP enabled? $status');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenDisabled: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return PopScope(
              canPop: false,
              onPopInvoked: (value) async {
          
                bool isPip = ref.read(ispipviewProvider);
                if (!isPip) {
                  enablePip(context);
                  if (orientation == Orientation.landscape) {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                    setState(() {
                      landscape = false;
                    });
                  }
                  ref.watch(ispipviewProvider.notifier).state = true;
                } else {
                  if (orientation == Orientation.landscape) {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                    setState(() {
                      landscape = false;
                    });
                  }
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false);
                  ref.watch(ispipviewProvider.notifier).state = false;
                }
              },
              child: Center(
                child: Container(
                  height: landscape ? MediaQuery.of(context).size.height : 300,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: WebView(
                    initialUrl:
                        'https://iframe.mediadelivery.net/embed/203818/a6213d17-8610-4129-be76-6d4ffc7b07a7',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController controller) {
                      webViewController = controller;
                    },
                    zoomEnabled: false,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      childWhenEnabled: Center(
        child: Container(
          height: landscape ? MediaQuery.of(context).size.height : 300,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            initialUrl:
                'https://iframe.mediadelivery.net/embed/203818/a6213d17-8610-4129-be76-6d4ffc7b07a7',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              webViewController = controller;
            },
            zoomEnabled: false,
          ),
        ),
      ),
    );
  }
}
