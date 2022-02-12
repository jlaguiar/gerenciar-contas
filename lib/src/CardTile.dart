import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gerenciador_de_contas/src/class/Bill.dart';
import 'package:gerenciador_de_contas/src/class/Product.dart';
import 'package:gerenciador_de_contas/src/database/DB.dart';
import 'package:gerenciador_de_contas/src/dialogs/DialogAddProduct.dart';
import 'package:gerenciador_de_contas/src/dialogs/DialogDefaultConfirmacao.dart';
import 'package:gerenciador_de_contas/src/dialogs/DialogRemove.dart';
import 'package:intl/intl.dart';

import 'dialogs/DialogAddBill.dart';

class CardTile extends StatefulWidget {
  final Bill bill;
  final void Function() getList;

  CardTile({Key key, this.bill, this.getList}) : super(key: key);

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  DB database = DB();

  List<Product> _listProducts = List<Product>();
  List<Product> _listAux = List<Product>();

  List itensMenu = ['TEste', 'Testa2'];

  void addProduct(Product product) {
    product.idBill = widget.bill.id;
    database.saveProduct(product);
    getProducts();
  }

  void getProducts() async {
    _listAux = await database.getProducts(widget.bill.id);
    setState(() {
      _listProducts = _listAux;
    });
  }

  String sumProduct() {
    var formatter = NumberFormat('#,##0.00', 'pt_BR');
    double sum = 0.0;
    _listProducts.forEach((element) {
      if (!element.status) {
        sum += element.value;
      }
    });

    return formatter.format(sum).toString();
  }

  String valueProduct(double value) {
    var formatter = NumberFormat('#,##0.00', 'pt_BR');
    return formatter.format(value).toString();
  }

  void removeBill(int id) {
    database.deleteBill(id);
    widget.getList();
    getProducts();
  }

  void removeProduct(int id) {
    database.deleteProduct(id);
    getProducts();
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          accentColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.white)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Card(
          color: Colors.blueAccent,
          child: GestureDetector(
            onLongPress: () {
              _showOptions(context, widget.bill.id, widget.bill.name, false);
            },
            child: ExpansionTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              title: Text(
                widget.bill.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10.0),
                          itemCount: _listProducts.length,
                          itemBuilder: buildItemListBill),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.green,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DialogAddProduct(
                                              getProducts: getProducts,
                                              idBill: widget.bill.id);
                                        });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total: R\$ ${sumProduct()}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemListBill(BuildContext context, int index) {
    return ListTile(
      leading: IconButton(
        icon: _listProducts[index].status
            ? Icon(Icons.check_box, color: Colors.white)
            : Icon(Icons.check_box_outline_blank, color: Colors.white),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogConfirmation(
                  product: _listProducts[index],
                  getProducts: getProducts,
                );
              });
        },
      ),
      title: Text(
        _listProducts[index].name,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Text('R\$${valueProduct(_listProducts[index].value)}',
          style: TextStyle(color: Colors.white, fontSize: 16)),
      onLongPress: () {
        _showOptions(context, index, _listProducts[index].name, true);
      },
    );
  }

  void _showOptions(context, id, text, product) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                width: 200,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 15),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Editar',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return product
                                    ? DialogAddProduct(
                                        getProducts: getProducts,
                                        product: _listProducts[id])
                                    : DialogAddBill(
                                        getBills: widget.getList,
                                        bill: widget.bill);
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Remover',
                          style:
                              TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return product
                                    ? DialogRemove(
                                        idBill: _listProducts[id].id,
                                        delete: removeProduct,
                                        product: _listProducts[id],
                                      )
                                    : DialogRemove(
                                        idBill: widget.bill.id,
                                        delete: removeBill,
                                      );
                              });
                          widget.getList();
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
