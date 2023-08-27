enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);
}

extension ConvertTweetType on String {
  TweetType toTweetType() {
    return TweetType.values.firstWhere((element) => element.type == this);
  }
}
