import 'dart:developer';

import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/trip/data/api/api_service.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';

import '../../../../shared/constant/base_url.dart';
import 'package:http/http.dart' as http;

class ReportApiService {
  Future makeReport(String companyId, ReportingModel report) async {
    final url = "$baseUrl/incidents/company/$companyId";
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['time'] = report.time;
      request.fields['location'] = report.location;
      request.fields['description'] = report.description;
      request.fields['tripId'] = '${report.tripId}';
      request.fields['driverId'] = '${report.driverId}';
      request.fields['type'] = report.type;
      request.files.add(
        await http.MultipartFile.fromPath(
            'voiceNote', report.voiceNote?.path ?? ''),
      );

      for (var file in report.images) {
        log('pah: ${file.path}');
        request.files.add(
          await http.MultipartFile.fromPath('image', file.path),
        );
      }
      final response = await client.sendMultipartRequest(request: request);
      if (response.statusCode != 200) {
        throw CustomException('${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Report>> fetchReports(String driverId) async {
    final url = '$baseUrl/incidents/driver/$driverId';
    try {
      final response = await client.get(url);
      if (response.statusCode != 200) {
        throw CustomException('Failed to get previous reports');
      }
      return reportModelFromJson(response.body).data.data;
    } catch (e) {
      rethrow;
    }
  }
}
