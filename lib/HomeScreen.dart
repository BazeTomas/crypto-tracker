import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:social_share/social_share.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Crypto Price List',
      theme: ThemeData.dark(),
      home: CryptoList(),
    );
  }
}

class CryptoList extends StatefulWidget {

  @override
  CryptoListState createState() => CryptoListState();
}

class CryptoListState extends State<CryptoList> {
  List<dynamic> _cryptoList;
  final _saved = Set<Map>();
  final _boldStyle =
  new TextStyle(fontWeight: FontWeight.bold);
  bool _loading = false;
  Widget _appBarTitle = new Text( 'Currency Tracker' );
  List filteredNames = new List();
  String end="";

  Future<void> getCryptoPrices() async {

    print('getting prices');
    String _apiURL =
        "https://rest.coinapi.io/v1/assets?apikey=8D9C6A88-7A88-495C-8383-AD5E67A2AD59";
    setState(() {
      this._loading = true;
    });
    http.Response response = await http.get(_apiURL);
    setState(() {
      List<dynamic> responseJson  = jsonDecode(response.body);

      this._cryptoList = responseJson;
      this._loading = false;
      print(_cryptoList);
    });
    return;
  }

  String cryptoPrice(Map crypto) {
    double usd = 1.00;
    if (crypto['asset_id'] == "USD")
      return "\$" + usd.toString();
    else {
      double d = crypto['price_usd'];
      return d == null ? "N/A" : "\$" +
          d.toStringAsFixed(2);
    }
  }

  CircleAvatar _getLeadingWidget(String logo) {

    return new CircleAvatar(
      child: Image.network(logo),
    );
  }

  _getMainBody() {
    if (_loading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
        child: _buildCryptoList(),
        onRefresh: getCryptoPrices,

      );
    }
  }

  @override
  void initState() {

    super.initState();
    getCryptoPrices();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(

          title:_appBarTitle,
          actions: <Widget>[

            new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),

        body: _getMainBody());
  }

  void _pushSaved() {
    String str="";
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (crypto) {
                  if(crypto["id_icon"]!=null)
                  str = crypto['id_icon'];
                  return new ListTile(
                      leading: _getLeadingWidget("https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_128/" + str.trim().replaceAll("-", "") + ".png"),
                      title: Text(crypto['name']),
                      subtitle: Text(
                        cryptoPrice(crypto),
                        style: _boldStyle,
                      ),
                    );

            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Cryptos'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildCryptoList() {
    return ListView.builder(
        padding:
        const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i;
          print(index);
          return _buildRow(_cryptoList[index]);
        });

  }

  Widget _buildRow(Map crypto) {

    final bool favourited = _saved.contains(crypto);
    String logo="";
    end="https://icon-icons.com/icons2/1386/PNG/128/generic-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment_95642.png";
    if(crypto['id_icon']!=null) {
      String test = crypto['id_icon'];
      logo = test.trim().replaceAll("-", "");
      end = "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_128/" + logo + ".png";
    }

    void _fav() {
      setState(() {
        if (favourited) {

          _saved.remove(crypto);
        } else {
          _saved.add(crypto);
        }
      });
    }

    return ListTile(

      leading: _getLeadingWidget(end),
      title: Text(crypto['name']),
      subtitle: Text(

        cryptoPrice(crypto),
        style: _boldStyle,
      ),
      onTap: (){
        if(crypto['name']=="US Dollar")
            SocialShare.shareOptions("Hey the price of "+ crypto['name'] + " is currently \$1.00");
          else
        SocialShare.shareOptions("Hey the price of "+ crypto['name'] + " is currently \$" +crypto['price_usd'].toStringAsFixed(2));},
      trailing: new IconButton(
        icon: Icon(favourited ? Icons.favorite : Icons.favorite_border),
        color:
        favourited ? Colors.red : null,
        onPressed: _fav,
      ),

    );
  }
}
