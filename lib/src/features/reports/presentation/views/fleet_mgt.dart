import 'dart:developer';
import 'dart:io';

import 'package:record/record.dart';
import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/reports/presentation/provider/report_controller.dart';
import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import '../../../../../main.dart';
import '../../../../shared/utils/file_picker.dart';
import '../../../../shared/utils/permissions/permissions.dart';
import '../../../../shared/utils/show.snacbar.dart';
import '../../../trip/domain/entities/trip_model.dart';

class FleetMgtReport extends StatefulWidget {
  const FleetMgtReport({super.key});

  @override
  State<FleetMgtReport> createState() => _FleetMgtReportState();
}

class _FleetMgtReportState extends State<FleetMgtReport> {
  final timeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  var images = <File>[];
  var trip = locator<Trip>();
  late Record audioRecord;
  String statusText = "Record pickup location";
  bool isRecording = false;
  File? recordFile;

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final selectedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      timeController.text =
          '${selectedTime.toIso8601String().split('.').first}Z';
    }
  }

  String value = 'Collisions';

  @override
  void initState() {
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  void record() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFile = await getFilePath();
      isRecording = true;
      RecordMp3.instance.start(recordFile!.path, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

//GET Device storage location
  int i = 0;
  Future<File> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return File("$sdPath/report.mp3 👌");
  }

  void stopRecording() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isRecording = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Fleet Mgt Report",
            style: Theme.of(context).textTheme.headlineMedium!),
        backgroundColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Incident Time",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .01),
                  TextFormField(
                    controller: timeController,
                    cursorColor: grey,
                    readOnly: true,
                    onTap: _selectTime,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "When it occurred",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        filled: true,
                        fillColor: white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: grey),
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .02,
                  ),
                  Text(
                    "Incident Type",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .01),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .07,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox(), // Removes the underline
                      isExpanded: true,  
                      value:
                          value,  
                      onChanged: (String? newValue) {
                        setState(() {
                          value = newValue!;
                          print(value);
                        });
                      },
                      items: roadIncidents
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            child: Text(
                              value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 0.84),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                  Text(
                    "Description of incident",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .01,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: MediaQuery.sizeOf(context).height * .13,
                        child: TextFormField(
                          controller: descriptionController,
                          cursorColor: grey,
                          decoration: InputDecoration(
                              hintText: "What happened?",
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              filled: true,
                              fillColor: white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: grey),
                                  borderRadius: BorderRadius.circular(5))),
                          expands: true,
                          maxLines: null,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .02,
                  ),
                  GestureDetector(
                    onTap: () {
                      isRecording ? stopRecording() : record();
                      setState(() {});
                    },
                    child: Material(
                      // borderRadius: borderRadius,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(children: [
                          Text(isRecording
                              ? 'Recording... (Tap to stop)'
                              : recordFile != null
                                  ? '${recordFile!.path.split('/').last} (record to replace)'
                                  : 'Record voice'),
                          const Spacer(),
                          Icon(
                            Icons.mic_none_sharp,
                            color: isRecording ? blue : black,
                          )
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .03,
                  ),
                  InkWell(
                    onTap: () async {
                      images = await selectFiles();
                      setState(() {});
                    },
                    child: Material(
                      shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: images.isNotEmpty
                            ? Center(
                                child: Text(
                                  "${images.length} images are ready to be sent",
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Add images",
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .02,
                                  ),
                                  ImageIcon(
                                    AssetImage(
                                      CustomeImages.camera,
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .04,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CustomButton(
                      onPressed: () async {
                        var report = ReportingModel(
                          time: timeController.text,
                          tripId: trip.id,
                          images: images,
                          driverId: trip.driver.id,
                          location: 'Pedu',
                          description: descriptionController.text,
                          voiceNote: recordFile,
                          type: value,
                        );
                        log(report.type.toString());
                        await context
                            .read<ReportProvider>()
                            .makeReport('${trip.company.id}', report)
                            .then(
                          (value) {
                            value.fold(
                                (failure) => showCustomSnackBar(
                                    context, failure.message, orange),
                                (success) => showCustomSnackBar(
                                    context, success, green));
                          },
                        );
                      },
                      child: const Text('Submit Report'),
                    ).loading(context.watch<ReportProvider>().isLoading),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  List<String> roadIncidents = [
    'Collisions',
    'Rear-end Collision',
    'Head-On Collision',
    'Side-Impact Collision',
    'Multi-Vehicle Collision',
    'Rollovers',
    'Run-off-road incidents',
    'Pedestrian or Cyclist Accidents',
    'Mechanical Failures',
    'Brake Failure',
    'Tire Blowout',
    'Engine Problems',
    'Distracted Driving',
    'Phone Usage',
    'Eating While Driving',
    'Driving Under the Influence (DUI)',
    'Alcohol-related Accidents',
    'Drug-related Accidents',
    'Weather-Related Incidents',
    'Rain',
    'Snow',
    'Fog',
    'Speeding or Reckless Driving',
    'Fatigue-Related Accidents',
    'Fall Asleep at the Wheel',
    'Other Issue',
  ];
}
