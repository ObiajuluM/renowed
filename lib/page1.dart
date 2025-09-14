import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ReownAppKitModal _appKitModal;
  @override
  void initState() {
    super.initState();

    _appKitModal = ReownAppKitModal(
      context: context,
      projectId: '288fbb58ea9790bde773e949a76092c3', //
      
      logLevel: LogLevel.all,
      metadata: const PairingMetadata(
        name: 'Example App',
        description: 'Example app description',
        url: 'https://reown.com/',
        icons: ['https://reown.com/logo.png'],
        redirect: Redirect(
          native: 'renowed://',
          universal: 'https://reown.com/exampleapp',
        ),
      ),
    );

    _appKitModal.init().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppKitModalNetworkSelectButton(
              appKit: _appKitModal,
              context: context,
            ),
            AppKitModalConnectButton(appKit: _appKitModal, context: context),
            Visibility(
              visible: _appKitModal.isConnected,
              child: AppKitModalAccountButton(
                // appKit: _appKitModal,
                appKitModal: _appKitModal,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
