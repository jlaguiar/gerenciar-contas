import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:gerenciador_de_contas/src/class/Product.dart';
import 'package:gerenciador_de_contas/src/database/DB.dart';

class DialogAddProduct extends StatefulWidget {
  final void Function() getProducts;
  final Product product;
  final int idBill;

  DialogAddProduct({this.getProducts, this.product, this.idBill});

  @override
  _DialogAddProductState createState() => _DialogAddProductState();
}

class _DialogAddProductState extends State<DialogAddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingBillName = TextEditingController();
  final TextEditingController _textEditingBillValue = TextEditingController();

  final DB dataBase = DB();

  var numero;
  var valor;

  void fillProduct() {
    if(widget.product != null) {
      _textEditingBillName.text = widget.product.name;
      _textEditingBillValue.text = widget.product.value.toString();
    }
  }

  void saveProduct() {
    var convertValue = _textEditingBillValue.text;
    convertValue = convertValue.replaceAll('.','').replaceAll(',','.');
    double convertedValue = double.parse(convertValue);
    if(widget.product == null){
      dataBase.saveProduct(Product(name: _textEditingBillName.text, value: convertedValue, idBill: widget.idBill));
    }else{
      widget.product.name = _textEditingBillName.text;
      widget.product.value = convertedValue;
      dataBase.updateProduct(widget.product);
    }
    widget.getProducts();
  }

  @override
  void initState() {
    super.initState();
    fillProduct();

  }

  @override
  void dispose() {
    super.dispose();
    _textEditingBillValue.dispose();
    _textEditingBillName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 300,
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
                        controller: _textEditingBillName,
                        decoration: InputDecoration(
                            labelText: 'Nome da conta',
                            labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15)),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return value.isEmpty ? 'Inserir o nome' : null;
                        },
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 0, left: 20, right: 10),
                    child: Theme(
                      data: ThemeData(primarySwatch: Colors.blue),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                        controller: _textEditingBillValue,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          RealInputFormatter(centavos: true)
                        ],
                        decoration: InputDecoration(
                            labelText: 'Valor',
                            prefixStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
                            prefixText: 'R\$ ',
                            labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if( value.isEmpty) {
                            return 'Inserir valor';
                          } else if(!value.contains(',')) {
                            return 'O valor é invalido, por favor preencha os centavos com 0';
                          } else{
                            return null;
                          }
                        },
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 25),
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
                                final FormState form = _formKey.currentState;
                                if (form.validate()) {
                                  saveProduct();
                                  Navigator.pop(context);
                                } else {
                                  print('Form is invalid');
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
