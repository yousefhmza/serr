import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://serr-secret.herokuapp.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: token != null
          ? Options(
              headers: {
                'Authorization': 'Bear ' + '$token',
              },
            )
          : null,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: token != null
          ? Options(
              headers: {
                'Authorization': 'Bear ' + '$token',
              },
            )
          : null,
    );
  }

  static Future<Response> patchData({
    required String url,
    required var data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.patch(
      url,
      data: data,
      queryParameters: query,
      options: token != null
          ? Options(
              headers: {
                'Authorization': 'Bear ' + '$token',
              },
            )
          : null,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    return await dio.delete(
      url,
      data: data,
      queryParameters: query,
      options: token != null
          ? Options(
              headers: {
                'Authorization': 'Bear ' + '$token',
              },
            )
          : null,
    );
  }
}
