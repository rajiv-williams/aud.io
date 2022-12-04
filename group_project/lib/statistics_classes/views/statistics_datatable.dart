import 'package:flutter/material.dart';
import 'package:group_project/statistics_classes/views/statistics_chart.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import '../../MainScreen_Model/nav.dart';
import 'package:group_project/statistics_classes/models/countries.dart';

import '../models/countries.dart';

class Statistics_DataTable extends StatefulWidget {
  const Statistics_DataTable({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<Statistics_DataTable> createState() => _Statistics_DataTableState();
}

class _Statistics_DataTableState extends State<Statistics_DataTable> {
  var allUsers = [];
  List<CountryFrequency> frequencies = [];
  final UserModel _model = UserModel();
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StatisticsChart(
                        frequencies: frequencies
                    ))
                );
              },
              tooltip: 'chart',
              icon: const Icon(Icons.bar_chart)
          ),
          IconButton(
              onPressed: (){
                //Call async function that goes to route "/home"
                Navigator.pushNamed(context, '/home');
              },
              tooltip: 'Home',
              icon: const Icon(Icons.home)
          ),
        ],
      ),
      body: DataTable(
        columns: [
          DataColumn(label: Text("Country")),
          DataColumn(label: Text("Frequency")),
        ],
        rows: frequencies!.map((CountryFrequency country) => DataRow(
            cells: [
              DataCell(Text(country.country!.toString())),
              DataCell(
                  Text(country.frequency!.toString()),
              ),
            ]
        )
        ).toList(),
      ),
    );
  }
  getAllUsers() async{
    allUsers = await _model.getAllUsers();
    setState(() {
      frequencies = _calculateCountryFrequencies();
    });
    print(allUsers);
  }

  List<CountryFrequency> _calculateCountryFrequencies(){

    Map<String, int > frequencies = {};
    for (Country country in countries) {
      frequencies[country.name!] = 0;
    }
    //print(frequencies);

    int? frequency;

    for (int i = 0; i < countries.length; i++){
      for(int j = 0; j < allUsers.length; j++){
        if (allUsers[j].country == countries[i].name){
          frequency = frequencies[allUsers[j].country];
          frequencies[allUsers[j].country] = frequency!+1;
        }
        else {
          print("user has a invalid country registered");
        }
      }
    }

    var list = countries.map(
            (country) => CountryFrequency(
            country: country.name,
            frequency: frequencies[country.name]
        ))
        .toList();

    List<CountryFrequency> usersFrequencies = [];

    for (CountryFrequency country in list) {
      if (country.frequency! > 0) {
        usersFrequencies.add(country);
      }
    }

    print(usersFrequencies);
    return usersFrequencies;
  }

}


