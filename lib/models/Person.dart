class Person {
  final String? name;
  final String? birthYear;
  final String? height;
  final String? mass;
  final String? hairColor;
  final String? skinColor;
  final String? eyeColor;
  final String? gender;
  final List<dynamic>? films;

  Person(
      {this.name,
      this.birthYear,
      this.height,
      this.mass,
      this.hairColor,
      this.skinColor,
      this.eyeColor,
      this.gender,
      this.films,});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String?,
      birthYear: json['birth_year'] as String?,
      height: json['height'],
      mass: json['mass'],
      hairColor: json['hair_color'] as String?,
      skinColor: json['skin_color'] as String?,
      eyeColor: json['eye_color'] as String?,
      gender: json['gender'] as String?,
      films: json['films'] as List<dynamic>?,
    );
  }
}
