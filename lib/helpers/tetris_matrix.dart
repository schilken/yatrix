class TetrisMatrix {
  final rowCount = 20;
  final colCount = 10;
  late final matrix = List.generate(
    rowCount,
    (row) => List.generate(colCount, (col) => ' '),
  );

  void add(int row, int col, String value) {
    matrix[row][col] = value;
  }

  int get level {
    for (var rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final row = matrix[rowIndex];
      if (row[4] == 'z' || row[5] == 'z' || row[6] == 'z') {
        return rowCount - rowIndex;
      }
    }
    return 0;
  }

  @override
  String toString() {
    final rowsAsString = <String>[];
    for (var row = 0; row < rowCount; row++) {
      final leadingZero = row < 10 ? '0' : '';
      rowsAsString.add(
        '$leadingZero$row: ${matrix[row].map((val) => val).join()}',
      );
    }
    return rowsAsString.join('\n');
  }

}
