import 'package:flutter/foundation.dart';

import 'package:twitter_clone/src/core/enums/tweet_type.dart';

@immutable
class Tweet {
  final String id;
  final String text;
  final List<String> hashTags;
  final String link;
  final List<String> imageLinks;
  final String userId;
  final TweetType type;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final int retweetCount;
  final String retweetedBy;
  final String replyTo;
  const Tweet({
    required this.id,
    required this.text,
    required this.hashTags,
    required this.link,
    required this.imageLinks,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.retweetCount,
    required this.retweetedBy,
    required this.replyTo,
  });

  Tweet copyWith({
    String? id,
    String? text,
    List<String>? hashTags,
    String? link,
    List<String>? imageLinks,
    String? userId,
    TweetType? type,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    int? retweetCount,
    String? retweetedBy,
    String? replyTo,
  }) {
    return Tweet(
      id: id ?? this.id,
      text: text ?? this.text,
      hashTags: hashTags ?? this.hashTags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      retweetCount: retweetCount ?? this.retweetCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashTags': hashTags,
      'link': link,
      'imageLinks': imageLinks,
      'userId': userId,
      'type': type.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'retweetCount': retweetCount,
      'retweetedBy': retweetedBy,
      'replyTo': replyTo,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      id: map['\$id'] as String,
      text: map['text'] as String,
      hashTags: List<String>.from((map['hashTags'] as List<dynamic>)),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      userId: map['userId'] as String,
      type: (map['type'] as String).toTweetType(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      commentIds: List<String>.from((map['commentIds'] as List<dynamic>)),
      retweetCount: map['retweetCount'] as int,
      retweetedBy: map['retweetedBy'] as String? ?? '',
      replyTo: map['replyTo'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'Tweet(id: $id, text: $text, hashTags: $hashTags, link: $link, imageLinks: $imageLinks, userId: $userId, type: $type, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, retweetCount: $retweetCount, retweetedBy: $retweetedBy, replyTo: $replyTo)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        listEquals(other.hashTags, hashTags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.userId == userId &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.retweetCount == retweetCount &&
        other.retweetedBy == retweetedBy &&
        other.replyTo == replyTo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        hashTags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        retweetCount.hashCode ^
        retweetedBy.hashCode ^
        replyTo.hashCode;
  }
}
