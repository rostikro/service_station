class Work {
  final String uid;
  final String title;
  final int price;
  int detailPrice = 0;
  final double time;
  final String image;
  final String imageDownloadUrl;

  Work({ required this.uid, required this.title, required this.price, required this.time, required this.image, required this.imageDownloadUrl });
}