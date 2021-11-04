import 'package:flutter/material.dart';
import 'package:notsepeti/models/not_model.dart';
import 'package:notsepeti/pages/notdetay.dart';
import 'package:notsepeti/utils/database_helper.dart';

class Notlar extends StatefulWidget {
  const Notlar({Key? key}) : super(key: key);

  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late DatabaseHelper _databaseHelper;
  late List<Not> tumNotlar;

  @override
  void initState() {
    super.initState();
    tumNotlar = [];
    _databaseHelper = DatabaseHelper();
    _databaseHelper.notlariGetir().then((value){
      for (var item in value) {
        tumNotlar.add(Not.fromMap(item));

      }
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return tumNotlar.isNotEmpty? ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(tumNotlar[index].notBaslik),
                    leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Kategori ",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tumNotlar[index].kategoriBaslik,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Oluşturulma Tarihi ",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_databaseHelper.dateFormat(
                                      DateTime.parse(
                                          tumNotlar[index].notTarih))),
                                ),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tumNotlar[index].notIcerik!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _databaseHelper
                                          .notSil(tumNotlar[index].notID!)
                                          .then((value) => ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text("Not Silindi"))));
                                                      setState(() {
                                                        
                                                      });
                                    },
                                    child: const Text(
                                      "Sil",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotDetay(
                                                    baslik: "Not Düzenle",
                                                    not: tumNotlar[index],
                                                  )));
                                    },
                                    child: const Text(
                                      "Güncelle",
                                      style: TextStyle(color: Colors.green),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }):
          
          const    Center(
              child: CircularProgressIndicator(),
            );
          
        
  }

  _oncelikIconuAta(int index) {
    switch (index) {
      case 0:
        return CircleAvatar(
          child: const Text("Az", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent[100],
        );
      case 1:
        return const CircleAvatar(
          child: Text(
            "Orta",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        );
      case 2:
        return CircleAvatar(
          child: const Text("Acil", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent[900],
        );
    }
  }

}

/*
 FutureBuilder(
        future: _databaseHelper.notListesiniGetir(),
        builder: (BuildContext context, AsyncSnapshot<List<Not>> snapshot) {
          if (snapshot.hasData) {
            tumNotlar = snapshot.data!;

            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(tumNotlar[index].notBaslik),
                    leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Kategori ",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tumNotlar[index].kategoriBaslik,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Oluşturulma Tarihi ",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_databaseHelper.dateFormat(
                                      DateTime.parse(
                                          tumNotlar[index].notTarih))),
                                ),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tumNotlar[index].notIcerik!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _databaseHelper
                                          .notSil(tumNotlar[index].notID!)
                                          .then((value) => ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text("Not Silindi"))));
                                    },
                                    child: const Text(
                                      "Sil",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotDetay(
                                                    baslik: "Not Düzenle",
                                                    not: tumNotlar[index],
                                                  )));
                                    },
                                    child: const Text(
                                      "Güncelle",
                                      style: TextStyle(color: Colors.green),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
 */