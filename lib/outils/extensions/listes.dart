extension ListesExtension on List {
  removeOrAdd(dynamic child) {
    if (this.contains(child)) {
      this.remove(child);
    } else {
      this.add(child);
    }
  }

  dynamic? firstOrNullListe() {
    if (this.isEmpty) return null;
    return this.first;
  }

  dynamic? firstWhereOrNullListe(bool Function(dynamic element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
