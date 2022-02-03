final String tableImage = 'tblImage';

class ImageFields {
  static final List<String> values = [
    /// Add all fields
    id, path
  ];

  static final String id = 'id';
  static final String path = 'path';
}

class ImageModel {
  final int id;
  final String path;

  const ImageModel({
    required this.id,
    required this.path,
  });

  ImageModel copy({
    int? id,
    String? path,
  }) =>
      ImageModel(
        id: id ?? this.id,
        path: path ?? this.path,
      );

  static ImageModel fromJson(Map<String, Object?> json) => ImageModel(
        id: json[ImageFields.id] as int,
        path: json[ImageFields.path] as String,
      );

  Map<String, Object?> toJson() => {ImageFields.id: id, ImageFields.path: path};
}
