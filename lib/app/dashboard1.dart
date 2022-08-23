import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sd_app_back_office_2022/setting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'services/local_storage_services.dart';
//import 'package:http_auth/http_auth.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

final LocalStorage storage = new LocalStorage('localstorage_app');

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //  primarySwatch: Colors.blue,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.black,
        fontFamily: 'Nunito',
      ),
      home: const dashboard(title: 'Home Page'),
    );
  }
}

class dashboard extends StatefulWidget {
  const dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  bool isfilter = false;
  var lstdashboart;

  List GeneralInformation = [];

  var lstSalesOverview = [];

  var lstCategories = [];

  List lstSalesByWeek = [];

  List lstSalesByDay = [];

  List lstSalesByHours = [];

  List lstModeofSales = [];

  List lstMenuItem = [];
  List lstdiscountinfo = [];
  List lstpromoperformance = [];
  List lsttopprodmix = [];
  List lstStoreSalesOverview = [];
  List lstPaymentInformation = [];

  bool isGeneralDetail = true;
  bool isSaleByMonth = false;
  bool isSalesByweek = false;
  bool isSalebyDay = false;
  bool isSalesbyHours = false;
  bool isModeOfSales = false;
  bool isCategory = false;
  bool isMenuItem = false;
  bool isStoreSalesOverView = true;
  bool isPaymnetType = false;
  bool isDiscountInformation = false;
  bool ispromoDiscount = false;
  bool isTop20ProductMix = false;

  @override
  void initState() {
    super.initState();
    final DateTime date = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    var newDate = new DateTime(date.year, date.month, date.day - 180);
    txtFromdate.text = formatter.format(newDate);
    txtTodate.text = formatter.format(now);
    selectedFromDate = newDate;

    getLocalStorage();
  }

  final txtFromdate = TextEditingController(text: DateTime.now().toString());
  final txtTodate = TextEditingController(text: DateTime.now().toString());

  DateTime selectedToDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();

  var lstStoreGroup = [];
  var ddlStoreGroup;

  var ddlStore;
  var lststore = [];

  var bg_body_color = "#121212";
  var bg_color = "#1F1B24";
  var bg_sub_color = "#121212";
  var text_Color = "#FFFFFF";
  var fontFamily = "Nunito";

  void getLocalStorage() async {
    //wait until ready
    await storage.ready;
    pageLoadData();
  }

  pageLoadData() {
    GetStoreGroup();
    GetStore();
  }

  //declaration end here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the dashboard object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isfilter = isfilter == false ? true : false;
                  showMdlFilter();
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: HexColor(bg_body_color), //HexColor("#1F1B24"),
            child: Column(
              children: [
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 0),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isStoreSalesOverView =
                                  isStoreSalesOverView == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Store Sales Overview",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isStoreSalesOverView)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isStoreSalesOverView =
                                                isStoreSalesOverView == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isStoreSalesOverView)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isStoreSalesOverView =
                                                isStoreSalesOverView == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isStoreSalesOverView)
                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstStoreSalesOverview.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstStoreSalesOverview[
                                                          index]['info'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstStoreSalesOverview[
                                                                index]['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Store Sales Overview
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isGeneralDetail =
                                  isGeneralDetail == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("General Info",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isGeneralDetail)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isGeneralDetail =
                                                isGeneralDetail == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isGeneralDetail)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isGeneralDetail =
                                                isGeneralDetail == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isGeneralDetail)
                          SizedBox(
                            height: 240,
                            child: GridView.builder(
                              itemCount: GeneralInformation.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              4)),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    GeneralInformation[index]
                                                        ['info'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: HexColor(
                                                            text_Color)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                if (GeneralInformation[index]
                                                            ['info'] !=
                                                        'TOTAL NO OF ORDERS' &&
                                                    GeneralInformation[index]
                                                            ['info'] !=
                                                        'NO OF CUSTOMERS' &&
                                                    GeneralInformation[index]
                                                            ['info'] !=
                                                        'NO OF VOIDED TRANSACTIONS')
                                                  Text(
                                                    "\$" +
                                                        GeneralInformation[
                                                                index]['amt']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.green),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                if (GeneralInformation[index]
                                                            ['info'] ==
                                                        'TOTAL NO OF ORDERS' ||
                                                    GeneralInformation[index]
                                                            ['info'] ==
                                                        'NO OF CUSTOMERS' ||
                                                    GeneralInformation[index]
                                                            ['info'] ==
                                                        'NO OF VOIDED TRANSACTIONS')
                                                  Text(
                                                    GeneralInformation[index]
                                                            ['amt']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.blue),
                                                    textAlign: TextAlign.center,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //General Information
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSaleByMonth =
                                  isSaleByMonth == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Sales By Month",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isSaleByMonth)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSaleByMonth =
                                                isSaleByMonth == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isSaleByMonth)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSaleByMonth =
                                                isSaleByMonth == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isSaleByMonth)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstSalesOverview.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 4),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lstSalesOverview[index]['info'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "\$" +
                                                    lstSalesOverview[index]
                                                            ['amt']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Sales By Month
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSalesByweek =
                                  isSalesByweek == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Sales By Week",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isSalesByweek)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalesByweek =
                                                isSalesByweek == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isSalesByweek)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalesByweek =
                                                isSalesByweek == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isSalesByweek)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstSalesByWeek.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              4)),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lstSalesByWeek[index]['info'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "\$" +
                                                    lstSalesByWeek[index]['amt']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Sales By Week
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSalebyDay = isSalebyDay == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Sales By Day",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isSalebyDay)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalebyDay = isSalebyDay == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isSalebyDay)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalebyDay = isSalebyDay == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isSalebyDay)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstSalesByDay.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              4)),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lstSalesByDay[index]['info'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "\$" +
                                                    lstSalesByDay[index]['amt']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Sales By Day
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSalesbyHours =
                                  isSalesbyHours == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Sales By Hours",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isSalesbyHours)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalesbyHours =
                                                isSalesbyHours == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isSalesbyHours)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isSalesbyHours =
                                                isSalesbyHours == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isSalesbyHours)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstSalesByHours.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 4),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lstSalesByHours[index]['info'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "\$" +
                                                    lstSalesByHours[index]
                                                            ['amt']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Sales By Hours
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: HexColor(bg_sub_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isModeOfSales =
                                  isModeOfSales == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 60,
                              color: HexColor(bg_color),
                              // alignment: Alignment.left,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Mode of Sales",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isModeOfSales)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isModeOfSales =
                                                isModeOfSales == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isModeOfSales)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isModeOfSales =
                                                isModeOfSales == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isModeOfSales)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstModeofSales.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 4),
                              ),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    child: GestureDetector(
                                      child: Card(
                                        elevation: 5.0,
                                        color: HexColor(bg_color),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lstModeofSales[index]['info'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "\$" +
                                                    lstModeofSales[index]['amt']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Mode of Sales
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCategory = isCategory == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Categories",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isCategory)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isCategory = isCategory == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isCategory)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isCategory = isCategory == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isCategory)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstCategories[index]
                                                          ['info'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstCategories[index]
                                                                ['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Categories
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMenuItem = isMenuItem == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Menu Items",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isMenuItem)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isMenuItem = isMenuItem == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isMenuItem)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isMenuItem = isMenuItem == true
                                                ? false
                                                : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isMenuItem)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstMenuItem.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstMenuItem[index]
                                                          ['item_desc'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    lstMenuItem[index]['qty']
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstMenuItem[index]
                                                                ['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Menu Items

                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPaymnetType =
                                  isPaymnetType == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Payment Types",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isPaymnetType)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPaymnetType =
                                                isPaymnetType == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isPaymnetType)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPaymnetType =
                                                isPaymnetType == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isPaymnetType)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstPaymentInformation.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstPaymentInformation[
                                                              index]
                                                          ['payment_name'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstPaymentInformation[
                                                                index]['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Payment Types
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isDiscountInformation =
                                  isDiscountInformation == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Discount Information",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isDiscountInformation)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isDiscountInformation =
                                                isDiscountInformation == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isDiscountInformation)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isDiscountInformation =
                                                isDiscountInformation == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isDiscountInformation)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstdiscountinfo.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstdiscountinfo[index]
                                                          ['disc_name'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstdiscountinfo[index]
                                                                ['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Discount Information
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              ispromoDiscount =
                                  ispromoDiscount == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Promotion Performance",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (ispromoDiscount)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            ispromoDiscount =
                                                ispromoDiscount == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!ispromoDiscount)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            ispromoDiscount =
                                                ispromoDiscount == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (ispromoDiscount)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lstpromoperformance.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lstpromoperformance[index]
                                                          ['promo_name'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    lstpromoperformance[index]
                                                            ['no_of_orders']
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lstpromoperformance[
                                                                index]['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Promotion Performance
                SizedBox(
                  // height: 500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: HexColor(bg_color),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isTop20ProductMix =
                                  isTop20ProductMix == true ? false : true;
                            });
                          },
                          child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              color: HexColor(bg_color),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text("Top 20 Product Mix",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(text_Color))),
                                    ),
                                  ),
                                  if (isTop20ProductMix)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isTop20ProductMix =
                                                isTop20ProductMix == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                  if (!isTop20ProductMix)
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: HexColor(text_Color),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isTop20ProductMix =
                                                isTop20ProductMix == true
                                                    ? false
                                                    : true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        if (isTop20ProductMix)
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              //   controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: lsttopprodmix.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: HexColor(bg_sub_color),
                                  //margin: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    FractionalOffset(0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      lsttopprodmix[index]
                                                          ['item_name'],
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              text_Color),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    lsttopprodmix[index]['qty']
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        lsttopprodmix[index]
                                                                ['amt']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            text_Color),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: fontFamily,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ), //Top 20 Product Mix
              ],
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  //api and function start here
  GetStoreGroup() async {
    final response = await http.get(Uri.parse(
      api_url +
          "/GetStoreGroup/01?sessionid=" +
          storage.getItem('sessionId') +
          '&storegroup=%',
    ));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      setState(() {
        lstStoreGroup = jsonData['data'][0]['output'];
        /*  var first_row = List.of(lstStoreGroup);
        first_row[0]['store_group'] = "All Store Group";*/
        lstStoreGroup.insert(0, {"store_group": "All Store Group"});
        ddlStoreGroup = "All Store Group";
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  GetStore() async {
    final response = await http.get(Uri.parse(
      api_url +
          "/GetStore/01?sessionid=" +
          storage.getItem('sessionId') +
          '&storename=%',
    ));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      setState(() {
        lststore = jsonData['data'][0]['output'];
        /*  var first_row = List.of(lstStoreGroup);
        first_row[0]['store_group'] = "All Store Group";*/
        lststore.insert(0, {"store_name": "All Store"});
        ddlStore = "All Store";
        GetDashboardDtls();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;

        final DateTime now = picked;
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        txtFromdate.text = formatter.format(now);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;

        final DateTime now = picked;
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        txtTodate.text = formatter.format(now);
      });
    }
  }

  GetDashboardDtls() async {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');

    var txtFromdate = formatter.format(selectedFromDate);
    var txtTodate = formatter.format(selectedToDate);

    var store_name = "";
    if (ddlStoreGroup != "All Store Group" &&
        ddlStoreGroup != null &&
        ddlStore == "All Store") {
      var store_json = [];
      for (var s1 in lststore) {
        store_json.add(
            {"store_name": s1['store_name'] == null ? "" : s1['store_name']});
      }
      ;
      store_name = jsonEncode(store_json);
    } else {
      store_name = ddlStore == 'All Store'
          ? '%'
          : jsonEncode([
              {"store_name": ddlStore ?? ""}
            ]);
    }
    print(store_name);
    final response = await http.get(Uri.parse(
      api_url +
          "/GetDashboardDtls/01?sessionid=" +
          storage.getItem('sessionId') +
          '&storename=' +
          store_name +
          '&startdate=' +
          txtFromdate +
          '&enddate=' +
          txtTodate,
    ));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      setState(() {
        lstdashboart = jsonData['output'];

        GeneralInformation = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'General Information';
        }));
        if (GeneralInformation.isNotEmpty) {
          GeneralInformation = GeneralInformation[0]['details'];
        }
        lstSalesOverview = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales Overview';
        }));
        if (lstSalesOverview.isNotEmpty) {
          lstSalesOverview = lstSalesOverview[0]['details'];
        }

        lstCategories = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Categories';
        }));
        if (lstCategories.length > 0) {
          lstCategories = lstCategories[0]['details'];
        }

        lstSalesByWeek = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Week';
        }));
        if (lstSalesByWeek.isNotEmpty) {
          lstSalesByWeek = lstSalesByWeek[0]['details'];
        }

        lstSalesByDay = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Day';
        }));
        if (lstSalesByDay.isNotEmpty) {
          lstSalesByDay = lstSalesByDay[0]['details'];
        }

        lstSalesByHours = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Hours';
        }));
        if (lstSalesByHours.isNotEmpty) {
          lstSalesByHours = lstSalesByHours[0]['details'];
        }

        lstModeofSales = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Mode of Sales';
        }));
        if (lstModeofSales.isNotEmpty) {
          lstModeofSales = lstModeofSales[0]['details'];
        }

        lstMenuItem = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Menu Item';
        }));
        if (lstMenuItem.isNotEmpty) {
          lstMenuItem = lstMenuItem[0]['details'];
        }

        lstdiscountinfo = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Discount Information';
        }));
        if (lstdiscountinfo.isNotEmpty) {
          lstdiscountinfo = lstdiscountinfo[0]['details'];
        }

        lstpromoperformance = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Promotion Performance';
        }));
        if (lstpromoperformance.isNotEmpty) {
          lstpromoperformance = lstpromoperformance[0]['details'];
        }

        lsttopprodmix = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Top 20 Product Mix';
        }));
        if (lsttopprodmix.isNotEmpty) {
          lsttopprodmix = lsttopprodmix[0]['details'];
        }

        lstStoreSalesOverview = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Store Sales Overview';
        }));
        if (lstStoreSalesOverview.isNotEmpty) {
          lstStoreSalesOverview = lstStoreSalesOverview[0]['details'];
        }

        lstPaymentInformation = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Payment Information';
        }));
        if (lstPaymentInformation.isNotEmpty) {
          lstPaymentInformation = lstPaymentInformation[0]['details'];
        }
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void showMdlFilter() {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Container(
                // color: Colors.black,
                child: SizedBox(
                  height: 446,
                  width: 1000,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Store Group",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "Nunito"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "Nunito"),
                          value: ddlStoreGroup,
                          onChanged: (newValue) {
                            setState(() {
                              ddlStoreGroup = newValue;
                            });
                          },
                          items: lstStoreGroup.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem['store_group'],
                                child: Text(valueItem['store_group']));
                          }).toList(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text("Store Name",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Nunito"),
                              textAlign: TextAlign.left),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "Nunito"),
                          value: ddlStore,
                          onChanged: (newValue) {
                            setState(() {
                              ddlStore = newValue;
                            });
                          },
                          items: lststore.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem['store_name'],
                                child: Text(valueItem['store_name']));
                          }).toList(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: txtFromdate,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'From Date',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "Nunito")),
                            // onChanged: (val) => _selectDate(context),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: "Nunito"),
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTap: () async {
                              _selectFromDate(context);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: txtTodate,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'To Date',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "Nunito")),
                            // onChanged: (val) => _selectDate(context),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: "Nunito"),
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTap: () async {
                              _selectToDate(context);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontFamily: "Nunito"),
                                      )),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue),
                                        onPressed: () {
                                          setState(() {
                                            isfilter = false;
                                            GetDashboardDtls();
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: const Text("View",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontFamily: "Nunito"))),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
