import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfeappadmin/db/brand.dart';
import 'package:pfeappadmin/db/category.dart';
import 'package:pfeappadmin/screens/add_category.dart';
import 'package:pfeappadmin/screens/add_product.dart';
import 'package:pfeappadmin/screens/admin.dart';
import 'package:pfeappadmin/screens/orders_screen.dart';
import 'package:pfeappadmin/screens/product_screen.dart';


enum Page { dashboard, manage }

class LoadScreen extends StatefulWidget {
  final selectPage;

  LoadScreen({@required this.selectPage});

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  MaterialColor active = Colors.red;

  MaterialColor notActive = Colors.grey;

  GlobalKey<FormState> _brandFormKey = GlobalKey();

  TextEditingController brandController = TextEditingController();

  BrandService _brandService = BrandService();



  @override
  Widget build(BuildContext context) {
    switch (widget.selectPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: <Widget>[
                  Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.people_outline),
                            label: Text("Users")),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                  Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.tag_faces),
                            label: Text("Sold")),
                        subtitle: Text(
                          '13',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                  Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.shopping_cart),
                            label: Text("Orders")),
                        subtitle: Text(
                          '5',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                  Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.arrow_back),
                            label: Text("Return")),
                        subtitle: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return AddProduct();
                }
                ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ProductScreen();
                }
                ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return AddCategory();
                }
                ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {

              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () {
                _brandAlert();
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("brand list"),
              onTap: () {},
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text("Orders"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return OrdersScreen();
                }
                ));
              },
            ),
            Divider(),
          ],
        );
        break;
      default :
        return Container();
    }
  }

  //======================== Category Alert ==============================

 /* void categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: Column(
          children: <Widget>[
            AddPicture(
              child:displayChild1() ,
              onPress: (){
                getImageCat();
              },

            ),
            TextFormField(
              controller: categoryController,
              validator: (value){
                if(value.isEmpty){
                  return 'category cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "add category"
              ),
            ),
          ],
        )
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            _categoryService.createCategory(categoryController.text);
          }
          categoryController.clear();
          Fluttertoast.showToast(msg: 'category created');

          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }*/

  // ========== display images widgets =============


  //=========================== Brand Alert =================================

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,

        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "add brand"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(brandController.text != null){
            _brandService.createBrand(brandController.text);
          }
          Fluttertoast.showToast(msg: 'brand added');
          brandController.clear();
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(
            onPressed: ()  {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}



