import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/service/service_outlet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:mallsyok/model/outlet.dart';
import 'package:mallsyok/screen/outlet_details_screen.dart';
import 'package:mallsyok/screen/search_outlet_screen.dart';
import 'package:mallsyok/common_widget/platform_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Result { NOT_DETERMINED, FOUND, NOT_FOUND }

class OutletListPage extends StatefulWidget {
  final Mall mall;

  const OutletListPage({Key key, this.mall}) : super(key: key);

  @override
  _OutletListPageState createState() => _OutletListPageState();
}

class _OutletListPageState extends State<OutletListPage> {
  Result resultState = Result.NOT_DETERMINED;
  List<Outlet> _outletList = [];
  List<Outlet> _filteredOutletList = [];
  List<Category> _categoryList = [];
  String letterHead = "0";

  Widget _searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: AppConfig.TEXT_SEARCH_MALL,
      onPressed: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => SearchOutletScreen(
                  outletList: _outletList,
                ),
          ),
        );
      },
    );
  }

  void _onEntryAdded(QuerySnapshot event) {
    if (event.documents.length > 0) {
      _outletList.addAll(
          event.documents.map((snapshot) => Outlet.fromSnapshot(snapshot)));

      // Make a working copy for filtered outletlist
      _filteredOutletList = new List<Outlet>.from(_outletList);

      setState(() {
        resultState = Result.FOUND;
      });
    } else {
      if (resultState == Result.NOT_DETERMINED) {
        setState(() {
          resultState = Result.NOT_FOUND;
        });
      }
    }
  }

  @override
  void initState() {
    // Reset result state
    resultState = Result.NOT_DETERMINED;

    // Create category list
    createCategoryList();

    // Set All Category as selected
    _categoryList[0].isTapped = true;

    // Get outlet list
    ServiceOutlet().getOutletList(widget.mall.key, _onEntryAdded);

    super.initState();
  }

  Widget buildBody(double width) {
    if (resultState == Result.FOUND) {
      return showResult(width);
    } else if (resultState == Result.NOT_FOUND) {
      return showNoResult();
    }
    return showLoading();
  }

  Widget showNoResult() {
    return new Center(
      child: Text(
        "No Result",
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }

  void showOutletByCategory(String category) {
    _filteredOutletList.clear();

    if (category == AppConfig.TEXT_CATEGORY_ALL){
      _filteredOutletList = new List<Outlet>.from(_outletList);
    } else {
      for (int i = 0; i < _outletList.length; i++) {
        if (_outletList[i].category == category) {
          _filteredOutletList.add(_outletList[i]);
        }
      }
    }

  }

  Widget showLoading() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLetterHead(String letter, double width) {
    return new Container(
      width: width,
      height: 40.0,
      color: kAppThemeColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 8.0, 0.0, 0.0),
        child: Text(
          letter,
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildListView(double width) {
    String firstLetter;
    return new Center(
        child: new ListView.builder(
      itemCount: _filteredOutletList.length,
      itemBuilder: (BuildContext context, int index) {
        firstLetter =
            _filteredOutletList[index].outletName.substring(0, 1).toUpperCase();

        if (double.tryParse(firstLetter) != null) {
          firstLetter = "#";
        }
        if (firstLetter != letterHead) {
          letterHead = firstLetter;
          return Column(
            children: <Widget>[
              buildLetterHead(letterHead, width),
              OutletCard(
                outlet: _filteredOutletList[index],
              )
            ],
          );
        }
        return OutletCard(
          outlet: _filteredOutletList[index],
        );
      },
    ));
  }

  Widget showResult(double width) {
    return Center(
      child: _filteredOutletList.length > 0 ? buildListView(width): showNoResult(),
    );
  }

  Widget buildCategory(double width, double headerHeight, double bodyHeight) {
    return Column(
      children: <Widget>[
        //buildCategoryHeader(width, headerHeight),
        buildCategoryBody(bodyHeight),
      ],
    );
  }

  Icon buildCategoryIcon(IconData icons) {
    return Icon(
      icons,
      color: kAppThemeColor,
      size: 50.0,
    );
  }

  void createCategoryList() {
    //All Category
    _categoryList.add(Category(AppConfig.TEXT_CATEGORY_ALL, Icons.apps));

    // Departmental Store
    _categoryList.add(Category(
        AppConfig.TEXT_CATEGORY_DEPARTMENT, Icons.local_grocery_store));

    // Beauty & Hair Salon
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_BEAUTY, FontAwesomeIcons.cut));

    // Personal Care & Pharmacy
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_PHARMACY, FontAwesomeIcons.firstAid));

    // Fitness & Wellness Centre
    // Health & Fitness Equipment
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_FITNESS, FontAwesomeIcons.dumbbell));

    // Cosmetics & Skincare
    _categoryList.add(Category(AppConfig.TEXT_CATEGORY_COSMETICS, Icons.face));

    // Digital Lifestyle
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_DIGITAL, Icons.desktop_mac));

    // Entertainment
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_ENTERTAINMENT, Icons.movie));
    // Fashion
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_FASHION, FontAwesomeIcons.shoePrints));

    // Financial Service & ATM
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_ATM, FontAwesomeIcons.piggyBank));

    // Food & Beverages
    _categoryList.add(Category(AppConfig.TEXT_CATEGORY_FOOD, Icons.fastfood));

    // Home & Living
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_HOME, FontAwesomeIcons.wrench));

    // Convenience & Services
    _categoryList.add(Category(
        AppConfig.TEXT_CATEGORY_CONVENIENCE, Icons.local_convenience_store));

    // Optical
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_OPTICS, FontAwesomeIcons.glasses));

    // Timepieces & Jewelleries
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_JEWELLERIES, FontAwesomeIcons.ring));

    // Books & Stationaries
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_BOOK, FontAwesomeIcons.book));

    // Toys & Hobbies
    _categoryList.add(Category(AppConfig.TEXT_CATEGORY_TOYS, Icons.toys));

    // Music & Instruments
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_MUSIC, Icons.music_note));

    // Gifts & Souvenirs
    _categoryList
        .add(Category(AppConfig.TEXT_CATEGORY_GIFTS, Icons.card_giftcard));

    // Office
    _categoryList.add(
        Category(AppConfig.TEXT_CATEGORY_OFFICE, FontAwesomeIcons.briefcase));
  }

  void resetAllCategory() {
    for (int i = 0; i < _categoryList.length; i++) {
      _categoryList[i].isTapped = false;
    }
  }

  Widget buildCategoryBody(double height) {
    double iconHeight = 60.0;
    bool isTapped;
    return new Container(
      height: height,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        itemCount: _categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          isTapped = _categoryList[index].isTapped;
          return GestureDetector(
            child: Container(
              color: Colors.white,
              width: height,
              child: Column(
                children: <Widget>[
                  Container(
                    height: iconHeight,
                    child: Icon(
                      _categoryList[index].iconData,
                      color: isTapped ? kAppTextColor : Colors.black45,
                      size: 30.0,
                    ),
                  ),
                  Container(
                    height: height - iconHeight,
                    child: new Text(
                      _categoryList[index].title,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: isTapped ? kAppTextColor : Colors.black45),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                resetAllCategory();
                _categoryList[index].isTapped = !_categoryList[index].isTapped;
                showOutletByCategory(_categoryList[index].title);
              });
            },
          );
        },
      ),
    );
  }

  Widget buildCategoryHeader(double width, double headerHeight) {
    return new Container(
      width: width,
      height: 40.0,
      color: kAppThemeColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 8.0, 0.0, 0.0),
        child: Text(
          "Category",
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double categoryBodyHeight = 100.0;
    double categoryHeaderHeight = 40.0;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: kColorPink,
        title: new Text(
          widget.mall.mallName,
          style: new TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          _searchButton(),
        ],
        bottom: PreferredSize(
            child:
                buildCategory(width, categoryHeaderHeight, categoryBodyHeight),
            preferredSize: Size(0.0, categoryBodyHeight)),
      ),
      body: buildBody(width),
      drawer: PlatformDrawer(
        mall: widget.mall,
      ),
    );
  }
}

class OutletCard extends StatelessWidget {
  final Outlet outlet;

  const OutletCard({Key key, this.outlet}) : super(key: key);

  void navigateOutlet(BuildContext context, Mall mall) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => OutletListPage(mall: mall)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  OutletDetailsScreen(outlet: outlet)));
        },
        child: Column(
          children: <Widget>[
            // TODO : Compress image size
            ListTile(
              leading: CircleAvatar(
                backgroundColor: kColorPink,
                child: Text(
                  outlet.outletName.substring(0, 1),
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              title: Text(
                outlet.outletName,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                outlet.unitNumber,
                style: new TextStyle(
                  fontSize: 15.0,
                  color: kAppTextColor,
                ),
              ),
            ),
            Divider(),
          ],
        ));
  }
}

class Category {
  String title;
  IconData iconData;
  bool isTapped = false;

  Category(this.title, this.iconData);
}
