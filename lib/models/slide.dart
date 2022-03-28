class Slide {
  String name;
  String image;

  Slide(this.name, this.image);
}

List<Slide> getSlideList() {
  return <Slide>[
    Slide(
      "Slide1",
      "assets/images/slide1.jpg",
    ),
    Slide(
      "Slide2",
      "assets/images/slide2.jpg",
    ),
    Slide(
      "Slide3",
      "assets/images/slide3.jpg",
    ),
  ];
}
