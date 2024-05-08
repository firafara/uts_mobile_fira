import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_uts/models/model_add_sejarawan.dart';
import 'package:project_uts/sejarawan/list_sejarawan_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';

class AddSejarawanPage extends StatefulWidget {
  const AddSejarawanPage({Key? key}) : super(key: key);

  @override
  State<AddSejarawanPage> createState() => _AddSejarawanPageState();
}

class _AddSejarawanPageState extends State<AddSejarawanPage> {
  TextEditingController _namaController = TextEditingController();
  String _fotoPath = ''; // Ubah ke tipe String
  TextEditingController _asalController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  String _jenisKelaminValue = '';
  DateTime _selectedDate = DateTime.now();

  bool isLoading = false;

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> selectFile() async {
    if (await requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _fotoPath = result.files.single.path!;
        });
      } else {
        print("No file selected");
      }
    } else {
      print("Storage permission not granted");
    }
  }


  // Future<void> addSejarawan() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     // Validasi semua field harus diisi
  //     if (_namaController.text.isEmpty ||
  //         _asalController.text.isEmpty ||
  //         _deskripsiController.text.isEmpty ||
  //         _jenisKelaminValue.isEmpty ||
  //         _fotoPath.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Semua field harus diisi')),
  //       );
  //       return;
  //     }
  //
  //     http.Response res = await http.post(
  //       Uri.parse('http://192.168.1.12/budaya/addsejarawan.php'),
  //       body: {
  //         "nama": _namaController.text,
  //         "foto": _fotoPath,
  //         "tanggal_lahir": _selectedDate.toString(),
  //         "asal": _asalController.text,
  //         "jenis_kelamin": _jenisKelaminValue,
  //         "deskripsi": _deskripsiController.text,
  //       },
  //     );
  //
  //     ModelAddSejarawan data = modelAddSejarawaFromJson(res.body);
  //     if (data.isSuccess == true) {
  //       setState(() {
  //         isLoading = false;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('${data.message}')),
  //         );
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => ListSejarawan()),
  //               (route) => false,
  //         );
  //       });
  //     } else {
  //       isLoading = false;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('${data.message}')),
  //       );
  //     }
  //   } catch (e) {
  //     isLoading = false;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }
  Future<void> addSejarawan() async {
    if (_namaController.text.isEmpty ||
        _asalController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _jenisKelaminValue.isEmpty ||
        _fotoPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.parse('http://192.168.1.10/budaya/addsejarawan.php');

      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['nama'] = _namaController.text
        ..fields['tanggal_lahir'] = _selectedDate.toString()
        ..fields['asal'] = _asalController.text
        ..fields['jenis_kelamin'] = _jenisKelaminValue
        ..fields['deskripsi'] = _deskripsiController.text;

      if (_fotoPath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            _fotoPath,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Server response: $responseBody"); // This line will print the response body

      if (response.statusCode == 200) {
        try {
          ModelAddSejarawan data = modelAddSejarawaFromJson(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          if (data.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ListSejarawan()),
                  (route) => false,
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to parse response: $e')),
          );
        }
      } else {
        throw Exception('Failed to upload data, status code: ${response.statusCode}');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFEFD8),
        title: Row(
          children: [
            Text(
              'Add Sejarawan',
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFEFD8),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Name",
                prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _namaController,
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: selectFile,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Foto',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 10),
                      Text(_fotoPath.isNotEmpty ? _fotoPath.split('/').last : 'Pilih foto'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context), // Date picker call
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),


            SizedBox(height: 16),
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Asal",
                prefixIcon:
                Icon(Icons.location_city, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _asalController,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              value: _jenisKelaminValue.isNotEmpty ? _jenisKelaminValue : null,
              onChanged: (String? newValue) {
                setState(() {
                  _jenisKelaminValue = newValue!;
                });
              },
              items: <String>['', 'Laki Laki', 'Perempuan']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addSejarawan,
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
                        'Save Changes',
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
    );
  }
}
