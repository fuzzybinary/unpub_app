import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameSearchBar extends StatefulWidget {
  final ValueChanged<String> onTextChanged;

  const GameSearchBar({Key key, this.onTextChanged}) : super(key: key);

  @override
  _GameSearchBarState createState() => _GameSearchBarState();
}

class _GameSearchBarState extends State<GameSearchBar> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onTextChanged(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        maxLines: 1,
        focusNode: _searchFocusNode,
        controller: _searchController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
          ),
          suffixIcon: _searchFocusNode.hasFocus
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.text = '';
                      _searchFocusNode.unfocus();
                      widget.onTextChanged('');
                    });
                  },
                )
              : null,
          hintText: 'Search',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 4),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
