class NewsArticle
{
  String source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;

  NewsArticle({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt
  });

  NewsArticle.fromJson(Map map)
  {
    source = map['source']['name'];
    author = map['author'];
    title = map['title'];
    description = map['description'];
    url = map['url'];
    urlToImage = map['urlToImage'];
    publishedAt = map['publishedAt'];
  }
}
