import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mca_flutter_sdk/src/services/services.dart';
import 'package:video_compress/video_compress.dart';

import '../const.dart';
import '../services/api_scheme.dart';
import '../services/location_service.dart';
import '../theme.dart';
import '../widgets/dialogs.dart';
import 'camera_summary.dart';
import 'completed.dart';
import 'inspection.dart';

List<CameraDescription>? cameras;

class InspectionScreen extends StatefulWidget {
  const InspectionScreen(
      {Key? key,
      required this.token,
      required this.policyId,
      required this.reference,
      required this.typeOfInspection})
      : super(key: key);
  final String token, policyId,reference;
  final InspectionType typeOfInspection;

  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? videoFile;
  File? frontSide;
  File? backSide;
  File? leftSide;
  File? rightSide;
  File? dashboard;
  File? interior;
  String videoUrl = '';
  List<File> imageList = [];
  String token = '';
  String policyId = '';
  String timer = '';
  String lon = '';
  String lat = '';
  Timer? _timer;
  int _duration = 60;
  Map<String, dynamic> locationData = {};
  bool start = false;
  final _imageController = InspectionImageController();
  int inspectionIndex = 0;
  File? _image;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    boot();

    if (mounted) {
      _controller = CameraController(cameras![0], ResolutionPreset.high,
          enableAudio: false);
    }
    _initializeControllerFuture = _controller.initialize();
  }

  boot() async {
    token = widget.token;
    policyId = widget.policyId;
    locationData = await determinePosition();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_duration == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _duration--);
        }
      },
    );
  }

  bool isLoading = false;

  changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: isCompleted
            ? inspectionSummary(context,
                imageList1: Image.file(imageList[0]),
                imageList2: Image.file(imageList[1]),
                imageList3: Image.file(imageList[2]),
                imageList4: Image.file(imageList[3]),
                imageList5: Image.file(imageList[4]),
                imageList6: Image.file(imageList[5]),
                imageList7: Image.file(imageList[6]),
                onConfirm: () {
                  uploadVideo(context);
                },
                onClose: () => Navigator.pop(context))
            : Stack(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: height(context),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: DARK),
                                  height: height(context) * 0.7,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: SizedBox(
                                            width: width(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: FutureBuilder<void>(
                                                future:
                                                    _initializeControllerFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return CameraPreview(
                                                        _controller);
                                                  } else {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (!start)
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                'assets/images/direction.png',
                                                width: width(context) * 0.8,
                                                package: 'mca_flutter_sdk',
                                              ),
                                              const Text('Go in this direction',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: WHITE)),
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.12)
                                            ],
                                          ),
                                        ),
                                      if (start)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/leftTop.png',
                                                      package:
                                                          'mca_flutter_sdk'),
                                                  Image.asset(
                                                      'assets/images/rightTop.png',
                                                      package:
                                                          'mca_flutter_sdk'),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.22),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/leftBottom.png',
                                                      package:
                                                          'mca_flutter_sdk'),
                                                  Image.asset(
                                                      'assets/images/rightBottom.png',
                                                      package:
                                                          'mca_flutter_sdk'),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.13),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 40, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: RED, width: 3),
                                            color: WHITE,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '$_duration',
                                            style: const TextStyle(
                                                color: RED,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: BLACK.withOpacity(0.3)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: 4),
                                            checked(
                                              color: inspectionIndex >= 1
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 2
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 3
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 4
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 5
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 6
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 3),
                                            checked(
                                              color: inspectionIndex >= 7
                                                  ? PRIMARY
                                                  : WHITE.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(55, 40, 55, 0),
                              child: SizedBox(
                                height: height(context) * 0.25,
                                child: Center(
                                  child: PageView.builder(
                                      controller:
                                          _imageController.imageController,
                                      onPageChanged:
                                          _imageController.selectedImageIndex,
                                      itemCount: _imageController
                                          .inspectionImages.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Image.asset(
                                                _imageController
                                                    .inspectionImages[index]
                                                    .imageAsset,
                                                height: width(context) * 0.25,
                                                fit: BoxFit.contain,
                                                package: 'mca_inspection_sdk',
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              _imageController
                                                  .inspectionImages[index]
                                                  .description,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // _image==null?Container():Image.file(File(_image),height: 200),
                      Positioned(
                        right: 10,
                        left: 10,
                        top: height(context) * 0.66,
                        child: isLoading
                            ? Container(
                                height: 57,
                                width: 57,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: GREY.withOpacity(0.8)),
                                child: const Center(
                                    child: CircularProgressIndicator(color: PRIMARY)))
                            : GestureDetector(
                                onTap: () async {
                                  print(
                                      'inspectionIndex--------> $inspectionIndex');
                                  if (start) {
                                    changeLoading();

                                    _imageController.forwardAction(context,
                                        done: () {
                                      Navigator.pop(context);
                                      setState(() => isCompleted = true);
                                    });

                                    if (inspectionIndex < 8) {
                                      await _controller
                                          .takePicture()
                                          .then((value) {
                                        _image = File(value.path);
                                        imageList.add(_image!);
                                        inspectionIndex++;
                                      });
                                    }
                                    if (inspectionIndex == 7) {
                                      await _controller
                                          .stopVideoRecording()
                                          .then((file) {
                                        if (mounted) setState(() {});
                                        videoFile = File(file.path);
                                      });
                                    }
                                    setState(() => isLoading = false);
                                  } else {
                                    setState(() => start = true);
                                    await _controller.startVideoRecording();
                                    startTimer();
                                  }
                                },
                                child: (Platform.isIOS)
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: WHITE,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  offset:
                                                      const Offset(0.8, 1.2),
                                                  blurRadius: 0.5,
                                                  spreadRadius: 0.6,
                                                  color: GREY.withOpacity(0.3)),
                                              BoxShadow(
                                                  offset:
                                                      const Offset(-1.2, 0.5),
                                                  blurRadius: 0.3,
                                                  spreadRadius: 0.5,
                                                  color: GREY.withOpacity(0.3)),
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2.5, color: GREEN),
                                                shape: BoxShape.circle,
                                                color: BLACK,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                start ? 'Next' : 'Start',
                                                style: const TextStyle(
                                                    color: WHITE, fontSize: 13),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: GREY.withOpacity(0.8),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  offset:
                                                      const Offset(0.8, 1.2),
                                                  blurRadius: 0.5,
                                                  spreadRadius: 0.6,
                                                  color: GREY.withOpacity(0.3)),
                                              BoxShadow(
                                                  offset:
                                                      const Offset(-1.2, 0.5),
                                                  blurRadius: 0.3,
                                                  spreadRadius: 0.5,
                                                  color: GREY.withOpacity(0.3)),
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: RED,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                start ? 'Next' : 'Start',
                                                style: const TextStyle(
                                                    color: WHITE, fontSize: 13),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  submitInspection(context) async {
    print('submitting');

    var response = await WebServices.inspection(
        token: widget.token,
        reference: widget.reference,
        policyId: widget.policyId,
        timeStamp: DateTime.now().toString(),
        lon: locationData['lon'].toString(),
        lat: locationData['lat'].toString(),
        inspectionType: InspectionType.vehicle.toString().split('.')[1],
        address: 'Plot 8, Venia hub, Lekki Phase 1',
        rightSide: imageList[0],
        frontSide: imageList[1],
        chassisNumber: imageList[2],
        backSide: imageList[3],
        leftSide: imageList[4],
        dashboard: imageList[5],
        interior: imageList[6],
        videoUrl: videoUrl);

    if (response.statusCode.toString() == '200' ||
        response.statusCode.toString() == '201') {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CompletedScreen()));
    } else {
      Navigator.pop(context);
      response.stream.transform(utf8.decoder).listen((value) {
        var body = jsonDecode(value);
        print(body['responseText']);
        Dialogs.showErrorMessage(body['responseText'].toString());
      });
    }
  }

  Image buildImageFrame(image) => Image.asset(image);

  Padding checked({color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Container(
        height: 23,
        width: 23,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? WHITE.withOpacity(0.4),
            border: Border.all(color: DARK.withOpacity(0.5), width: 2)),
        child: const Center(child: Icon(Icons.check, size: 12, color: WHITE)),
      ),
    );
  }



  uploadVideo(context) async {
    Dialogs.showLoading(context: context, text: 'Submitting Inspection');

    await VideoCompress.setLogLevel(0);
    final MediaInfo? video = await VideoCompress.compressVideo(
      videoFile!.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    File Vid = File(video!.path.toString());

    var response = await WebServices.uploadFile(
        context, 'businessId', Vid, widget.token,fileType: 'video');

    // Map<String, String> headers = {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer " + token
    // };
    //
    // var uri = Uri.parse(WebServices.uploadUrl);
    //
    // var request = http.MultipartRequest("POST", uri);
    //
    // await VideoCompress.setLogLevel(0);
    // final MediaInfo? video = await VideoCompress.compressVideo(
    //   videoFile!.path,
    //   quality: VideoQuality.LowQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,
    // );
    // File Vid = File(video!.path.toString());
    //
    // request.files.add(await http.MultipartFile.fromPath('file', Vid.path));
    //
    // request.fields['fileType'] = 'video';
    // request.headers.addAll(headers);
    //
    // var response = await request.send();

    print('uoploading');
    print(response.reasonPhrase);

    if (response.statusCode.toString() == '200' ||
        response.statusCode.toString() == '201') {
      response.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          var body = jsonDecode(value);
          videoUrl = body['data']['file_url'];
        });
        submitInspection(context);
      });
    } else {
      Navigator.pop(context);
      Dialogs.showErrorMessage('${response.reasonPhrase}');
    }
  }
}

class InspectionImage {
  final imageAsset;
  final description;

  InspectionImage(this.imageAsset, this.description);
}

class InspectionImageController extends GetxController {
  var selectedImageIndex = 0.obs;

  bool get isLastImage =>
      selectedImageIndex.value == inspectionImages.length - 1;
  var imageController = PageController();

  forwardAction(context, {done}) {
    if (isLastImage) {
      Dialogs.showConfirmSubmitDialog(
        context,
        okAction: done,
        cancelAction: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } else {
      imageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  List<InspectionImage> inspectionImages = [
    InspectionImage('assets/images/Rigthside.png', 'Right View of your car'),
    InspectionImage('assets/images/front.png', 'Front View of your car'),
    InspectionImage('assets/images/iso.png', 'Locate chassis number'),
    InspectionImage('assets/images/Leftsideview.png', 'Left View of your car'),
    InspectionImage('assets/images/Backview.png', 'Back View of your car'),
    InspectionImage(
        'assets/images/dashboard.jpg', 'Dashboard View of your car'),
    InspectionImage(
        'assets/images/interior_vehicle.jpg', 'Interior View of your car'),
  ];
}
