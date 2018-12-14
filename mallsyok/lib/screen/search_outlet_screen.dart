import 'package:flutter/material.dart';
import 'package:mallsyok/model/outlet.dart';
import 'package:mallsyok/screen/outlet_details_screen.dart';
import 'package:mallsyok/res/app_config.dart';

class SearchOutletScreen extends StatefulWidget {
  final List<Outlet> outletList;

  const SearchOutletScreen({Key key, this.outletList}) : super(key: key);

  @override
  _SearchOutletScreenState createState() => _SearchOutletScreenState();
}

class _SearchOutletScreenState extends State<SearchOutletScreen> {
  TextEditingController _controller = TextEditingController();

  //List<Outlet> _outletList = [];
  List<Outlet> _outletListResult = [];
  bool _isSearching;
  FocusNode _focus = FocusNode();
  String _searchText;

  _SearchOutletScreenState() {
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
    _searchOutlet(searchText);
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

  void _searchOutlet(String searchText) {
    _outletListResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < widget.outletList.length; i++) {
        Outlet data = widget.outletList[i];
        if (data.outletName.toLowerCase().contains(searchText.toLowerCase())) {
          _outletListResult.add(data);
        }
      }
    }
  }

  Widget _showOutletListResult() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: _outletListResult.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: new Text(_outletListResult[index].outletName.toString()),
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) =>
                    OutletDetailsScreen(outlet: _outletListResult[index]),
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
          child: _outletListResult.length != 0 && _controller.text.isNotEmpty
              ? _showOutletListResult()
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
          cursorColor: Colors.white,
          style: new TextStyle(color: Colors.white),
          controller: _controller,
          focusNode: _focus,
          autofocus: true,
          onChanged: _searchOperation,
          decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: InputBorder.none,
            hintText: "e.g. McDonalds",
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
