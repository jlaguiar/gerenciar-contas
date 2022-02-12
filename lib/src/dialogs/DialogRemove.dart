import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gerenciar_conta/src/class/Product.dart';

class DialogRemove extends StatelessWidget {
  final int idBill;
  final void Function(int) delete;
  final Product product;

  DialogRemove({this.idBill, this.delete, this.product});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 10),
              child: Text(
                product == null
                    ? 'Deseja remover está conta ? \n\n Todos os dados referentes a ela serão perdidas.'
                    : 'Deseja remover ${product.name} da lista ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueAccent),
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
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          color: Colors.white,
                          elevation: 0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.redAccent)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ButtonTheme(
                        minWidth: 100,
                        child: RaisedButton(
                          child: Text(
                            "Remover",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.redAccent,
                          elevation: 0,
                          onPressed: () {
                            delete(idBill);
                            Navigator.pop(context);
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
    );
  }
}
