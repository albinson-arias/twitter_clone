class AppWriteConstants {
  static const String databaseId = '6427982656eb519a6a3f';
  static const String projectId = '6426f2665d38966ebea5';
  static const String endPoint = 'http://192.168.0.107:80/v1';
  static const String usersCollection = '64308f65e6679ca4959c';
  static const String tweetsCollection = '6431c0492ab88f4cda61';
  static const String imagesBucket = '6431c7436d97a691026d';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId';
}
