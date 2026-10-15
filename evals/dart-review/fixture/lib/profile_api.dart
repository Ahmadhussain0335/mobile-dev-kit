import 'package:http/http.dart' as http;

const _apiKey = 'fake-demo-key-not-a-real-secret';

class ProfileApi {
  ProfileApi(this._client);

  final http.Client _client;

  Future<void> saveName(String name) async {
    final response = await _client.post(
      Uri.https('api.example.com', '/v1/profile'),
      headers: {'x-api-key': _apiKey},
      body: {'name': name},
    );
    if (response.statusCode != 200) {
      throw ProfileException(response.statusCode);
    }
  }
}

class ProfileException implements Exception {
  ProfileException(this.statusCode);

  final int statusCode;
}
