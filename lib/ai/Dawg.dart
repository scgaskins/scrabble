import 'package:scrabble/ai/Edge.dart';
import 'package:scrabble/ai/Node.dart';

class Dawg {
  late Node rootNode;
  late Map<int, Node> _register;

  Dawg(List<String> words) {
    rootNode = Node([]);
    _register = {};
    _addWords(words);
  }

  /// The DAWG contains a word if there is a path
  /// containing all the letters of the word in order
  /// that ends with a terminal node
  bool contains(String word) {
    Node currentNode = rootNode;
    for (int i=0; i<word.length; i++) {
      String c = word[i];
      Edge? edgeWithC = currentNode.edgeWithLabel(c);
      if (edgeWithC != null) {
        if (i == word.length - 1 && edgeWithC.isTerminal)
          return true;
        currentNode = edgeWithC.nextNode;
      } else
        return false;
    }
    return false;
  }

  /// Checks if there are any words in the DAWG that
  /// start with prefix
  bool containsPrefix(String prefix) {
    Node currentNode = rootNode;
    for (int i=0; i<prefix.length; i++) {
      String c = prefix[i];
      Edge? edgeWithC = currentNode.edgeWithLabel(c);
      if (edgeWithC != null) {
        if (i == prefix.length - 1)
          return true;
        currentNode = edgeWithC.nextNode;
      } else
        return false;
    }
    return false;
  }

  void _addWords(List<String> words) {
    for (String word in words) {
      _addWord(word);
    }
    _replaceOrRegister(rootNode);
    _register.clear();
  }

  void _addWord(String word) {
    List<Edge> prefix = _commonPrefix(word);
    Node lastState = prefix.isNotEmpty ? prefix.last.nextNode : rootNode;
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
    Node currentNode = rootNode;
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

  /// This prunes off identical paths in the DAWG
  /// If the most recently added child of the input node
  /// is identical to a node in the register, it is replaced
  /// with that node, otherwise it is stored in the register
  void _replaceOrRegister(Node state) {
    Node lastChild = state.lastChild;
    if (lastChild.hasChildren())
      _replaceOrRegister(lastChild);
    if (_register.containsKey(lastChild.hashCode)) {
      state.lastChild = _register[lastChild.hashCode]!;
    } else {
      _register.putIfAbsent(lastChild.hashCode, () => lastChild);
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
