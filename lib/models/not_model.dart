class Not {
  int? notID;
  int kategoriID;
  late String kategoriBaslik;
  String notBaslik;
  String? notIcerik;
  String notTarih;
  int notOncelik;

  Not(this.kategoriID, this.notBaslik, this.notIcerik, this.notTarih,
      this.notOncelik);
  Not.withID(this.notID, this.kategoriID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["kategoriID"] = kategoriID;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik ?? "";
    map["notTarih"] = notTarih;
    map["notOncelik"] = notOncelik;
    return map;
  }

  Not.fromMap(Map<String, dynamic> map)
      : notID = map["notID"],
        kategoriID = map["kategoriID"],
        kategoriBaslik = map["kategoriBaslik"],
        notBaslik = map["notBaslik"],
        notIcerik = map["notIcerik"],
        notTarih = map["notTarih"],
        notOncelik = map["notOncelik"];

  @override
  String toString() {
    return "Not notId $notID kategoriId $kategoriID notBaslik $notBaslik";
  }
}
