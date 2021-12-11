import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService{
  static Firestore _firestore = Firestore.instance;

  void createCategory({String name,String picture}){
    var id = Uuid();
    String categoryId = id.v1();
    _firestore.collection('categories').document(categoryId).setData({
      'category': name,
      'picture': picture,
    });
  }

  static Future<List<String>> getCategories() async{

    List<String> categories = List() ;
     _firestore.collection("categories").getDocuments().then((value){
      for(DocumentSnapshot category in value.documents) {
        categories.add(category.data['category']);
      }
      return categories;
    });
  }
}
