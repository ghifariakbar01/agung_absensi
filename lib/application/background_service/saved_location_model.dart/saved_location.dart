class SavedLocation {
  SavedLocation({
    required this.data,
  });
  late final List<Saved> data;

  SavedLocation.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Saved.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Saved {
  Saved({
    required this.date,
    required this.outAbsen,
    required this.inAbsen,
  });

  late final String date;
  late final bool outAbsen;
  late final bool inAbsen;

  Saved.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    outAbsen = json['out'];
    inAbsen = json['in'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['date'] = date;
    _data['out'] = outAbsen;
    _data['in'] = inAbsen;
    return _data;
  }
}
