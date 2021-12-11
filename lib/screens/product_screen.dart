import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final _fireStore=Firestore.instance;

  GlobalKey<FormState> _priceFormKey = GlobalKey();

  TextEditingController priceController = TextEditingController();

  GlobalKey<FormState> _nameFormKey = GlobalKey();

  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> _qteFormKey = GlobalKey();

  TextEditingController qteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data.documents;
          var productsList = [];
          for(var product in products){
            productsList.add(product.data);
          }
          return GridView.builder(
                shrinkWrap: true,
                controller: ScrollController(
                  keepScrollOffset: false,
                ),
                itemCount: productsList.length,
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing:25,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (BuildContext context,int index){
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                          Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10)
                            ),
                            child: Image(
                              image: NetworkImage(productsList[index]['images'][0]),
                              fit: BoxFit.cover,
                              height: 125,
                              width: 120,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onLongPress: (){
                                  _nameAlert(productsList[index]['id']);
                                },
                                child: Container(
                                  width: 120,
                                  child: Text(productsList[index]['name'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onLongPress: (){
                                  _priceAlert(productsList[index]['id']);
                                },
                                child: Text('${productsList[index]['price']} Dh',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onLongPress: (){
                                  _qteAlert(productsList[index]['id']);
                                },
                                child: Text('qte:${productsList[index]['qte']}',
                                  style: TextStyle(
                                    fontSize: 15,

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Feature :",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CupertinoSwitch(
                                activeColor: Colors.lightBlueAccent,
                                value: productsList[index]['feature'],
                                onChanged: (value){
                                  _fireStore.collection('products')
                                      .document(productsList[index]['id'])
                                      .updateData({'feature':value});
                                },
                              ),
                              SizedBox(height: 5,),
                              Text("Delete :",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                iconSize: 40,
                                icon: Icon(Icons.delete_forever,color: Colors.red,),
                                onPressed: (){
                                  removeAlert(productsList[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
        },
      ),
    );
  }
  void removeAlert(String id) {
    var alert = new AlertDialog(
      content: Text("Do you want to remove this product ?"),
      actions: <Widget>[
        FlatButton(onPressed: (){
          _fireStore.collection('products')
              .document(id).delete()
              .then((_){
            Fluttertoast.showToast(msg: 'product removed');
          });
          Navigator.pop(context);
        }, child: Text('Confirm')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
  void _priceAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _priceFormKey,

        child: TextFormField(
          controller: priceController,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (value){
            if(value.isEmpty){
              return 'price cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "New price"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(priceController.text != null){
            _fireStore.collection('products')
                .document(id).updateData({'price':priceController.text})
                .then((_){
              Fluttertoast.showToast(msg: 'price updated');
            });
          }
          priceController.clear();
          Navigator.pop(context);
        }, child: Text('Update')),
        FlatButton(
            onPressed: ()  {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
  void _nameAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _nameFormKey,

        child: TextFormField(
          controller: nameController,
          validator: (value){
            if(value.isEmpty){
              return 'Name cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "New name"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(nameController.text != null){
            _fireStore.collection('products')
                .document(id).updateData({'name':nameController.text})
                .then((_){
              Fluttertoast.showToast(msg: 'price name');
            });
          }
          nameController.clear();
          Navigator.pop(context);
        }, child: Text('Update')),
        FlatButton(
            onPressed: ()  {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
  void _qteAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _qteFormKey,

        child: TextFormField(
          controller: qteController,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (value){
            if(value.isEmpty){
              return 'Qte cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "New quantity"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(qteController.text != null){
            _fireStore.collection('products')
                .document(id).updateData({'qte':qteController.text})
                .then((_){
              Fluttertoast.showToast(msg: 'Qte updated');
            });
          }
          qteController.clear();
          Navigator.pop(context);
        }, child: Text('Update')),
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
