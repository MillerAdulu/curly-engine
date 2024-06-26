import 'dart:typed_data';

import 'package:dot_document/dot_document.dart';
import 'package:dot_face_lite/dot_face_lite.dart';
import 'package:flutter/material.dart';

import 'document_auto_capture/document_auto_capture_screen.dart';
import 'face_auto_capture/face_auto_capture_screen.dart';
import 'magnifeye_liveness/magnifeye_liveness_screen.dart';
import 'page_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<void> _initDotSdk;

  @override
  void initState() {
    super.initState();
    _initDotSdk = initDotSdkAsync();
  }

  Future<void> initDotSdkAsync() async {
    if (await DotSdk.instance.isInitialized()) {
      return;
    }

    final ByteData licenseByteData =
        await DefaultAssetBundle.of(context).load('assets/licenses/iengine.lic');
    await DotSdk.instance.initialize(DotSdkConfiguration(
        licenseBytes: licenseByteData.buffer.asUint8List(),
        libraries: [DotDocumentLibrary(), DotFaceLiteLibrary()]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DOT SDK Example'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: FutureBuilder(
            future: _initDotSdk,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return createLicenseError();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return createComponentList(context);
              } else {
                return createProgress();
              }
            },
          ),
        ));
  }

  Widget createLicenseError() {
    return Text('License file is not valid.');
  }

  Widget createProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget createComponentList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _createComponent(
            title: 'Document Auto Capture',
            subtitle: 'Basic component sample.',
            onPressed: () {
              Navigator.of(context).push(
                  createRouteWithoutAnimation(DocumentAutoCaptureScreen()));
            }),
        _createComponent(
            title: 'Face Auto Capture',
            subtitle: 'Basic component sample.',
            onPressed: () {
              Navigator.of(context)
                  .push(createRouteWithoutAnimation(FaceAutoCaptureScreen()));
            }),
        _createComponent(
            title: 'MagnifEye Liveness',
            subtitle: 'Basic component sample.',
            onPressed: () {
              Navigator.of(context)
                  .push(createRouteWithoutAnimation(MagnifEyeLivenessScreen()));
            }),
      ],
    );
  }

  Widget _createComponent(
      {required String title,
      required String subtitle,
      VoidCallback? onPressed}) {
    return Container(
        width: double.infinity,
        child: Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing:
                ElevatedButton(onPressed: onPressed, child: Text('Start')),
          ),
        ));
  }
}
