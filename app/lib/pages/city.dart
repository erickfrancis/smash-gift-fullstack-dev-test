import 'package:app/models/city.dart';
import 'package:app/models/country.dart';
import 'package:app/widgets/row_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageCity extends StatefulWidget {
  final Country country;

  const PageCity({super.key, required this.country});

  @override
  State<PageCity> createState() => _PageCityState();
}

class _PageCityState extends State<PageCity> {
  late FirebaseFirestore firestore;
  Country get country => widget.country;

  bool showCount = false;
  bool loading = false;
  List<City> cities = [];

  fetch() {
    firestore
        .collection('city')
        .where('country', isEqualTo: country.name)
        .orderBy('name')
        .get()
        .then((event) {
      List<City> items = [];
      for (var doc in event.docs) {
        int? geonameid;

        if (doc.get('geonameid') is String) {
          geonameid = int.tryParse(
            doc.get('geonameid'),
          );
        } else if (doc.get('geonameid') is int) {
          geonameid = doc.get('geonameid');
        }

        items.add(
          City(
            name: doc.get('name'),
            country: doc.get('country'),
            geonameid: geonameid,
          ),
        );
      }

      setState(() {
        cities = items;
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
        title: Text(
          country.name,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ListTile(
            title: Text(
              'Quantas cidades tem ao total?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () => setState(() {
              showCount = !showCount;
            }),
            trailing: showCount
                ? Text(
                    cities.length.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                : const Icon(
                    Icons.remove_red_eye,
                  ),
          ),
        ),
      ),
      body: loading
          ? const RowLoading()
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(cities[index].name),
              ),
            ),
    );
  }
}
