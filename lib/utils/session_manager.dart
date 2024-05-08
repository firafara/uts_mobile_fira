import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? id;
  String? username;
  String? fullname;
  String? email;
  String? phone_number;

  Future<void> saveSession(int val, String id, String username, String fullname, String email, String phone_number) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("value", val);
    await pref.setString("id", id);
    await pref.setString("username", username);
    await pref.setString("fullname", fullname);
    await pref.setString("email", email);
    await pref.setString("phone_number", phone_number);

  }

  Future<bool> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getInt("value");
    id = pref.getString("id");
    username = pref.getString("username");
    fullname = pref.getString("fullname");
    email = pref.getString("email");
    phone_number = pref.getString("phone_number");

    return username != null;
  }

  Future<void> clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

SessionManager sessionManager = SessionManager();