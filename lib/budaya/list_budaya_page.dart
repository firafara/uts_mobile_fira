import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/budaya/detail_budaya_page.dart';
import 'package:project_uts/budaya/gallery_page.dart';
import 'package:project_uts/login/login_page.dart';
import 'package:project_uts/models/model_budaya.dart';
import 'package:project_uts/models/model_user.dart';
import 'package:project_uts/sejarawan/list_sejarawan_page.dart';
import 'package:project_uts/user/list_user_page.dart';
import 'package:project_uts/utils/session_manager.dart';

class ListBudayaPage extends StatefulWidget {
  const ListBudayaPage({Key? key});

  @override
  State<ListBudayaPage> createState() => _ListBudayaPageState();
}

class _ListBudayaPageState extends State<ListBudayaPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryPage()),
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

  String? username;

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        username = sessionManager.username;
        print('Data session: $username');
      });
    } else {
      print('Session tidak ditemukan!');
    }
  }

  late List<Datum> _budayaList;
  late List<Datum> _filteredBudayaList;
  late bool _isLoading;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataSession();
    _isLoading = true;
    _fetchBudaya();
    _filteredBudayaList = [];
  }

  Future<void> _fetchBudaya() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.10/budaya/budaya.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      setState(() {
        _budayaList = List<Datum>.from(
            parsed['data'].map((x) => Datum.fromJson(x)));
        _filteredBudayaList = _budayaList;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load berita');
    }
  }

  void _filterBudayaList(String query) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.10/budaya/budaya.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        if (query.isNotEmpty) {
          setState(() {
            _filteredBudayaList = allData.where((budaya) =>
            budaya.judul.toLowerCase().contains(query.toLowerCase()) ||
                budaya.konten.toLowerCase().contains(query.toLowerCase())).toList();
          });
        } else {
          setState(() {
            _filteredBudayaList = allData;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Budaya Jawa Tengah",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFFEFD8),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Hi, ${username ?? ''}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Jost'
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            color: Colors.black,
            onPressed: () {
              setState(() {
                sessionManager.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterBudayaList,
                  decoration: InputDecoration(
                    labelText: 'Search Budaya',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredBudayaList.length,
                    itemBuilder: (context, index) {
                    final budaya = _filteredBudayaList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigasi ke CompletedLesson ketika card diklik
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CompletedLesson()),
                          // );
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                color: Color(0xFFFFEFD8),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15), // Atur radius sesuai kebutuhan
                                    child: CachedNetworkImage(
                                      imageUrl: "http://192.168.1.10/budaya/${budaya.gambar}",
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          budaya.judul,
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontSize: 16,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Text(
                                          budaya.konten,
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: Image.asset(
                                'assets/images/iconagree.png',
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBudayaPage(budaya: budaya),
                                    ),
                                  );
                                },

                                child: Text(
                                  "Baca Selengkapnya",
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue, // Ubah nilai warna menjadi biru
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  );
                },
              ),
            ],
          ),
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

