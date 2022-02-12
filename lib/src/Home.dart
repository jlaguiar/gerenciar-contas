import 'package:flutter/material.dart';
import 'package:gerenciador_de_contas/src/CardTile.dart';
import 'package:gerenciador_de_contas/src/class/Bill.dart';
import 'package:gerenciador_de_contas/src/database/DB.dart';
import 'package:gerenciador_de_contas/src/dialogs/DialogAddBill.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DB dataBase = DB();

  List<Bill> _listBill = List<Bill>();
  List<Bill> _listAux = List<Bill>();

  getBills() async {
    _listAux = await dataBase.getBills();
    setState(() {
      _listBill = _listAux;
    });
  }

  @override
  void initState() {
    super.initState();
    getBills();
  }

  @override
  Widget build(BuildContext context) {
    dataBase.recoverDB();
    dataBase.getBills();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gerenciar contas'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: EdgeInsets.only(top: 25),
        child: ListView.builder(
            itemCount: _listBill.length,
            itemBuilder: (context, index) {
              print(_listBill);
              print('list');
              return CardTile(
                bill: _listBill[index],
                getList: getBills,
                key: ValueKey(_listBill[index].id),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        elevation: 2,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          _dialogAddBillUser(context);
        },
      ),
    );
  }

  void _dialogAddBillUser(context) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogAddBill(getBills: getBills);
        });
  }
}
