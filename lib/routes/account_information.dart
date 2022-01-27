import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gigya_flutter_plugin/gigya_flutter_plugin.dart';
import 'package:gigya_flutter_plugin/models/gigya_models.dart';

class AccountInformationWidget extends StatefulWidget {
  @override
  _AccountInformationWidgetState createState() =>
      _AccountInformationWidgetState();
}

class _AccountInformationWidgetState extends State<AccountInformationWidget> {
  final TextEditingController _firstNameTextController =
      TextEditingController();
  bool _inProgress = false;

  @override
  void dispose() {
    _firstNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account information'),
      ),
      body: FutureBuilder<Account>(
        future: _getAccountInformation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Account? account = snapshot.data;
            if (account != null && account.profile != null) {
              _firstNameTextController.text = account.profile?.firstName ?? '';
            } else {
              _firstNameTextController.text = _firstNameTextController.text.trim();
            }

            return Container(
              child: Column(
                children: [
                  _inProgress
                      ? LinearProgressIndicator(
                          minHeight: 4,
                        )
                      : SizedBox(
                          height: 4,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300
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
                                    child: Text('Account UID:'),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                    child: Text(account?.uid ?? ''),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                    child: Text('Email Address:'),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 7.0, bottom: 5.0),
                                    child: Text(account?.profile?.email ?? ''),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Edit Account',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text('First Name:'),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _firstNameTextController,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ButtonTheme(
                          minWidth: 240,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              _updateAccountInformation(account);
                            },
                            child: const Text('Update profile first name'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    minHeight: 4,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// Fetch account information.
  Future<Account> _getAccountInformation() async {
    var result = await GigyaSdk.instance.getAccount();
    debugPrint(jsonEncode(result));
    Account response = Account.fromJson(result);
    return response;
  }

  /// Update account information given new updated [account] object.
  _updateAccountInformation(Account? account) async {
    if (account == null) return;

    setState(() {
      _inProgress = true;
    });
    String newFirstName = _firstNameTextController.text.trim();
    var result = await GigyaSdk.instance.setAccount({
      'profile': jsonEncode({'firstName': newFirstName})
    });
    debugPrint(jsonEncode(result));
    FocusScope.of(context).unfocus();
    setState(() {
      _inProgress = false;
    });
  }
}
