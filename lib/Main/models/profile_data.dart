class ProfileData {
  final String email;
  final String hierarchicalLevel;
  final String? profileImage;

  ProfileData({
    required this.email,
    required this.hierarchicalLevel,
    this.profileImage,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      email: json['User']['email'],
      hierarchicalLevel: json['HierarchicalLevel']['level'],
      profileImage: json['User']['profileImage'],
    );
  }
  @override
  String toString() {
    return 'ProfileData{profileImage: $profileImage, hierarchicalLevel: $hierarchicalLevel, email: $email}';
  }
}