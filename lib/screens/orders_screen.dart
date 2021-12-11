import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfeappadmin/screens/orders2_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
        stream: _firestore.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final clients=snapshot.data.documents;
          var clientsList=[];
          for(var client in clients) {
            clientsList.add(client.data);
            print('success');
          }
          return ListView.builder(
            itemCount: clientsList.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return Orders2Screen(
                      clientsList[index]['id'],
                    );
                  }
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            clientsList[index]['name'],
                            style:TextStyle(
                              color:Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ) ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: clientsList[index]['email']!=null
                              ?Text(clientsList[index]['email'])
                              :Text("not define"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: clientsList[index]['address']!=null
                              ?Text(clientsList[index]['address'])
                              :Text("not define"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: clientsList[index]['mobile']!=null
                              ?Text(clientsList[index]['mobile'])
                              :Text("not define"),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },

      )
    );
  }
}
