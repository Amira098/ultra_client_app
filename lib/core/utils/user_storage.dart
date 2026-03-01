import '../constants/app_values.dart';
import '../models/user_model.dart';
import 'app_shared_preference.dart';

class UserStorage {
  static Future<void> saveUser(UserModel user) async {
    await SharedPreferencesUtils.saveJson(AppValues.user, user.toJson());
    await SharedPreferencesUtils.saveData(key: AppValues.loggedIn, value: true);
  }

  static UserModel? getUser() {
    final map = SharedPreferencesUtils.getJson(AppValues.user);
    if (map == null) return null;
    return UserModel.fromJson(map);
  }

  static Future<void> saveToken(String token) async {
    await SharedPreferencesUtils.saveData(key: AppValues.token, value: token);
  }

  static String? getToken() => SharedPreferencesUtils.getStringSync(AppValues.token);

  static bool isLoggedIn() =>
      SharedPreferencesUtils.getBoolSync(AppValues.loggedIn) ?? false;

  static Future<void> logout() async {
    await SharedPreferencesUtils.removeData(key: AppValues.user);
    await SharedPreferencesUtils.removeData(key: AppValues.token);
    await SharedPreferencesUtils.saveData(key: AppValues.loggedIn, value: false);
  }
}
