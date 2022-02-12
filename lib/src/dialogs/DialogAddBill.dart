import 'package:flutter/material.dart';
import 'package:gerenciador_de_contas/src/class/Bill.dart';
import 'package:gerenciador_de_contas/src/database/DB.dart';

class DialogAddBill extends StatefulWidget {
  final void Function() getBills;
  final Bill bill;

  DialogAddBill({this.getBills, this.bill});

  @override
  _DialogAddBillState createState() => _DialogAddBillState();
}

class _DialogAddBillState extends State<DialogAddBill> {
  final DB dataBase = DB();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingName = TextEditingController();

  void fillBill() {
    if(widget.bill != null) {
      _textEditingName.text = widget.bill.name;
    }
  }

  void saveBill() {
    if(widget.bill == null){
      dataBase.saveBill(Bill(name: _textEditingName.text));
    }else{
      widget.bill.name = _textEditingName.text;
      dataBase.updateBill(widget.bill);
    }
    widget.getBills();
  }

  @override
  void initState() {
    super.initState();
    fillBill();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 250,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 0, left: 20, right: 10),
                    child: Theme(
                      data: ThemeData(primarySwatch: Colors.blue),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                        controller: _textEditingName,
                        decoration: InputDecoration(
                            labelText: 'Nome',
                            labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15)),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return value.isEmpty ? 'Inserir nome' : null;
                        },
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: ButtonTheme(
                            minWidth: 100,
                            child: RaisedButton(
                              child: Text(
                                "CANCELAR",
                                style: TextStyle(color: Colors.blue),
                              ),
                              color: Colors.white,
                              elevation: 0,
                              onPressed: () {
                                _textEditingName.clear();
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: ButtonTheme(
                            minWidth: 100,
                            child: RaisedButton(
                              child: Text(
                                "SALVAR",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                              elevation: 0,
                              onPressed: () {
                                try {
                                  final FormState form = _formKey.currentState;
                                  if (form.validate()) {
                                    saveBill();
                                    _textEditingName.clear();
                                    Navigator.pop(context);
                                  } else {
                                    print('Form is invalid');
                                  }
                                } catch (e) {
                                  throw ('Error save bill');
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
