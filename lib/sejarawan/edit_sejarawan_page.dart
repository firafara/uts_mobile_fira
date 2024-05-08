import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:project_uts/models/model_sejarawan.dart';
import 'package:project_uts/sejarawan/list_sejarawan_page.dart'; // Make sure this path and model are correct

class EditSejarawanPage extends StatefulWidget {
  final ModelSejarawan sejarawan;

  const EditSejarawanPage({Key? key, required this.sejarawan}) : super(key: key);

  @override
  _EditSejarawanPageState createState() => _EditSejarawanPageState();
}

class _EditSejarawanPageState extends State<EditSejarawanPage> {
  TextEditingController _namaController = TextEditingController();
  String _fotoPath = '';
  TextEditingController _asalController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  String _jenisKelaminValue = '';
  DateTime _selectedDate = DateTime.now();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sejarawan.data.isNotEmpty) {
      _namaController.text = widget.sejarawan.data.first.nama;
      _fotoPath = widget.sejarawan.data.first.foto;
      _asalController.text = widget.sejarawan.data.first.asal;
      _deskripsiController.text = widget.sejarawan.data.first.deskripsi;
      _jenisKelaminValue = widget.sejarawan.data.first.jenis_kelamin;
      _selectedDate = DateTime.parse(widget.sejarawan.data.first.tanggal_lahir);
    }
  }



  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _fotoPath = result.files.single.path!;
      });
    }
  }

  Future<void> saveChanges(String newNama, String newAsal, String newDeskripsi, String newJenisKelamin) async {
    if (newNama.isEmpty || newAsal.isEmpty || newDeskripsi.isEmpty || newJenisKelamin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    if (isLoading) return; // Prevents multiple submissions

    setState(() {
      isLoading = true;
    });

    Uri uri = Uri.parse('http://192.168.1.10/budaya/editsejarawan.php');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['id'] = widget.sejarawan.data.first.id
      ..fields['nama'] = newNama
      ..fields['asal'] = newAsal
      ..fields['deskripsi'] = newDeskripsi
      ..fields['jenis_kelamin'] = newJenisKelamin
      ..fields['tanggal_lahir'] = _selectedDate.toIso8601String();

    if (_fotoPath.isNotEmpty && _fotoPath != widget.sejarawan.data.first.foto) {
      request.files.add(await http.MultipartFile.fromPath('foto', _fotoPath, contentType: MediaType('image', 'jpeg')));
    }

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
        print("Response Body: $responseBody");  // Log the full response body for debugging

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));

        // Safely check for 'is_success' with a default value of false if not found
        bool isSuccess = data['is_success'] ?? false;
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListSejarawan()),
          );

        }
      } else {
        throw Exception('Failed to update data, status code: ${response.statusCode}');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        isLoading = false;  // Ensure isLoading is set to false in finally block
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
              'Edit Sejarawan',
              style: TextStyle(fontSize: 18.0, fontFamily: 'Jost', fontWeight: FontWeight.bold),
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
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _namaController,
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.location_city, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _asalController,
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
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
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
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              value: _jenisKelaminValue,
              onChanged: (value) {
                setState(() {
                  _jenisKelaminValue = value!;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'Laki Laki',
                  child: Text('Laki Laki'),
                ),
                DropdownMenuItem<String>(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
            ),


            SizedBox(height: 16),
            InkWell(
              onTap: () async {
                FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.image);

                if (result != null) {
                  setState(() {
                    _fotoPath = result.files.single.path!;
                  });
                }
              },
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
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Expanded( // This ensures the text widget expands to fill the space
                      child: Text(
                        _fotoPath.isNotEmpty ? _fotoPath.split('/').last : 'Pilih foto',
                        overflow: TextOverflow.ellipsis, // Helps avoid text overflow issues
                      ),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 16),

            InkWell(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
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
                    Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                saveChanges(
                    _namaController.text,
                    _asalController.text,
                    _deskripsiController.text,
                    _jenisKelaminValue
                );
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
                        'Simpan Perubahan',
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
