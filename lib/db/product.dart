import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'newproducts';

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  void uploadProduct(
      {required String productName,
      required String brand,
      required String category,
      required int quantity,
      required List sizes,
      required String images,
      required double price}) {
    var id = Uuid();

    String productId = id.v1();
    _firestore.collection(ref).doc(productId).set({
      'name': productName,
      'id': productId,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'sizes': sizes,
      'images': images,
      'price': price
    });
  }

  /// Adds [productId] to the current user's cart. If it's already in the
  /// cart, bumps the existing entry's quantity instead of creating a
  /// duplicate card.
  Future<void> uploadToCart(
      {required String productId,
      required String productName,
      required String brand,
      required String category,
      required int quantity,
      required String images,
      required double price}) async {
    final existing = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: _uid)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final currentQty = (doc['quantity'] as num?)?.toInt() ?? 0;
      await doc.reference.update({'quantity': currentQty + quantity});
    } else {
      final id = Uuid().v1();
      await _firestore.collection('cart').doc(id).set({
        'name': productName,
        'id': id,
        'productId': productId,
        'userId': _uid,
        'brand': brand,
        'category': category,
        'quantity': quantity,
        'images': images,
        'price': price
      });
    }
  }

  /// Sets a cart entry's quantity, deleting it if it drops to zero.
  Future<void> updateCartQuantity(String cartDocId, int newQuantity) async {
    if (newQuantity <= 0) {
      await _firestore.collection('cart').doc(cartDocId).delete();
    } else {
      await _firestore
          .collection('cart')
          .doc(cartDocId)
          .update({'quantity': newQuantity});
    }
  }

  Future<void> addToFavourites(
      {required String productId,
      required String productName,
      required String brand,
      required String category,
      required int quantity,
      required String images,
      required double price}) async {
    final existing = await _firestore
        .collection('favourites')
        .where('userId', isEqualTo: _uid)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return;

    final id = Uuid().v1();
    _firestore.collection("favourites").doc(id).set({
      'name': productName,
      'id': id,
      'productId': productId,
      'userId': _uid,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'images': images,
      'price': price
    });
  }
}
