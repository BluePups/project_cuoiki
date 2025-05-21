import 'package:du_an_cuoi_ki/admin/Product_Add_Page.dart';
import 'package:du_an_cuoi_ki/admin/Product_Update_Page.dart';
import 'package:du_an_cuoi_ki/admin/Product_Update_Page.dart';
import 'package:du_an_cuoi_ki/models/Product_Model.dart';
import 'package:du_an_cuoi_ki/helper/Dialogs.dart';
import 'package:du_an_cuoi_ki/mywidgets/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PageProductAdmin extends StatelessWidget {
  PageProductAdmin({super.key});
  late BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Admin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Product>>(
          stream: ProductSnapShot.getProductStream(),
          builder: (context, snapshot) {
            myContext = context;
            return AsyncWidget(
              snapshot: snapshot,
              builder: (context, snapshot) {
                var list = snapshot.data! as List<Product>;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var product = list[index];

                        return Slidable(
                          // Specify a key if the Slidable is dismissible.
                          key: const ValueKey(0),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            extentRatio: 0.7,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                onPressed: (context) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PageUpdateProduct(product: product),
                                  ));
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Cập nhật',
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  String? xacNhan = await showConfirmDialog(
                                      myContext,
                                      "Bạn có muốn xóa ${product.ten}?");

                                  if (xacNhan == "ok") {
                                    ProductSnapShot.delete(product.id);
                                    ScaffoldMessenger.of(myContext)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(myContext)
                                        .showSnackBar(SnackBar(
                                        content:
                                        Text("Đã xóa ${product.id}")));
                                  }
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever,
                                label: 'Xóa',
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Image.network(
                                    product.anh ?? "No image",
                                    fit: BoxFit.fill,
                                    height: 100,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("id: ${product.id}"),
                                      Text("Tên: ${product.ten}"),
                                      Text("Giá: ${product.gia} VNĐ"),
                                      Text("Mô tả: ${product.moTa ?? ""}")
                                    ],
                                  )),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 2,
                      ),
                      itemCount: list.length),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageAddProduct(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}