import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orders2Screen extends StatefulWidget {
  final userId;

  Orders2Screen(this.userId);

  @override
  _Orders2ScreenState createState() => _Orders2ScreenState();
}

class _Orders2ScreenState extends State<Orders2Screen> {
  final _firestore = Firestore.instance;
  var usersList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Clients orders'),
        ),
        body:StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('orders')
                .document(widget.userId)
                .collection('productsOrders')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final prodsOrder = snapshot.data.documents;
              var productsList = [];
              for (var product in prodsOrder) {
                productsList.add(product);
//              productsListOrder.add(product);
              }

              return productsList.isEmpty
                  ?Center(child: Text("No Order Found",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),

              ),
              )
                  :ListView.builder(
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 200.0,
                    margin: new EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(
                          color: Colors.grey,
                        ))
                    ),
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    productsList[index]['name'],
                                    style: TextStyle(),
                                  ),
                                  subtitle: Text(
                                    productsList[index]["description"],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                            '${productsList[index]['price']} Dh'),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Center(
                                            child: Text(
                                                'Qté selected: ${productsList[index]['selectedQte']}')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                        'selected Sizes : ${productsList[index]['selectedSizes'].toString()}'
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                },
              );
            }),
    );
  }
}
