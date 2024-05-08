
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_uts/budaya/gallery_page.dart';
import 'package:project_uts/budaya/list_budaya_page.dart';
import 'package:project_uts/login/login_page.dart';
import 'package:project_uts/models/model_user.dart';
import 'package:project_uts/sejarawan/add_sejarawan_page.dart';
import 'package:project_uts/sejarawan/detail_sejarawan_page.dart';
import 'package:project_uts/sejarawan/edit_sejarawan_page.dart';
import 'package:project_uts/user/list_user_page.dart';
import 'package:project_uts/utils/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/models/model_sejarawan.dart';

class ListSejarawan extends StatefulWidget {
  const ListSejarawan({super.key});

  @override
  State<ListSejarawan> createState() => _ListSejarawanState();
}

class _ListSejarawanState extends State<ListSejarawan> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListBudayaPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryPage()),
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

  late List<Datum> _sejarawanList;
  late List<Datum> _filteredSejarawanList;
  late bool _isLoading;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataSession();
    _isLoading = true;
    _fetchSejarawan();
    _filteredSejarawanList = [];
  }

  Future<void> _fetchSejarawan() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.10/budaya/sejarawan.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        setState(() {
          _sejarawanList = List<Datum>.from(
              parsed['data'].map((x) => Datum.fromJson(x)));
          _filteredSejarawanList = _sejarawanList;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load sejarawan');
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
      });
    }
  }

  void _filterSejarawanList(String query) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.10/budaya/sejarawan.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        if (query.isNotEmpty) {
          setState(() {
            _filteredSejarawanList = allData.where((sejarawan) =>
            sejarawan.nama.toLowerCase().contains(query.toLowerCase()) ||
                sejarawan.asal.toLowerCase().contains(query.toLowerCase())
            ).toList();
          });
        } else {
          setState(() {
            _filteredSejarawanList = allData;
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
  Future<void> _editSejarawan(int index, Datum updatedSejarawan) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10/budaya/editsejarawan.php'),
        body: {
          "id": updatedSejarawan.id.toString(),
          "nama": updatedSejarawan.nama,
          "foto": updatedSejarawan.foto,
          "tanggal_lahir": updatedSejarawan.tanggal_lahir,
          "asal": updatedSejarawan.asal,
          "deskripsi": updatedSejarawan.deskripsi,
        },
      );
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        if (parsed['isSuccess']) {
          setState(() {
            _sejarawanList[index] = updatedSejarawan;
            _filteredSejarawanList = List.from(_sejarawanList);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(parsed['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(parsed['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to edit sejarawan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteSejarawan(int index) async {
    // Kode penghapusan data

    final sejarawanToDelete = _sejarawanList[index];
    final response = await http.post(
      Uri.parse('http://192.168.1.10/budaya/deletesejarawan.php'),
      body: {"id": sejarawanToDelete.id.toString()},
    );
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      if (parsed['isSuccess']) {
        setState(() {
          _sejarawanList.removeAt(index);
          _filteredSejarawanList = List.from(_sejarawanList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsed['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsed['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete sejarawan')),
      );
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
      backgroundColor: Color(0xFFFFEFD8),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFEFD8),
                border: Border.all(color: Colors.white10, width: 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterSejarawanList,
                  decoration: InputDecoration(
                    labelText: 'Search Sejarawan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some space between the buttons
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(),
              ) : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _filteredSejarawanList.length,
                itemBuilder: (context, index) {
                  Datum sejarawan = _filteredSejarawanList[index];
                  return WidgetSejarawan(
                    index: index,
                    sejarawan: sejarawan,
                    editSejarawan: _editSejarawan,
                    deleteSejarawan: _deleteSejarawan, // Pass the _deleteSejarawan function here
                  ); },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSejarawanPage(), // Ganti dengan halaman penambahan data yang sesuai
            ),
          );
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.add),
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
class WidgetSejarawan extends StatelessWidget {
  final int index;
  final Datum sejarawan;
  final Function(int, Datum) editSejarawan;
  final Function(int) deleteSejarawan;

  WidgetSejarawan({
    required this.index,
    required this.sejarawan,
    required this.editSejarawan,
    required this.deleteSejarawan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSejarawanPage(sejarawan: sejarawan),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider("http://192.168.1.10/budaya/${sejarawan.foto}"),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sejarawan.nama,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        sejarawan.asal,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        sejarawan.tanggal_lahir,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Buat ModelSejarawan baru dengan satu objek Datum dalam list data
                        ModelSejarawan modelSejarawan = ModelSejarawan(
                          isSuccess: true,
                          message: "Success",
                          data: [sejarawan], // Masukkan objek Datum ke dalam list data
                        );

                        // Navigasi ke halaman EditSejarawanPage dengan memberikan parameter yang diperlukan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditSejarawanPage(sejarawan: modelSejarawan),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                      color: Colors.brown,
                    ),

                    IconButton(
                      onPressed: () {
                        // Invoke the delete function with the index
                        deleteSejarawan(index);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}

// class WidgetSejarawan extends StatelessWidget {
//   final int index;
//   final Datum sejarawan;
//   final Function(int, Datum) editSejarawan;
//   final Function(int) deleteSejarawan; // Change the type of this function
//
//   WidgetSejarawan({
//     required this.index,
//     required this.sejarawan,
//     required this.editSejarawan,
//     required this.deleteSejarawan,
//   });
//   @override
//   Widget build(BuildContext context) {
//     void _handleDeleteSejarawan() {
//       deleteSejarawan(index);
//     }
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailSejarawanPage(sejarawan: sejarawan),
//           ),
//         );
//       },
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: CachedNetworkImageProvider("http://192.168.1.12/budaya/${sejarawan.foto}"),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         sejarawan.nama,
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         sejarawan.asal,
//                         style: TextStyle(
//                           fontSize: 10.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         sejarawan.tanggal_lahir,
//                         style: TextStyle(
//                           fontSize: 10.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         // Buat ModelSejarawan baru dengan satu objek Datum dalam list data
//                         ModelSejarawan modelSejarawan = ModelSejarawan(
//                           isSuccess: true,
//                           message: "Success",
//                           data: [sejarawan], // Masukkan objek Datum ke dalam list data
//                         );
//
//                         // Navigasi ke halaman EditSejarawanPage dengan memberikan parameter yang diperlukan
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EditSejarawanPage(sejarawan: modelSejarawan),
//                           ),
//                         );
//                       },
//                       icon: Icon(Icons.edit),
//                       color: Colors.brown,
//                     ),
//
//                     IconButton(
//                       onPressed: _handleDeleteSejarawan, // Invoke the delete function here
//                       icon: Icon(Icons.delete),
//                       color: Colors.red,
//                     ),
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Divider(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SejarawanDeleteScreen extends StatelessWidget {
  final Function() deleteSejarawan;

  const SejarawanDeleteScreen({
    Key? key,
    required this.deleteSejarawan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Delete Sejarawan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus Pegawai ini?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deleteSejarawan();
                Navigator.pop(context);
              },
              child: Text('Ya, Hapus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}