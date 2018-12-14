import 'package:flutter/material.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:mallsyok/screen/outlet_list_screen.dart';
import 'package:mallsyok/res/app_config.dart';

class SearchMallScreen extends StatefulWidget {
  final List<Mall> mallList;

  const SearchMallScreen({Key key, this.mallList}) : super(key: key);

  @override
  _SearchMallScreenState createState() => _SearchMallScreenState();
}

class _SearchMallScreenState extends State<SearchMallScreen> {
  TextEditingController _controller = TextEditingController();

  //List<Mall> _mallList = [];
  List<Mall> _mallListResult = [];
  bool _isSearching;
  FocusNode _focus = FocusNode();
  String _searchText;

  _SearchMallScreenState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    _isSearching = false;
    super.initState();
  }

  void _searchOperation(String searchText) {
    _searchMall(searchText);
  }

  Widget _showEmpty() {
    return new Container(width: 0.0, height: 0.0);
  }

  Widget _clearSearchField() {
    return FlatButton(
      child: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      onPressed: () {
        setState(
          () {
            _controller.clear();
            _isSearching = false;
          },
        );
      },
    );
  }

  void _searchMall(String searchText) {
    _mallListResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < widget.mallList.length; i++) {
        Mall data = widget.mallList[i];
        if (data.mallName.toLowerCase().contains(searchText.toLowerCase())) {
          _mallListResult.add(data);
        }
      }
    }
  }

  Widget _showMallListResult() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: _mallListResult.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: new Text(_mallListResult[index].mallName.toString()),
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) =>
                    OutletListPage(mall: _mallListResult[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _showSearchResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: _mallListResult.length != 0 && _controller.text.isNotEmpty
              ? _showMallListResult()
              : _showEmpty(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPink,
        brightness: Brightness.light,
        titleSpacing: 0.0,
        elevation: 1.0,
        leading: new IconButton(
          iconSize: 35.0,
          icon: Icon(Icons.chevron_left),
          tooltip: "Back",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: TextField(
          style: new TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          controller: _controller,
          focusNode: _focus,
          autofocus: true,
          onChanged: _searchOperation,
          decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.black45,
            ),
            border: InputBorder.none,
            hintText: "e.g. Gurney Plaza",
            hintStyle: new TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          _isSearching ? _clearSearchField() : _showEmpty(),
        ],
      ),
      body: _showSearchResult(),
    );
  }
}
