class Filters {
  final String name;
  final List<double> matrix;

  Filters(this.name, this.matrix);

  static list() {}
}

class FilterGroup {
  List<Filters> list() {
    return <Filters>[
      Filters(
          'None', [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]),
      Filters('Black&White',
          [0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0]),
      Filters('Purple',
          [1, 0, 0, 0, 0, -0.3, 1, -0.1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]),
      Filters('Vintage', [
        0.4,
        0.8,
        0.2,
        0,
        0,
        0.4,
        0.7,
        0.1,
        0,
        0,
        0.3,
        0.5,
        0.1,
        0,
        0,
        0,
        0,
        0,
        1,
        0
      ]),
      Filters('Cold',
          [1.2, 0, 0, 0, 0, 0, 0.8, 0.6, 0, 0, 0, 0, 3.6, 0, 0, 0, 0, 0, 1, 0]),
      Filters('Warm',
          [1, 0.3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 1, 0]),
    ];
  }
}
