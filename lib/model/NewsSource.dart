class NewsSource
{
  String id;
  String name;
  String description;
  String url;
  String category;
  String language;
  String country;

  NewsSource({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  NewsSource.fromJson(Map map)
  {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    url = map['url'];
    category = map['category'];
    language = map['language'];
    country = map['country'];
  }
}
