class Films {
  final String title;
  final String releaseDate;

  // "title": "The Phantom Menace",
  // "episode_id": 1,
  // "opening_crawl": "Turmoil has engulfed the\r\nGalactic Republic. The taxation\r\nof trade routes to outlying star\r\nsystems is in dispute.\r\n\r\nHoping to resolve the matter\r\nwith a blockade of deadly\r\nbattleships, the greedy Trade\r\nFederation has stopped all\r\nshipping to the small planet\r\nof Naboo.\r\n\r\nWhile the Congress of the\r\nRepublic endlessly debates\r\nthis alarming chain of events,\r\nthe Supreme Chancellor has\r\nsecretly dispatched two Jedi\r\nKnights, the guardians of\r\npeace and justice in the\r\ngalaxy, to settle the conflict....",
  // "director": "George Lucas",
  // "producer": "Rick McCallum",
  // "release_date": "1999-05-19",

  Films({
    this.title,
    this.releaseDate,
  });

  factory Films.fromJson(Map<String, dynamic> json) {
    return Films(
      title: json['title'] as String,
      releaseDate: json['release_date'] as String,
    );
  }
}
