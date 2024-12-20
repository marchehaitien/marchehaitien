import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class FilestackService {
  final String apiKey = 'YOUR_API_KEY'; // Remplace par ta clé API Filestack

  Future<String?> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://www.filestackapi.com/api/store/S3?key=$apiKey'),
    );
    request.files.add(await http.MultipartFile.fromPath('fileUpload', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var json = jsonDecode(responseData);
      return json['url']; // Retourne l'URL de l'image
    } else {
      print('Erreur : ${response.statusCode}');
      return null;
    }
  }
}
