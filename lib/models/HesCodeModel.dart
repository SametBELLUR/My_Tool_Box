final String tableHes = 'tblHes';

class HesFields {
  static final List<String> values = [
    /// Add all fields
    id, hes
  ];

  static final String id = 'id';
  static final String hes = 'hes';
}

class HesCodeModel {
  final int id;
  final String hes;

  const HesCodeModel({
    required this.id,
    required this.hes,
  });

  HesCodeModel copy({
    int? id,
    String? hes,
  }) =>
      HesCodeModel(
        id: id ?? this.id,
        hes: hes ?? this.hes,
      );

  static HesCodeModel fromJson(Map<String, Object?> json) => HesCodeModel(
        id: json[HesFields.id] as int,
        hes: json[HesFields.hes] as String,
      );

  Map<String, Object?> toJson() => {HesFields.id: id, HesFields.hes: hes};
}
