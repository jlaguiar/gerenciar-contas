import 'package:gerenciador_de_contas/src/class/Bill.dart';
import 'package:gerenciador_de_contas/src/class/Product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DB {
  String _dateNow() {
    //Date now
    var now = new DateTime.now();
    print(now);
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate.toString();
  }

  Future<Database> recoverDB() async {
    final pathDB = await getDatabasesPath();
    final placeDB = join(pathDB, "banco.db");

    //deleteDatabase(placeDB);

    var bd = await openDatabase(placeDB, version: 1,
        onCreate: (db, dbRecentVersion) {
      String sqlTableBill =
          "CREATE TABLE bill (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR);";
      db.execute(sqlTableBill);

      // 0 false 1 true
      String sqlTableProduct =
          "CREATE TABLE product (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, date_registration VARCHAR, date_pay VARCHAR,value REAL ,status INTEGER, type INTEGER, id_bill INTEGER,"
          "FOREIGN KEY(id_bill) REFERENCES bill(id));";

      db.execute(sqlTableProduct);
    });

    print("aberto: " + bd.isOpen.toString());
    return bd;
  }

  void deleteBill(int id) async {
    Database db = await recoverDB();

    db.delete('bill', where: 'id = ?', whereArgs: [id]);
    print('deletado bill');
  }

  void deleteProduct(int id) async {
    Database db = await recoverDB();

    db.delete('product', where: 'id = ?', whereArgs: [id]);
    print('deletado product');
  }

  void saveBill(Bill bill) async {
    Database db = await recoverDB();
    Map<String, String> valuesTable = {'name': bill.name};

    int id = await db.insert('bill', valuesTable);
    print('Salvo bill ' + id.toString());
  }

  void updateBill(Bill bill) async {
    Database db = await recoverDB();

    Map<String, dynamic> valuesTable = {'name': bill.name};

    db.update('bill', valuesTable, where: 'id = ?', whereArgs: [bill.id]);
  }

  void updatePaidProduct(int id, int check) async {
    Database db = await recoverDB();

    Map<String, dynamic> valuesTable = {
      'status': check,
      'date_pay': _dateNow()
    };

    db.update('product', valuesTable, where: 'id = ?', whereArgs: [id]);
  }

  void updateProduct(Product product) async{
    Database db = await recoverDB();

    Map<String, dynamic> valuesTable = {
      'name': product.name,
      'value': product.value
    };

    db.update('product', valuesTable, where: 'id = ?', whereArgs: [product.id]);
  }

  void saveProduct(Product product) async {
    // type == 0 Negative, type == 1 Positive
    // status == 0 unpaid status == 1 paid
    Database db = await recoverDB();

    Map<String, dynamic> valuesTable = {
      'name': product.name,
      'date_registration': _dateNow(),
      'date_pay': '',
      'value': product.value,
      'status': 0,
      'type': 0,
      'id_bill': product.idBill
    };

    int id = await db.insert('product', valuesTable);
    print('Salvo product ' + id.toString());
  }

  Future<List> getBills() async {
    Database db = await recoverDB();
    String sql = 'SELECT * FROM bill';
    List bills = await db.rawQuery(sql);

    List<Bill> listBillReturn = List<Bill>();

    for (var bill in bills) {
      listBillReturn.add(Bill(id: bill['id'], name: bill['name']));
      print('Bill name : ${bill['name']}   id: ${bill['id']}');
    }
    return listBillReturn;
  }

  Future<List> getProducts(int id) async {
    Database db = await recoverDB();

    String sql = 'SELECT * FROM product WHERE id_bill = $id';
    List products = await db.rawQuery(sql);
    List<Product> listProductsReturn = List<Product>();
    for (var product in products) {
      listProductsReturn.add(Product(
          id: product['id'],
          dateRegistration: product['date_registration'],
          datePay: product['date_pay'],
          value: product['value'],
          name: product['name'],
          status: product['status'] == 0 ? false : true,
          type: product['type'] == 0 ? false : true,
          idBill: product['id_bill']));

      print(
          'Product ${product['name']} ,  ${product['date_registration']} , ${product['value']} , ${product['status']} ,  ${product['type']} ,  ${product['id_bill']} ');
    }

    return listProductsReturn;
  }
}
