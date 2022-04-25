import 'package:scrabble/ai/Edge.dart';

class Node {
  List<Edge> edges;

  Node(this.edges);

  Edge? edgeWithLabel(String label) {
    for (Edge edge in edges) {
      if (edge.label == label)
        return edge;
    }
  }

  void addEdge(Edge edge) {
    edges.add(edge);
  }

  bool hasChildren() => edges.isNotEmpty;

  Node get lastChild => edges.last.nextNode;

  set lastChild(Node n) {
    edges.last.nextNode = n;
  }

  @override
  bool operator ==(Object other) {
    if (other is Node && other.edges.length == edges.length) {
      for (int i=0;i<edges.length;i++) {
        if (other.edges[i] != edges[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => edges.fold(0, (hash, edge) => hash + edge.hashCode);
}
