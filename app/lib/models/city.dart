class City {
  late String name;
  late String country;
  int? geonameid;

  City({
    required this.name,
    required this.country,
    this.geonameid,
  });
}
