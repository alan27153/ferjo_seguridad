import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async{
  List people = [];
  CollectionReference collectionReferencePeople = db.collection('productos');
  QuerySnapshot queryPeople = await collectionReferencePeople.get();

  queryPeople.docs.forEach((documento){
    people.add(documento.data());
  });
  
  print(people);
  return people;
}