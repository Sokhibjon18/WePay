import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we_pay/domain/product/value_objects.dart';

part 'product.freezed.dart';

@freezed
abstract class Product implements _$Product {
  const Product._();

  const factory Product({
    String? uid,
    required String apartmentId,
    required ProductName name,
    required String buyerName,
    required String buyerId,
    required ProductPrice price,
    required int count,
    required Color color,
    String? note,
    required DateTime date,
  }) = _Product;
}
