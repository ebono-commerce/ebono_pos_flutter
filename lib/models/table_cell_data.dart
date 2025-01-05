class TableCellData {
  final String title;
  final double width;
  final int maxLines;

  const TableCellData({
    required this.title,
    required this.width,
    this.maxLines = 1,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'width': width,
      'maxLines': maxLines,
    };
  }

  factory TableCellData.fromMap(Map<String, dynamic> map) {
    return TableCellData(
      title: map['title'] ?? "",
      width: map['width'] ?? 0.0,
      maxLines: map['maxLines'] ?? 0,
    );
  }
}
