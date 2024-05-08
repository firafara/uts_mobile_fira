import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:project_uts/budaya/list_budaya_page.dart';
import 'package:project_uts/models/model_user.dart';
import 'package:project_uts/user/list_user_page.dart';
import 'package:project_uts/models/model_budaya.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_uts/sejarawan/list_sejarawan_page.dart';
import 'package:project_uts/user/list_user_page.dart';
import 'package:project_uts/utils/session_manager.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Future<ModelBudaya> futureBudaya;
  late int _selectedIndex = 1; // Inisialisasi _selectedIndex

  @override
  void initState() {
    super.initState();
    futureBudaya = fetchBudaya();
  }

  Future<ModelBudaya> fetchBudaya() async {
    final response = await http.get(Uri.parse('http://192.168.1.10/budaya/budaya.php'));
    if (response.statusCode == 200) {
      return ModelBudaya.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Budaya');
    }
  }

  // Tambahkan method untuk menangani perubahan item pada bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListBudayaPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListSejarawan()),
      );
    } else if (index == 3) {
      // Ambil data pengguna yang sedang login dari SessionManager
      ModelUsers currentUser = ModelUsers(
        id: int.parse(sessionManager.id!),
        username: sessionManager.username!,
        email: sessionManager.email!,
        fullname: sessionManager.fullname!,
        phone_number: sessionManager.phone_number!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListUserPage(currentUser: currentUser)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFEFD8),
        title: Text(
          "Gallery Page",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  Center(
        child: FutureBuilder<ModelBudaya>(
          future: futureBudaya,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 5, // Horizontal space between items
                    mainAxisSpacing: 5, // Vertical space between items
                  ),
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    var imageUrl =
                        "http://192.168.1.10/budaya/${snapshot.data!.data[index].gambar}";
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(imageUrl: imageUrl),
                          ),
                        );
                      },
                      child: Hero(
                        tag: imageUrl,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.brown,
                              width: 2,
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Text('Could not load image'),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFBDAB94),
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Budaya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_sharp),
            label: 'Sejarawan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  const DetailScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFEFD8),
        title: Text(
          "Detail Image",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Text('Could not load image'),
            ),
          ),
        ),
      ),
    );
  }
}
