import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;

  void createProduct({String name, String cat, String brand,int qte,
    var sizes,var images, String price,String description}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection('products').document(productId).setData({
      'id':productId,
      'name': name,
      'category':cat,
      'brand':brand,
      'qte':qte,
      'images':images,
      'sizes':sizes,
      'price':price,
      'description': description,
      'feature':false,
    });
  }
}
