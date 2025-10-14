import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {

  Future<String> getUserId()  async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? existingUserId = preferences.getString("userId");
    if (existingUserId == null) {
      existingUserId = Uuid().v4();
      preferences.setString("userId", existingUserId);
    }
    return existingUserId;
  }
}
