import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_uts/models/model_sejarawan.dart';

class DetailSejarawanPage extends StatelessWidget {
  final Datum sejarawan;

  const DetailSejarawanPage({Key? key, required this.sejarawan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Sejarawan",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFFFEFD8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto Sejarawan
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: "http://192.168.1.10/budaya/${sejarawan.foto}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            // Informasi Sejarawan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sejarawan.nama,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Asal: ${sejarawan.asal}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Jost',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tanggal Lahir: ${sejarawan.tanggal_lahir}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Jost',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Jenis Kelamin: ${sejarawan.jenis_kelamin}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Jost',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Deskripsi Sejarawan",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    sejarawan.deskripsi,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Mulish',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space below the TabBarView
          ],
        ),
      ),
    );
  }
}
