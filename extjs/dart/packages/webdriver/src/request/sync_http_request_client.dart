import 'dart:io' show ContentType, HttpHeaders;

import 'package:sync_http/sync_http.dart';

import '../common/request.dart';
import '../common/request_client.dart';

/// Sync request client using sync_http package.
class SyncHttpRequestClient extends SyncRequestClient {
  SyncHttpRequestClient(Uri prefix) : super(prefix);

  @override
  WebDriverResponse sendRaw(WebDriverRequest request) {
    SyncHttpClientRequest httpRequest;
    switch (request.method) {
      case HttpMethod.httpGet:
        httpRequest = SyncHttpClient.getUrl(resolve(request.uri));
        break;
      case HttpMethod.httpPost:
        httpRequest = SyncHttpClient.postUrl(resolve(request.uri));
        httpRequest.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
        httpRequest.write(request.body);
        break;
      case HttpMethod.httpDelete:
        httpRequest = SyncHttpClient.deleteUrl(resolve(request.uri));
        break;
    }

    httpRequest.headers.add(HttpHeaders.acceptHeader, 'application/json');
    httpRequest.headers.add(HttpHeaders.cacheControlHeader, 'no-cache');

    final httpResponse = httpRequest.close();

    return WebDriverResponse(
        httpResponse.statusCode, httpResponse.reasonPhrase, httpResponse.body);
  }

  @override
  String toString() => 'SyncHttp';
}
