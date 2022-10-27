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
    firestore.collection('country').orderBy('name').get().then((event) {
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

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.height * .3,
            floating: false,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.map,
                    size: 70,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Quais cidades de cada país?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Surpreenda seus amigos.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
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
                );
              },
              childCount: countries.length,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Column(
              children: [
                const Text(
                  'Encontre quais cidades pertencem a cada país',
                ),
                Icon(
                  Icons.map,
                  size: MediaQuery.of(context).size.width * .5,
                )
              ],
            ),
          ),
        ),
        body: buildListItems());
  }

  Widget buildListItems() {
    return loading
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
          );
  }
}
