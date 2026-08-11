class SourcesModel {
  String author;
  String content;
  String UrlImage;
  String publishedAt;
  String? title;
  String? url;
  SourcesModel({
    required this.UrlImage,
    required this.author,
    required this.content,
    required this.publishedAt,
    required this.title,
    required this.url,
  });
  factory SourcesModel.fromJson(Map<String, dynamic> json) {
    return SourcesModel(
      UrlImage: json["urlToImage"] ?? "",
      author: json["author"] ?? " ",
      content: json["content"] ?? "",
      publishedAt: json["publishedAt"] ?? "",
      title: json["title"] ?? "",
      url: json["url"] ?? "",
    );
  }
}
