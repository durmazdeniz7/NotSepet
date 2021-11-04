import 'package:flutter/material.dart';
import 'package:notsepeti/models/kategori_model.dart';
import 'package:notsepeti/models/not_model.dart';
import 'package:notsepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  final String baslik;
  Not? not;
  NotDetay({this.not, required this.baslik, Key? key}) : super(key: key);

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;
  int value = 1;
  int oncelik = 0;
  late String notBaslik;
  String? notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    tumKategoriler = [];
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((value) {
      for (var item in value) {
        tumKategoriler.add(Kategori.fromMap(item));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.baslik),
        centerTitle: true,
      ),
      body: tumKategoriler.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Kategori : ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: DropdownButton(
                                items: kategoriItemleriolustur(),
                                value: widget.not != null
                                    ? widget.not!.kategoriID
                                    : value,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    value = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue:
                                widget.not != null ? widget.not!.notBaslik : "",
                            decoration: const InputDecoration(
                                labelText: "Not Başlık",
                                hintText: "Not Başlık Giriniz",
                                border: OutlineInputBorder()),
                            validator: (newString) {
                              if (newString!.length < 3) {
                                return "Başlık 3 Karakterden Küçük Olamaz";
                              }
                            },
                            onSaved: (newValue) {
                              notBaslik = newValue!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            initialValue:
                                widget.not != null ? widget.not!.notIcerik : "",
                            onSaved: (newValue) {
                              notIcerik = newValue;
                            },
                            style: const TextStyle(fontSize: 18),
                            maxLines: 5,
                            decoration: const InputDecoration(
                                labelText: "Not İçeriğini Giriniz",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Öncelik : ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: DropdownButton(
                                items: _oncelik
                                    .map((e) => DropdownMenuItem<int>(
                                        value: _oncelik.indexOf(e),
                                        child: Text(e)))
                                    .toList(),
                                value: widget.not != null
                                    ? widget.not!.notOncelik
                                    : oncelik,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    oncelik = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Vazgeç",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  if (widget.not == null) {
                                    databaseHelper
                                        .notEkle(Not(value, notBaslik,
                                            notIcerik, now.toString(), oncelik))
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Not Eklendi $value")));
                                      Navigator.pop(context,true);
                                      databaseHelper
                                          .notlariGetir()
                                          .then((value) => print(value));
                                      print(databaseHelper.dateFormat(now));
                                    });
                                  } else {
                                    databaseHelper
                                        .notGuncelle(Not.withID(
                                            widget.not!.notID,
                                            value,
                                            notBaslik,
                                            notIcerik,
                                            now.toString(),
                                            oncelik))
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Not Güncellendi")));
                                    });
                                    Navigator.pop(context,true);
                                  }
                                }
                              },
                              child: Text(
                                  widget.not != null ? "Güncelle" : "Kaydet"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[900]),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriolustur() {
    return tumKategoriler
        .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
              value: e.kategoriID,
              child: Text(
                e.kategoriBaslik,
                style: const TextStyle(fontSize: 20),
              ),
            ))
        .toList();
  }
}


/*
Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: DropdownButton<int>(
                  value: value,
                  items: kategoriItemleriolustur(),
                  onChanged: (choseCategoryId) {
                    setState(() {
                      value = choseCategoryId!;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
 */