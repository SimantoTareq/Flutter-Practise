// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

class OrderModel {
  OrderModel({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.vat,
    this.orderDateAndTime,
    this.user,
    this.payment,
    this.orderStatus,
  });

  final int? id;
  final int? quantity;
  final int? price;
  final dynamic discount;
  final dynamic vat;
  final DateTime? orderDateAndTime;
  final User? user;
  final Payment? payment;
  final OrderStatus? orderStatus;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"] == null ? null : json["id"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        price: json["price"] == null ? null : json["price"],
        discount: json["discount"],
        vat: json["VAT"],
        orderDateAndTime: json["order_date_and_time"] == null
            ? null
            : DateTime.parse(json["order_date_and_time"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        orderStatus: json["order_status"] == null
            ? null
            : OrderStatus.fromJson(json["order_status"]),
      );
}

class OrderStatus {
  OrderStatus({
    this.orderStatusCategory,
  });

  final User? orderStatusCategory;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        orderStatusCategory: json["order_status_category"] == null
            ? null
            : User.fromJson(json["order_status_category"]),
      );
}

class User {
  User({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class Payment {
  Payment({
    this.paymentStatus,
  });

  final int? paymentStatus;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
      );

  Map<String, dynamic> toJson() => {
        "payment_status": paymentStatus == null ? null : paymentStatus,
      };
}
