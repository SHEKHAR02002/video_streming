import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:video_streming/floatingdemo.dart';
import 'package:video_streming/sizedconflig.dart';
import 'package:video_streming/webviewpage.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late WebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WebViewPage())),
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  'https://cdn.pixabay.com/photo/2013/07/13/11/45/play-158609_960_720.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: SizeConfig.blockSizeVertical! * 25,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.grey.shade300,
                      height: SizeConfig.blockSizeVertical! * 15,
                      width: SizeConfig.blockSizeHorizontal! * 30,
                    );
                  }),
            )

            // ElevatedButton(
            //     onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const FloatingDemo())),
            //     child: const Text("Test"))
          ],
        ),
      ),
    );
  }
}
