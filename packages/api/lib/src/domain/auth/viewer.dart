/// Viewer is the signed-in user, identified by name.
class Viewer {
  const Viewer({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is Viewer && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'Viewer($id, $name)';
}
