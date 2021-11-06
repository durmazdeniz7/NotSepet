import 'package:flutter/material.dart';
import 'package:notsepeti/models/kategori_model.dart';
import 'package:notsepeti/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({Key? key}) : super(key: key);

  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori> tumKategoriler = [];
  late DatabaseHelper _databaseHelper;
  var formKey = GlobalKey<FormState>();
  late String newKategori;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    tumKategoriler = [];
    _kategoriListesiniGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategoriler"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tumKategoriler.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white30,
            elevation: 2,
            child: ListTile(
              onTap: () =>_kategoriGuncelle(context,tumKategoriler[index]),
              title: Text(tumKategoriler[index].kategoriBaslik),
              trailing: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Kategori Silmeye Emin misiniz"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    "Bu Kategoriyi Sildiğiniz ilgili Notlarda Silinecektir Emin misiniz?"),
                                ButtonBar(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Vazgeç")),
                                    TextButton(
                                        onPressed: () {
                                          _databaseHelper
                                              .kategoriSil(tumKategoriler[index]
                                                  .kategoriID!)
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        "Kategori Silindi")));
                                          });
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Sil",
                                          style: TextStyle(color: Colors.green),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: const Icon(Icons.delete)),
            ),
          );
        },
      ),
    );
  }

  _kategoriListesiniGuncelle() {
    _databaseHelper.kategorileriGetir().then((value) {
      for (var item in value) {
        tumKategoriler.add(Kategori.fromMap(item));
      }
      setState(() {});
    });
  }

  _kategoriGuncelle(BuildContext context, Kategori kategori) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: kategori.kategoriBaslik,
                      decoration: const InputDecoration(
                          labelText: "Kategori Güncelle",
                          border: OutlineInputBorder()),
                      validator: (newValue) {
                        if (newValue!.length < 3) {
                          return "En az 3 karakter giriniz";
                        }
                      },
                      onSaved: (newValue) {
                        newKategori = newValue!;
                      },
                    ),
                  )),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Vazgeç"),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     
                        _databaseHelper
                            .kategoriGuncelle(kategori)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Güncellendi")));
                        });

                        Navigator.pop(context);
                      
                    },
                    child: const Text("Kaydet"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  )
                ],
              ),
            ],
          );
        });
  }
}
