import 'package:app/models/country.dart';
import 'package:app/pages/city.dart';
import 'package:app/widgets/row_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageCountry extends StatefulWidget {
  const PageCountry({super.key});

  @override
  State<PageCountry> createState() => _PageCountryState();
}

class _PageCountryState extends State<PageCountry> {
  late FirebaseFirestore firestore;
  bool loading = false;
  List<Country> countries = [];

  fetch() {
    firestore.collection('country').get().then((event) {
      List<Country> items = [];
      for (var doc in event.docs) {
        items.add(
          Country(
            doc.get('name'),
          ),
        );
      }

      setState(() {
        countries = items;
      });
    });
  }

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;

    super.initState();

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
      ),
      body: loading
          ? const RowLoading()
          : ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(countries[index].name),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageCity(
                      country: countries[index],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
