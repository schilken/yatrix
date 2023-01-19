class TetrisMatrix {
  final rows = 21;
  final cols = 10;
  late final matrix = List.generate(
    rows,
    (i) => List.generate(cols, (j) => ' '),
  );

  void add(int i, int j, String value) {
    matrix[i][j] = value;
  }

  @override
  String toString() {
    final rowsAsString = <String>[];
    for (var i = 0; i < rows; i++) {
      final leadingZero = i < 10 ? '0' : '';
      rowsAsString.add(
        '$leadingZero$i: ${matrix[i].map((val) => val).join()}',
      );
    }
    return rowsAsString.join('\n');
  }
}
