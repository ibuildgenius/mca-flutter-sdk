import 'dart:io';

import 'package:flutter/foundation.dart'; // listEquals

@immutable
class DamagedAreaPart {
  final String area;
  final List<Part> parts;

  const DamagedAreaPart({required this.area, required this.parts});

  factory DamagedAreaPart.fromJson(Map<String, dynamic> json) {
    final rawParts = json['parts'];
    return DamagedAreaPart(
      area: (json['area'] as String? ?? '').trim(),
      parts: rawParts is List
          ? rawParts
              .whereType<Map>() // ignore stray items
              .map((e) => Part.fromJson(Map<String, dynamic>.from(e)))
              .toList(growable: false)
          : const <Part>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'area': area,
        'parts': parts.map((e) => e.toJson()).toList(growable: false),
      };

  DamagedAreaPart copyWith({String? area, List<Part>? parts}) =>
      DamagedAreaPart(area: area ?? this.area, parts: parts ?? this.parts);

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      o is DamagedAreaPart && area == o.area && listEquals(parts, o.parts);

  @override
  int get hashCode => Object.hash(area, Object.hashAll(parts));
}

@immutable
class Part {
  final String name;
  final String sampleImage;

  const Part({required this.name, required this.sampleImage});

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        name: (json['name'] as String? ?? '').trim(),
        sampleImage: (json['sample_image'] as String? ?? '').trim(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'sample_image': sampleImage,
      };

  Part copyWith({String? name, String? sampleImage}) => Part(
      name: name ?? this.name, sampleImage: sampleImage ?? this.sampleImage);

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      o is Part && name == o.name && sampleImage == o.sampleImage;

  @override
  int get hashCode => Object.hash(name, sampleImage);
}

class Damage {
  final String damageArea;
  final String damagePart;
  final String farRange;
  final String closeRange;
  final File? farRangeFile;
  final File? closeRangeFile;

  Damage({
    required this.damageArea,
    required this.damagePart,
    required this.farRange,
    required this.closeRange,
    this.farRangeFile,
    this.closeRangeFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'damage_area': damageArea,
      'damage_part': damagePart,
      'far_range': farRange,
      'close_range': closeRange,
    };
  }

  Damage copyWith({
    String? damageArea,
    String? damagePart,
    String? farRange,
    String? closeRange,
    File? farRangeFile,
    File? closeRangeFile,
  }) {
    return Damage(
      damageArea: damageArea ?? this.damageArea,
      damagePart: damagePart ?? this.damagePart,
      farRange: farRange ?? this.farRange,
      closeRange: closeRange ?? this.closeRange,
      farRangeFile: farRangeFile ?? this.farRangeFile,
      closeRangeFile: closeRangeFile ?? this.closeRangeFile,
    );
  }
}
