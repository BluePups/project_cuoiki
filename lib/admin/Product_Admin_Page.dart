import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/admin/Product_Update_Page.dart';
import 'package:cuoiki/helper/Dialogs.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/mywidgets/async_widget.dart';

import 'Product_Add_Page.dart';

class ProductAdminPage extends StatelessWidget {
  ProductAdminPage({super.key});
  late BuildContext myContext; //myContext được lưu lại để dùng trong các hành động

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
                        Product product = list[index];
                        return Slidable( //Slidable – thao tác vuốt để sửa hoặc xóa
                          key: const ValueKey(0),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            extentRatio: 0.6,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(//SlidableAction – Cập nhật
                                onPressed: (context) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => PageUpdateProduct(product: product),)
                                  );
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Cập nhật',
                              ),
                              SlidableAction(//SlidableAction – Xóa
                                onPressed: (context) async{
                                  String? xacNhan = await showConfirmDialog(myContext, "Bạn chắc chắn muốn xóa sản phẩm này ko???");
                                  if(xacNhan == "ok") {
                                    ProductSnapShot.delete(product.id);
                                    ScaffoldMessenger.of(myContext).clearSnackBars();
                                    ScaffoldMessenger.of(myContext).showSnackBar(
                                        SnackBar(content: Text("Đã xóa ${product.ten}"))
                                    );
                                  }
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever,
                                label: 'Xóa',
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Image.network(product.anh?? "thay link ảnh mặc định vào đây")
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Mã sản phẩm: ${product.id}"),
                                      Text("Tên: " + product.ten, style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("Giá: ${product.gia} vnđ", style: TextStyle(color: Colors.red),),
                                      Text(product.moTa?? ""),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(thickness: 1.5,),
                      itemCount: list.length,),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PageAddProduct(),)
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}