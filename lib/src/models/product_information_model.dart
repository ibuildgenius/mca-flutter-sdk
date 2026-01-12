class ProductInformationModel {
  final List<NeedToKnow> needToKnow;
  final List<HowItWorks> howItWorks;
  final List<Exclusion> exclusions;
  final List<HospitalGuide> hospitalGuide;

  ProductInformationModel({
    required this.needToKnow,
    required this.howItWorks,
    required this.exclusions,
    required this.hospitalGuide,
  });

  factory ProductInformationModel.fromJson(Map<String, dynamic> json) {
    return ProductInformationModel(
      needToKnow: List<NeedToKnow>.from(
        json['need_to_know'].map((x) => NeedToKnow.fromJson(x)),
      ),
      howItWorks: List<HowItWorks>.from(
        json['how_it_works'].map((x) => HowItWorks.fromJson(x)),
      ),
      exclusions: List<Exclusion>.from(
        json['exclusions'].map((x) => Exclusion.fromJson(x)),
      ),
      hospitalGuide: List<HospitalGuide>.from(
        json['hospital_guide'].map((x) => HospitalGuide.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'need_to_know': List<dynamic>.from(needToKnow.map((x) => x.toJson())),
      'how_it_works': List<dynamic>.from(howItWorks.map((x) => x.toJson())),
      'exclusions': List<dynamic>.from(exclusions.map((x) => x.toJson())),
      'hospital_guide':
          List<dynamic>.from(hospitalGuide.map((x) => x.toJson())),
    };
  }
}

class NeedToKnow {
  final NeedToKnowText title;
  final NeedToKnowText description;

  NeedToKnow({
    required this.title,
    required this.description,
  });

  factory NeedToKnow.fromJson(Map<String, dynamic> json) {
    return NeedToKnow(
      title: NeedToKnowText.fromJson(json['title']),
      description: NeedToKnowText.fromJson(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
      'description': description.toJson(),
    };
  }
}

class NeedToKnowText {
  final String text;

  NeedToKnowText({required this.text});

  factory NeedToKnowText.fromJson(Map<String, dynamic> json) {
    return NeedToKnowText(
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class HowItWorks {
  final NeedToKnowText title;

  HowItWorks({required this.title});

  factory HowItWorks.fromJson(Map<String, dynamic> json) {
    return HowItWorks(
      title: NeedToKnowText.fromJson(json['title']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
    };
  }
}

class Exclusion {
  final String ui;
  final NeedToKnowText title;
  final List<String> collection;

  Exclusion({
    required this.ui,
    required this.title,
    required this.collection,
  });

  factory Exclusion.fromJson(Map<String, dynamic> json) {
    return Exclusion(
      ui: json['ui'] ?? '',
      title: NeedToKnowText.fromJson(json['title']),
      collection: List<String>.from(json['collection'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ui': ui,
      'title': title.toJson(),
      'collection': collection,
    };
  }
}

class HospitalGuide {
  final NeedToKnowText title;
  final NeedToKnowText description;

  HospitalGuide({
    required this.title,
    required this.description,
  });

  factory HospitalGuide.fromJson(Map<String, dynamic> json) {
    return HospitalGuide(
      title: NeedToKnowText.fromJson(json['title']),
      description: NeedToKnowText.fromJson(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.toJson(),
      'description': description.toJson(),
    };
  }
}
