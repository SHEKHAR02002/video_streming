import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:pip_view/pip_view.dart';
import 'package:video_streming/constant.dart';
import 'package:video_streming/home.dart';

class WebViewPage extends ConsumerStatefulWidget {
  const WebViewPage({super.key});

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  late WebViewController webViewController;
  bool landscape = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      initialCorner: PIPViewCorner.bottomRight,
      floatingHeight: 102,
      floatingWidth: 180,
      builder: (context, isFloating) => Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return PopScope(
              canPop: false,
              onPopInvoked: (value) async {
                bool isPip = ref.read(ispipviewProvider);
                if (!isPip) {
                  PIPView.of(context)?.presentBelow(const Home());
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
                    PIPView.of(context)?.dispose();
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
    );
  }
}
