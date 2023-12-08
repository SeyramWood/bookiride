import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/features/trip/data/api/api_service.dart';
import 'package:bookihub/src/shared/constant/base_url.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:http/http.dart' as http;

class DeliveryApiService {
  //fetch all delivery by a driver
  Future<List<Delivery>> fetchDelivery(String driverID, String status) async {
    final url = "$baseUrl/packages/driver/$driverID?status=$status";
    try {
      final response = await client.get(url);
      if (response.statusCode != 200) {
        throw CustomException('${response.reasonPhrase}');
      }
      return DeliveryModel.fromJson(jsonDecode(response.body)).data?.delivery ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  Future verifyPackageCode(
    String packageId,
    String packageCode,
    List<File> idImage,
  ) async {
    final url = "$baseUrl/packages/$packageId/update-status";
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.fields['packageCode'] = packageCode;

      for (var image in idImage) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }
      final response = await client.sendMultipartRequest(request: request);
      log('${response.reasonPhrase}');

      if (response.statusCode != 200) {
        log('$packageId, $packageCode,$idImage');
        final errorMessage = json.decode(response.body)['error'];

        log('del: $errorMessage');
        throw CustomException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}
