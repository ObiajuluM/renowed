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
      logLevel: LogLevel.all,
      projectId: '288fbb58ea9790bde773e949a76092c3',
      metadata: const PairingMetadata(
        name: 'Example App',
        description: 'Example app description',
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'exampleapp://',
          universal: 'https://reown.com/exampleapp',
        ),
      ),
      siweConfig: SIWEConfig(
        getNonce: () async {
          return SIWEUtils.generateNonce();
        },
        getMessageParams: () async {
          return SIWEMessageArgs(
            domain: Uri.parse(_appKitModal.appKit!.metadata.url).authority,
            uri: _appKitModal.appKit!.metadata.url,
            statement: '{Your custom message here}',
            methods: MethodsConstants.allMethods,
          );
        },
        createMessage: (SIWECreateMessageArgs args) {
          return SIWEUtils.formatMessage(args);
        },
        verifyMessage: (SIWEVerifyMessageArgs args) async {
          final chainId = SIWEUtils.getChainIdFromMessage(args.message);
          final address = SIWEUtils.getAddressFromMessage(args.message);
          final cacaoSignature = args.cacao != null
              ? args.cacao!.s
              : CacaoSignature(t: CacaoSignature.EIP191, s: args.signature);
          return await SIWEUtils.verifySignature(
            address,
            args.message,
            cacaoSignature,
            chainId,
            "288fbb58ea9790bde773e949a76092c3",
          );
        },
        getSession: () async {
          final chainId = _appKitModal.selectedChain?.chainId ?? '1';
          final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(
            chainId,
          );
          final address = _appKitModal.session!.getAddress(namespace)!;
          return SIWESession(address: address, chains: [chainId]);
        },
        signOut: () async {
          return true;
        },
      ),
    );

    _appKitModal.init().then((_) {
      setState(() {});
      _appKitModal.onModalConnect.subscribe((ModalConnect? event) {
        print("object");
      });

      _appKitModal.onModalUpdate.subscribe((ModalConnect? event) {
        print("objectd");
      });

      _appKitModal.onModalNetworkChange.subscribe((ModalNetworkChange? event) {
        print("objects");
      });

      _appKitModal.onModalDisconnect.subscribe((ModalDisconnect? event) {
        print("objecet");
      });

      _appKitModal.onModalError.subscribe((ModalError? event) {
        print("objeceter");
      });

      setState(() {});
    });
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
            ElevatedButton(
              onPressed: () async {
                await _appKitModal.openModalView();
              },
              child: Text("data"),
            ),
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
