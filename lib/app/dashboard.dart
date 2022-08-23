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
import '../main.dart';
import 'services/local_storage_services.dart';
//import 'package:http_auth/http_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

  List<clsChart> lstChartDataCategories = [];
  List<clsChart> lstChartDataSalesByMonth = [];
  List<clsChart> lstChartDataSalesByDay = [];
  List<clsChart> lstChartDataSalesByWeek = [];
  List<clsChart> lstChartDataSalesByHours = [];
  List<clsChart> lstChartDataModeOfPayment = [];
  List<clsChart1> lstChartDatTop20Product = [];

  List lstSalesOverview = [];
  List lstCategories = [];
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

  bool isChartSaleByMonth = false;
  bool isChartSaleByWeek = false;
  bool isChartSaleByDay = false;
  bool isChartSaleByHours = false;
  bool isChartModeOfPayment = false;
  bool isChartCategory = false;
  bool isChartTop20Product = false;

  void ischartdataview(val) {
    isChartSaleByMonth = val;
    isChartSaleByWeek = val;
    isChartSaleByDay = val;
    isChartSaleByHours = val;
    isChartModeOfPayment = val;
    isChartCategory = val;
    isChartTop20Product = val;
  }

  var _tooltipBehaviorMonthly;
  var _tooltipBehaviorSalesByweek;
  var _tooltipBehaviorSalesByDay;
  var _tooltipBehaviorSalesByHorus;
  var _tooltipBehaviorModeOfSales;
  var _tooltipBehaviorCategory;
  var _tooltipBehaviorTop20Product;
  var _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehaviorMonthly = TooltipBehavior(enable: true);
    _tooltipBehaviorSalesByweek = TooltipBehavior(enable: true);
    _tooltipBehaviorSalesByDay = TooltipBehavior(enable: true);
    _tooltipBehaviorSalesByHorus = TooltipBehavior(enable: true);
    _tooltipBehaviorModeOfSales = TooltipBehavior(enable: true);
    _tooltipBehaviorCategory = TooltipBehavior(enable: true);
    _tooltipBehaviorTop20Product = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true);

    final DateTime date = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    var newDate = new DateTime(date.year, date.month, date.day - 180);
    txtFromdate.text = formatter.format(newDate);
    txtTodate.text = formatter.format(now);
    selectedFromDate = newDate;

    getLocalStorage();
  }

  // Initial Selected Value
  String ddlDiscplayby = 'Data';

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
  var lstLoginUserInfo = [];
  void getLocalStorage() async {
    //wait until ready
    await storage.ready;
    lstLoginUserInfo = storage.getItem('login_user_details');
    pageLoadData();
  }

  pageLoadData() {
    GetStoreGroup();
    GetStore();
  }

  _getSeriesData() {
    List<charts.Series<clsChart, String>> series = [
      charts.Series(
        id: "salesByMonth",
        data: lstChartDataSalesByWeek,
        domainFn: (clsChart series, _) => series.info.toString(),
        measureFn: (clsChart series, _) => series.amt,
        // colorFn: (PopulationData series, _) => series.barColor
      )
    ];
    return series;
  }

  //declaration end here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the dashboard object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lstLoginUserInfo.length > 0
                    ? lstLoginUserInfo[0]['comp_name']
                    : "",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, color: Colors.orange),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showProfileInfo();
              });
            },
          ),
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
                                      child: Row(
                                        children: [
                                          Text("Sales By Month",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isSaleByMonth)
                                            IconButton(
                                              icon: Icon(
                                                isChartSaleByMonth == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size:
                                                    isChartSaleByMonth == false
                                                        ? 25
                                                        : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartSaleByMonth =
                                                      isChartSaleByMonth == true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartSaleByMonth && isSaleByMonth)
                          SizedBox(
                            height: 300,
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
                        if (isChartSaleByMonth && isSaleByMonth)
                          SizedBox(
                              height: 200,
                              child: SfCartesianChart(
                                selectionType: SelectionType.point,
                                tooltipBehavior: _tooltipBehaviorMonthly,
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries>[
                                  LineSeries<clsChart, String>(
                                      enableTooltip: true,
                                      markerSettings:
                                          MarkerSettings(isVisible: true),
                                      dataLabelSettings: DataLabelSettings(
                                          // Renders the data label
                                          isVisible: false),
                                      dataSource: lstChartDataSalesByMonth,
                                      // Bind the color for all the data points from the data source
                                      pointColorMapper: (clsChart data, _) =>
                                          Colors.red,
                                      xValueMapper: (clsChart data, _) =>
                                          data.info,
                                      yValueMapper: (clsChart data, _) =>
                                          data.amt),
                                ],
                              ))
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
                                      child: Row(
                                        children: [
                                          Text("Sales By Week",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isSalesByweek)
                                            IconButton(
                                              icon: Icon(
                                                isChartSaleByWeek == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size: isChartSaleByWeek == false
                                                    ? 25
                                                    : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartSaleByWeek =
                                                      isChartSaleByWeek == true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartSaleByWeek && isSalesByweek)
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              itemCount: lstSalesByWeek.length,
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
                        if (isChartSaleByWeek && isSalesByweek)
                          SizedBox(
                            height: 300,
                            child: SfCartesianChart(
                                tooltipBehavior: _tooltipBehaviorSalesByweek,
                                primaryXAxis: CategoryAxis(labelRotation: 90),
                                series: <ChartSeries>[
                                  ColumnSeries<clsChart, String>(
                                      /* dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        angle: 270,
                                      ),*/
                                      dataSource: lstChartDataSalesByWeek,
                                      xValueMapper: (clsChart data, _) =>
                                          data.info,
                                      yValueMapper: (clsChart data, _) =>
                                          data.amt)
                                ]),
                          ),
                        /* SizedBox(
                          height: 300,
                          //  width: 500,
                          child: charts.BarChart(
                            _getSeriesData(),
                            animate: false,
                            domainAxis: charts.OrdinalAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(
                                    labelRotation: 70,
                                    labelStyle: new charts.TextStyleSpec(
                                        fontSize: 13,
                                        fontFamily: fontFamily,
                                        lineHeight: 5,
                                        color: charts.MaterialPalette.white))),
                          ),
                        )*/
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
                                      child: Row(
                                        children: [
                                          Text("Sales By Day",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isSalebyDay)
                                            IconButton(
                                              icon: Icon(
                                                isChartSaleByDay == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size: isChartSaleByDay == false
                                                    ? 25
                                                    : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartSaleByDay =
                                                      isChartSaleByDay == true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartSaleByDay && isSalebyDay)
                          SizedBox(
                            height: 300,
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
                        if (isChartSaleByDay && isSalebyDay)
                          SizedBox(
                              height: 300,
                              child: SfPyramidChart(
                                  legend: Legend(isVisible: true),
                                  tooltipBehavior: _tooltipBehaviorSalesByDay,
                                  series: PyramidSeries<clsChart, String>(
                                      dataSource: lstChartDataSalesByDay,
                                      xValueMapper: (clsChart data, _) =>
                                          data.info,
                                      yValueMapper: (clsChart data, _) =>
                                          data.amt, // Render the data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: false))))
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
                                      child: Row(
                                        children: [
                                          Text("Sales By Hours",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isSalesbyHours)
                                            IconButton(
                                              icon: Icon(
                                                isChartSaleByHours == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size:
                                                    isChartSaleByHours == false
                                                        ? 25
                                                        : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartSaleByHours =
                                                      isChartSaleByHours == true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartSaleByHours && isSalesbyHours)
                          SizedBox(
                            height: 400,
                            child: GridView.builder(
                              itemCount: lstSalesByHours.length,
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
                        if (isChartSaleByHours && isSalesbyHours)
                          SizedBox(
                              height: 500,
                              child: SfCartesianChart(
                                  tooltipBehavior: _tooltipBehaviorSalesByHorus,
                                  primaryXAxis: CategoryAxis(
                                      labelRotation: 0,
                                      borderColor: Colors.red),
                                  series: <ChartSeries>[
                                    // Renders bar chart
                                    BarSeries<clsChart, String>(
                                        dataSource: lstChartDataSalesByHours,
                                        xValueMapper: (clsChart data, _) =>
                                            data.info,
                                        yValueMapper: (clsChart data, _) =>
                                            data.amt,
                                        pointColorMapper: (clsChart data, _) =>
                                            Colors
                                                .pinkAccent //HexColor("#dc143c"),
                                        )
                                  ])),
                        /*SizedBox(
                              child: SfCartesianChart(
                                  tooltipBehavior: _tooltipBehaviorSalesByHorus,
                                  primaryXAxis: CategoryAxis(),
                                  zoomPanBehavior: _zoomPanBehavior,
                                  series: <ChartSeries>[
                                BubbleSeries<clsChart, String>(
                                    dataSource: lstChartDataSalesByHours,
                                    sizeValueMapper: (clsChart data, _) =>
                                        data.amt,
                                    // pointColorMapper:(clsChart data, _) => data.pointColor,
                                    xValueMapper: (clsChart data, _) =>
                                        data.info,
                                    yValueMapper: (clsChart data, _) =>
                                        data.amt)
                              ]))*/
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
                                      child: Row(
                                        children: [
                                          Text("Mode of Sales",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isModeOfSales)
                                            IconButton(
                                              icon: Icon(
                                                isChartModeOfPayment == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size: isChartModeOfPayment ==
                                                        false
                                                    ? 25
                                                    : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartModeOfPayment =
                                                      isChartModeOfPayment ==
                                                              true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartModeOfPayment && isModeOfSales)
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
                        if (isChartModeOfPayment && isModeOfSales)
                          SizedBox(
                              child: SfCircularChart(
                                  tooltipBehavior: _tooltipBehaviorModeOfSales,
                                  legend: Legend(
                                    position: LegendPosition.bottom,
                                    isVisible: true,
                                  ),
                                  /* legend: Legend(
                                    isVisible: true,
                                    toggleSeriesVisibility: true),*/
                                  series: <CircularSeries>[
                                DoughnutSeries<clsChart, String>(
                                    dataSource: lstChartDataModeOfPayment,
                                    xValueMapper: (clsChart data, _) =>
                                        data.info,
                                    yValueMapper: (clsChart data, _) =>
                                        data.amt,
                                    // Radius of doughnut's inner circle
                                    innerRadius: '70%')
                              ]))
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
                                      child: Row(
                                        children: [
                                          Text("Categories",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isCategory)
                                            IconButton(
                                              icon: Icon(
                                                isChartCategory == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size: isChartCategory == false
                                                    ? 25
                                                    : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartCategory =
                                                      isChartCategory == true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartCategory && isCategory)
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
                        if (isChartCategory && isCategory)
                          SizedBox(
                              child: SfCircularChart(
                                  tooltipBehavior: _tooltipBehaviorTop20Product,
                                  legend: Legend(
                                      isVisible: true,
                                      title: LegendTitle(
                                          text: 'Category',
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900))),
                                  series: <CircularSeries>[
                                DoughnutSeries<clsChart, String>(
                                    dataSource: lstChartDataCategories,
                                    xValueMapper: (clsChart data, _) =>
                                        data.info,
                                    yValueMapper: (clsChart data, _) =>
                                        data.amt,
                                    radius: '100%'
                                    // Corner style of doughnut segment
                                    //cornerStyle: CornerStyle.bothCurve
                                    )
                              ]))
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
                                      child: Row(
                                        children: [
                                          Text("Top 20 Product Mix",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  color: HexColor(text_Color))),
                                          if (isTop20ProductMix)
                                            IconButton(
                                              icon: Icon(
                                                isChartTop20Product == false
                                                    ? Icons.bar_chart
                                                    : Icons.dashboard,
                                                color: HexColor(text_Color),
                                                size:
                                                    isChartTop20Product == false
                                                        ? 25
                                                        : 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isChartTop20Product =
                                                      isChartTop20Product ==
                                                              true
                                                          ? false
                                                          : true;
                                                });
                                              },
                                            ),
                                        ],
                                      ),
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
                        if (!isChartTop20Product && isTop20ProductMix)
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
                        if (isChartTop20Product && isTop20ProductMix)
                          SizedBox(
                              child: SfCircularChart(
                                  legend: Legend(
                                      isVisible: true,
                                      width: "150",
                                      //  height: "200",
                                      // overflowMode: LegendItemOverflowMode.wrap,
                                      position: LegendPosition.right,
                                      textStyle: TextStyle(
                                        overflow: TextOverflow.clip,
                                      )),
                                  series: <CircularSeries>[
                                PieSeries<clsChart1, String>(
                                    dataSource: lstChartDatTop20Product,
                                    xValueMapper: (clsChart1 data, _) =>
                                        data.item_name,
                                    yValueMapper: (clsChart1 data, _) =>
                                        data.amt,
                                    // Segments will explode on tap
                                    explode: true,
                                    // First segment will be exploded on initial rendering
                                    explodeIndex: 1)
                              ]))
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
        print("store_name");
        if (GeneralInformation.isNotEmpty) {
          GeneralInformation = GeneralInformation[0]['details'];
        }
        lstSalesOverview = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales Overview';
        }));
        if (lstSalesOverview.isNotEmpty) {
          lstSalesOverview = lstSalesOverview[0]['details'];

          lstChartDataSalesByMonth.clear();
          for (Map<String, dynamic> i in lstSalesOverview) {
            lstChartDataSalesByMonth.add(clsChart.fromJson(i));
          }
        }

        lstCategories = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Categories';
        }));
        if (lstCategories.length > 0) {
          lstCategories = lstCategories[0]['details'];
          lstChartDataCategories.clear(); //testing
          for (Map<String, dynamic> i in lstCategories) {
            lstChartDataCategories.add(clsChart.fromJson(i));
          }
        }

        lstSalesByWeek = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Week';
        }));
        if (lstSalesByWeek.isNotEmpty) {
          lstSalesByWeek = lstSalesByWeek[0]['details'];

          lstChartDataSalesByWeek.clear();
          for (Map<String, dynamic> i in lstSalesByWeek) {
            lstChartDataSalesByWeek.add(clsChart.fromJson(i));
          }
        }

        lstSalesByDay = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Day';
        }));
        if (lstSalesByDay.isNotEmpty) {
          lstSalesByDay = lstSalesByDay[0]['details'];

          lstChartDataSalesByDay.clear();
          for (Map<String, dynamic> i in lstSalesByDay) {
            lstChartDataSalesByDay.add(clsChart.fromJson(i));
          }
        }

        lstSalesByHours = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Sales By Hours';
        }));
        if (lstSalesByHours.isNotEmpty) {
          lstSalesByHours = lstSalesByHours[0]['details'];
          lstChartDataSalesByHours.clear();
          for (Map<String, dynamic> i in lstSalesByHours) {
            lstChartDataSalesByHours.add(clsChart.fromJson(i));
          }
        }

        lstModeofSales = List.from(lstdashboart.where((v) {
          return v['group_name'] == 'Mode of Sales';
        }));
        if (lstModeofSales.isNotEmpty) {
          lstModeofSales = lstModeofSales[0]['details'];
          lstChartDataModeOfPayment.clear(); //testing
          for (Map<String, dynamic> i in lstModeofSales) {
            lstChartDataModeOfPayment.add(clsChart.fromJson(i));
          }
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
          lstChartDatTop20Product.clear();
          for (Map<String, dynamic> i in lsttopprodmix) {
            lstChartDatTop20Product.add(clsChart1.fromJson(i));
          }
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
    var items = [
      'Chart',
      'Data',
    ];

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
                  height: 550,
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
                          margin: const EdgeInsets.only(top: 10),
                          child: const Text(
                            "Display by",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "Nunito"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            // Initial Value
                            value: ddlDiscplayby,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                ddlDiscplayby = newValue!;
                              });
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
                                            ischartdataview(
                                                ddlDiscplayby == 'Chart'
                                                    ? true
                                                    : false);
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

  void showProfileInfo() {
    // show the dialog
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Container(
                height: 300,
                width: 500,
                // color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: SizedBox(
                        child: ProfilePicture(
                          name: lstLoginUserInfo[0]['display_name'],
                          role: lstLoginUserInfo[0]['comp_name'],
                          radius: 31,
                          fontsize: 21,
                          tooltip: true,
                          img: storage
                                  .getItem('api_url')
                                  .replaceAll("/api", "/") +
                              lstLoginUserInfo[0]['user_image'],
                        ),
                      ),
                    ),
                    Text(
                      lstLoginUserInfo[0]['display_name'],
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      lstLoginUserInfo[0]['comp_name'],
                      style: TextStyle(fontSize: 22),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60),
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
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new loginPage(
                                                    title:
                                                        "Evolut Reporting App")));
                                  },
                                  child: const Text(
                                    "Log out",
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
                                        primary: Colors.black),
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: const Text("Close",
                                        style: TextStyle(
                                            color: Colors.white,
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
          );
        });
      },
    );
  }
}

class clsChart {
  clsChart(this.info, this.amt);

  final String? info;
  final double? amt;

  factory clsChart.fromJson(Map<String, dynamic> parsedJson) {
    return clsChart(
      parsedJson['info'].toString(),
      double.parse(parsedJson['amt'].toString()),
    );
  }
}

class clsChart1 {
  clsChart1(this.item_name, this.amt, this.qty);

  final String? item_name;
  final double? amt;
  final double? qty;

  factory clsChart1.fromJson(Map<String, dynamic> parsedJson) {
    return clsChart1(
      parsedJson['item_name'].toString(),
      double.parse(parsedJson['amt'].toString()),
      double.parse(parsedJson['qty'].toString()),
    );
  }
}
