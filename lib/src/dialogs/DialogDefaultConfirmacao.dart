import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gerenciar_conta/src/database/DB.dart';
import 'package:gerenciar_conta/src/class/Product.dart';

class DialogConfirmation extends StatelessWidget {

  final Product product;
  final void Function() getProducts;
  DialogConfirmation({this.product, this.getProducts});

  final DB dataBase = DB();

  void updateProduct() {
    int check = product.status ? 0 : 1;
    dataBase.updatePaidProduct(product.id, check);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 15,
              ),
              child: Icon(
                Icons.attach_money, size: 50, color: Colors.deepPurple,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: product.status ? 'Deseja desmarcar ' : 'Deseja marcar ',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: product.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: ' como pago ?'),
                  ],
                ),
              ),
            ),
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
                            style: TextStyle(color: Colors.green),
                          ),
                          color: Colors.white,
                          elevation: 0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ButtonTheme(
                        minWidth: 100,
                        child: RaisedButton(
                          child: Text(
                            "SIM",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          elevation: 0,
                          onPressed: () {
                            updateProduct();
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
