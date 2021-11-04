class Kategori {
  int? kategoriID;
  String kategoriBaslik;

  Kategori(this.kategoriBaslik);
  Kategori.witgID(this.kategoriID, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["kategoriID"] = kategoriID;
    map["kategoriBaslik"] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map)
      :
      kategoriID=map["kategoriID"],
       kategoriBaslik = map["kategoriBaslik"];

  @override
  String toString() {
    return "KategoriID $kategoriID KategoriBaslik $kategoriBaslik";
  }
}
