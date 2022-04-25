import 'package:scrabble/ai/Node.dart';

class Edge {
  String label;
  Node nextNode;
  bool isTerminal;

  Edge(this.label, this.nextNode, this.isTerminal);

  @override
  bool operator ==(Object other) => other is Edge
      && other.label == label
      && other.nextNode == nextNode
      && other.isTerminal == isTerminal;

  @override
  int get hashCode => label.hashCode + nextNode.hashCode + isTerminal.hashCode;
}
