import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/budaya/list_budaya_page.dart';
import 'package:project_uts/home.dart';
import 'package:project_uts/login/register_page.dart';
import 'package:project_uts/models/ModelLogin.dart';
import 'package:project_uts/utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  bool _isPasswordVisible = false;
  Future<void> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('http://192.168.1.10/budaya/login.php'),
        body: {
          "login": "1",
          "username": txtUsername.text,
          "password": txtPassword.text,
        },
      );

      if (res.statusCode == 200) {
        ModelLogin data = ModelLogin.fromJson(json.decode(res.body));
        if (data.sukses) {
          if (data.data != null && data.data.id != null && data.data.username != null &&
              data.data.fullname != null && data.data.email != null  && data.data.phone_number != null) {
            sessionManager.saveSession(
              data.status,
              data.data.id,
              data.data.username,
              data.data.fullname,
              data.data.email,
              data.data.phone_number,
            );

            print('Nilai sesi disimpan:');
            print('ID: ${data.data.id}');
            print('Username: ${data.data.username}');
            print('Fullname: ${data.data.fullname}');
            print('Email: ${data.data.email}');

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ListBudayaPage()),
            );
          } else {
            throw Exception('Data pengguna tidak lengkap atau null');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFEFD8),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/batik.png',
                      width: 200,
                      height: 150,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Log in with your Account",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: keyForm,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Username cannot be empty" : null;
                      },
                      controller: txtUsername,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Username",
                        prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Password cannot be empty" : null;
                      },
                      controller: txtPassword,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF545454),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        if (keyForm.currentState?.validate() == true) {
                          loginAccount();
                        }
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF915D2D),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Jost',
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF915D2D),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "SIGN UP",
                          style: TextStyle(
                            color: Color(0xFF0961F5),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
