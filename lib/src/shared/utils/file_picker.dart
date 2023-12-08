import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<List<File>> captureImages() async {
  List<File> images = [];

  // Fetch the available cameras
  List<CameraDescription> cameras;
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // Handle camera exception (e.g., no available cameras)
    print('Error getting cameras: $e');
    return images; // Return an empty list if there are no cameras
  }

  if (cameras.isEmpty) {
    // Handle the case where there are no available cameras
    print('No cameras available');
    return images; // Return an empty list if there are no cameras
  }

  // Use the first available camera
  CameraController cameraController = CameraController(
    cameras[0],
    ResolutionPreset.medium,
  );

  // Initialize the camera
  try {
    await cameraController.initialize();
  } on CameraException catch (e) {
    // Handle camera initialization exception
    print('Error initializing camera: $e');
    return images; // Return an empty list if there is an error initializing the camera
  }

  // Get a temporary directory path for storing the image
  final directory = await getTemporaryDirectory();
   String filePath = join(directory.path, '${DateTime.now()}.png');

  // Take a picture and save it to the given path
  try {
   final result = await cameraController.takePicture();
   filePath = result.path;
  } on CameraException catch (e) {
    // Handle take picture exception
    print('Error taking picture: $e');
    await cameraController.dispose(); // Dispose of the camera controller
    return images; // Return an empty list if there is an error taking the picture
  }

  // Add the captured image to the list
  images.add(File(filePath));

  // Dispose of the camera controller after capturing the image
  await cameraController.dispose();

  return images;
}

Future<List<File>> selectFiles() async {
  List<File> files = [];
  final fileResult = await FilePicker.platform.pickFiles(allowMultiple: true);
  if (fileResult != null) {
    files = fileResult.files
        .map((platformFile) => File(platformFile.path.toString()))
        .toList();
    return files;
  }
  return [];
}
