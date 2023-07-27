class RatingAndComment {
  final int id;
  final int score;
  final String comment;
  final int place;
  final int user;

  const RatingAndComment({
    required this.id,
    required this.score,
    required this.comment,
    required this.place,
    required this.user,
  });

  factory RatingAndComment.fromJson(Map<String, dynamic> json) {
    return RatingAndComment(
      id: json['id'],
      score: json['score'],
      comment: json['comment'],
      place: json['place'],
      user: json['user'],
    );
  }
}