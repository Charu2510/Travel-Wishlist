
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Wishlist());
}

class Wishlist extends StatefulWidget{
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist>{
  final _myController = TextEditingController();
  void _addWish() async{
    await FirebaseFirestore.instance.collection("Travel Log").add({"text": _myController.text});
    _myController.clear();
  }
  void _deleteWish(String docId) async {
    FirebaseFirestore.instance.collection("Travel Log").doc(docId).delete();

  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(240, 253, 253, 253)),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 132, 220, 231),
          title: const Text("Your Travel Wishlist", textAlign: TextAlign.center, style: TextStyle(color: Colors.deepPurple,fontSize: 30),), 
        ),
        body: Container(
          decoration: const BoxDecoration( image :DecorationImage(image: AssetImage("assets/lol.jpg"),fit: BoxFit.cover,)),
          child: Column(
            children: [Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Travel Log").snapshots(),
               builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                 if (snapshot.hasData) {
                   return ListView.builder(itemCount: snapshot.data!.docs.length,
                   itemBuilder: (ctx, pos) => InkWell(
                     onTap: (){_deleteWish(snapshot.data!.docs.elementAt(pos).id);},
                     child: Padding(
                       padding: const EdgeInsets.all(50) ,
                     child: Text((snapshot.data!.docs.elementAt(pos).data()
                        as Map)['text'], style: const TextStyle(color: Colors.white),
                     ),
                     ),
                   ),);
                 }
              return const CircularProgressIndicator();   
                 

               },),),
  
  
                TextField(controller: _myController, 
                decoration: const InputDecoration(labelText: "Share a Travel Wishlist"),
                style: const TextStyle(color: Colors.white),),
            ],

          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _addWish();
        }, child: const Icon(Icons.add) ,),
      ),
    );
  }
}