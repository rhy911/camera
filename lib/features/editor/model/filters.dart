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
      Filters('Purpleish', [
        1,
        0,
        0,
        0,
        0,
        -0.4,
        1.3,
        -0.4,
        0,
        -0.1,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0
      ]),
    ];
  }
}
