import 'package:scrabble/ai/Edge.dart';
import 'package:scrabble/ai/Node.dart';

class Dawg {
  late Node _rootNode;
  late List<Node> _register;

  Dawg() {
    _rootNode = Node([]);
    _register = [];
  }

  void addWords(List<String> words) {
    for (String word in words) {
      _addWord(word);
    }
    _replaceOrRegister(_rootNode);
  }

  void _addWord(String word) {
    List<Edge> prefix = _commonPrefix(word);
    Node lastState = prefix.isNotEmpty ? prefix.last.nextNode : _rootNode;
    String currentSuffix = word.substring(prefix.length);
    if (lastState.hasChildren())
      _replaceOrRegister(lastState);
    _addSuffix(lastState, currentSuffix);
  }

  /// This walks through the DAWG, finding the part of
  /// the word that is already in the DAWG, and returning
  /// the path that spells that prefix.
  List<Edge> _commonPrefix(String word) {
    List<Edge> prefix = [];
    Node currentNode = _rootNode;
    int currentLetterIndex = 0;
    bool searching = true;
    while (searching) {
      Edge? edge = currentNode.edgeWithLabel(word[currentLetterIndex]);
      if (edge != null) {
        prefix.add(edge);
        currentNode = edge.nextNode;
        currentLetterIndex++;
        if (currentLetterIndex >= word.length)
          searching = false;
      } else
        searching = false;
    }
    return prefix;
  }

  void _replaceOrRegister(Node state) {
    Node lastChild = state.lastChild;
    if (lastChild.hasChildren())
      _replaceOrRegister(lastChild);
    if (_register.contains(lastChild)) {
      state.lastChild = _register[_register.indexOf(lastChild)];
    } else {
      _register.add(lastChild);
    }
  }

  /// This adds the given string to the DAWG
  /// starting at the given node
  void _addSuffix(Node state, String suffix) {
    Node currentNode = state;
    for (int i=0;i<suffix.length;i++) {
      String c = suffix[i];
      Node n = Node([]);
      currentNode.addEdge(Edge(c, n, i == suffix.length - 1));
      currentNode = n;
    }
  }
}
