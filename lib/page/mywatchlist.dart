import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:counter_7/main.dart';
import 'package:counter_7/page/show_data.dart';
import 'package:counter_7/page/drawer.dart';
import 'package:counter_7/page/tambah_data.dart';
import 'package:counter_7/model/budget.dart';
import 'package:counter_7/page/detail_mywatchlist.dart';
import 'package:counter_7/model/watchlist.dart';

class MyWatchList extends StatefulWidget {
  const MyWatchList({Key? key}) : super(key: key);

  @override
  State<MyWatchList> createState() => _MyWatchListState();
}

class _MyWatchListState extends State<MyWatchList> {
  Future<List<WatchList>> fetchWatchList() async {
    var url = Uri.parse(
        'http://assignment-griseldaneysasadiya.herokuapp.com/mywatchlist/json/');
    var response = await http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
      },
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object ToDo
    List<WatchList> listWatch = [];
    for (var d in data) {
      if (d != null) {
        listWatch.add(WatchList.fromJson(d));
      }
    }

    return listWatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Watch List'),
        ),
        drawer: buildDrawer(context),
        body: FutureBuilder(
            future: fetchWatchList(),
            builder: ((context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Text('Belum ada yang kamu tonton');
                } else {
                  ListView.builder(itemBuilder: ((_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: 
                      OutlinedButton(
                          onPressed: () {
                            // TODO: kirim data ke page detail watchlist & navigator.push()
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WatchListPage(
                                        watchlist: snapshot.data![index])));
                          }, // TODO: ngarahin ke halaman detail
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value:
                                          false, // TODO: sesuain dgnt true false data
                                      onChanged: (bool? value) {
                                        setState(() {
                                          value =
                                              value!; // TODO: gue ga ngerti sih ini apa suyuyurnya
                                        });
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data![index].title),
                                  )
                                ],
                              ))),
                    );
                  }));
                }
              }
              return Text('Belum ada yang ditonton');
            })));
  }
}
