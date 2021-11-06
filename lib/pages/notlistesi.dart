
import 'package:flutter/material.dart';
import 'package:notsepeti/models/kategori_model.dart';
import 'package:notsepeti/pages/kategori_islemleri.dart';
import 'package:notsepeti/pages/notdetay.dart';
import 'package:notsepeti/pages/notlar.dart';
import 'package:notsepeti/utils/database_helper.dart';

class NotListesi extends StatefulWidget {
  const NotListesi({Key? key}) : super(key: key);

  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  late String newKategori;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Not Sepeti"), centerTitle: true, actions: [
        PopupMenuButton(itemBuilder: (context) {
          return [
             PopupMenuItem(
                child: ListTile(
              title: Text("Kategoriler"),
              leading: Icon(Icons.category),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Kategoriler()));
                },
            ))
          ];
        }),
      ]),
      floatingActionButton: _myWidget(),
      body: const Notlar(),
    );
  }

  Widget _myWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "btn2",
          tooltip: "Kategori Ekle",
          mini: true,
          onPressed: () {
            showDialog(
                barrierDismissible: false,
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
                              decoration: const InputDecoration(
                                  labelText: "Kategori Adı",
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
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                _databaseHelper
                                    .kategoriEkle(Kategori(newKategori))
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Eklendi")));
                                });
                                _databaseHelper
                                    .kategorileriGetir()
                                    .then((value) => print(value.toString()));
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Kaydet"),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                          )
                        ],
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.category),
        ),
        const SizedBox(
          height: 5,
        ),
        FloatingActionButton(
          heroTag: "btn1",
          tooltip: "Not Ekle",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotDetay(
                          baslik: "Not Ekle",
                        ))).then((value) {
              if (value) {
                setState(() {});
              }
            });
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
