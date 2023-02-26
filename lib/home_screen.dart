import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_demo/data/models/data_model.dart';
import 'package:flutter_demo/data/models/search_model.dart';
import 'package:intl/intl.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.cityName}) : super(key: key);
  final String cityName;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCity();
  }

  SearchModel? cityDataFromApi;
  _getCity() async {
    String url =
        "https://geocoding-api.open-meteo.com/v1/search?name=${widget.cityName}";
    http.Response res = await http.get(Uri.parse(url));
    cityDataFromApi = SearchModel.fromJson(json.decode(res.body));
    debugPrint(cityDataFromApi!.results![0].id!.toString());
    double latitude = cityDataFromApi!.results![0].latitude!.toDouble();
    double longitude = cityDataFromApi!.results![0].longitude!.toDouble();
    _getData(longitude, latitude);
  }

  DataModel? dataFromAPI;
  _getData(longitude, latitude) async {

    String url =
        "https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&hourly=temperature_2m";
    http.Response res = await http.get(Uri.parse(url));
    dataFromAPI = DataModel.fromJson(json.decode(res.body));
    //debugPrint(dataFromAPI.hourlyUnits!.temperature2m);
    _isLoading = false;
    setState(() {});
  }

// final List _newList = ["Bishwarup", "Samragyi", "Devdeep", "Rajdip", "Rajbir", "Abhishek", "Dipa", "Sancharini", "Sayantina"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      /* body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxi9n78qzLflGLjYuxfg1J3ZPFnPkf8TjZYP_rnk12eQ&s",
              ),
      ), */
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DateTime temp = DateTime.parse(dataFromAPI!.hourly!.time![index]);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd-MM-yyyy HH:mm a').format(temp)),
                      Text(dataFromAPI!.hourly!.temperature2m![index].toString())
                    ],
                  ),
                );
              },
              itemCount: dataFromAPI!.hourly!.time!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Button is pressed");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
