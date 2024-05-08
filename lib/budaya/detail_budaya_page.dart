import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_uts/models/model_budaya.dart';

class DetailBudayaPage extends StatelessWidget {
  final Datum budaya;

  const DetailBudayaPage({Key? key, required this.budaya}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Budaya",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFFFEFD8), // Warna latar belakang
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto Budaya
            Container(
              height: 300, // Sesuaikan dengan kebutuhan
              child: CachedNetworkImage(
                imageUrl: "http://192.168.1.10/budaya/${budaya.gambar}",
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            // Judul Budaya
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                budaya.judul,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Konten Budaya
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                budaya.konten,
                style: TextStyle(fontSize: 14,fontFamily: 'Mulish',),
              ),
            ),
            SizedBox(height: 20), // Space below the TabBarView
          ],
        ),
      ),
    );
  }
}
