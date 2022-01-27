import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gigya_flutter_plugin/gigya_flutter_plugin.dart';
import 'package:gigya_flutter_plugin/models/gigya_models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

/// Home page widget (initial route).
class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: _getAccountInformation(),
      builder: (context, snapshot) {
        var loggedIn = snapshot.hasData;
        var user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My App'),
            actions: [
              loggedIn
                ? Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/account_information');
                      },
                      child: Icon(
                        Icons.manage_accounts,
                        size: 26.0,
                      ),
                    )
                  ) 
                : Container(),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: loggedIn
                  ? GestureDetector(
                    onTap: () {
                      GigyaSdk.instance.logout().then((val) {
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.logout,
                      size: 26.0,
                    ),
                  )
                  : GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login_credentials')
                        .then((val) {
                          setState(() {
                            debugPrint('Refresh on back');
                          });
                        });
                    },
                    child: Icon(
                      Icons.login,
                      size: 26.0,
                    ),
                  ), 
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    CachedNetworkImage(imageUrl: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/e2740e4b-67b5-4fb7-8971-1ad83c7cb6b2/de3gn5h-804df0a9-2de1-45ee-ae86-48f940a28eb9.png"),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(right: 10, left: 10.0, top: 3.0, bottom: 3.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                loggedIn
                  ? Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Table(
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                        ),
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          2: FixedColumnWidth(64),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text('UID:'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text(user?.uid ?? ''),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text('Email:'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text(user?.profile?.email ?? ''),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text('First Name:'),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                  child: Text(user?.profile?.firstName ?? ''),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

   /// Fetch account information.
  Future<Account> _getAccountInformation() async {
    var result = await GigyaSdk.instance.getAccount();
    print('here');
    debugPrint(jsonEncode(result));
    Account response = Account.fromJson(result);
    return response;
  }
}
