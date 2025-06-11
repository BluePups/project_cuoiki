import 'package:cuoiki/admin/Product_Add_Page.dart';
import 'package:cuoiki/admin/Product_Update_Page.dart';
import 'package:cuoiki/admin/Product_Update_Page.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Dialogs.dart';
import 'package:cuoiki/mywidgets/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PageProductAdmin extends StatelessWidget {
  PageProductAdmin({super.key});
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchKeyword = ValueNotifier<String>("");
  late BuildContext myContext;
  void _onSearch(){
    _searchKeyword.value = _searchController.text.toLowerCase();
  }
//PageProductAdmin là một StatelessWidget.
// Vì trạng thái nội bộ không thay đổi trong chính widget này – dữ liệu được cập nhật qua StreamBuilder,
// nên không cần sử dụng StatefulWidget.
  // Toàn bộ phần thay đổi (product list) được quản lý bằng stream (ProductSnapShot.getProductStream()),
  // nên dùng StatelessWidget là hợp lý và tiết kiệm tài nguyên.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Admin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
      Column(
        children:[
          // Ô tìm kiếm
          // Ô tìm kiếm + nút tìm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // TextField nhập từ khóa
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Nhập tên hoặc ID sản phẩm...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: Text("Tìm"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _searchKeyword,
              builder: (context, keyword, _) {
                return StreamBuilder<List<Product>>(
                  stream: ProductSnapShot.getProductStream(),
                  builder: (context, snapshot) {
                    return AsyncWidget(
                      snapshot: snapshot,
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? [];

                        final filtered = list.where((product) {
                          final name = (product.ten ?? '').toLowerCase();
                          final id = (product.id ?? '').toString().toLowerCase();
                          return name.contains(keyword) || id.contains(keyword);
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(child: Text("Không tìm thấy sản phẩm."));
                        }

                        return ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => Divider(thickness: 1),
                          itemBuilder: (context, index) {
                            final product = filtered[index];
                            return Slidable(
                              key: ValueKey(product.id),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                extentRatio: 0.7,
                                children: [
                                  SlidableAction(
                                    onPressed: (_) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PageUpdateProduct(product: product),
                                        ),
                                      );
                                    },
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Cập nhật',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) async {
                                      final xacNhan = await showConfirmDialog(
                                          context, "Bạn có muốn xóa ${product.ten}?");
                                      if (xacNhan == "ok") {
                                        ProductSnapShot.delete(product.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Đã xóa ${product.id}")),
                                        );
                                      }
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete_forever,
                                    label: 'Xóa',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Image.network(
                                  product.anh ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.image_not_supported),
                                ),
                                title: Text(product.ten ?? ""),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ID: ${product.id}"),
                                    Text("Giá: ${product.gia} VNĐ"),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            //Cập nhật: Sử dụng Navigator.of(context).push(...) để chuyển sang PageUpdateProduct, truyền theo đối tượng product.
            // Thêm sản phẩm: Tương tự, chuyển sang PageAddProduct.
            builder: (context) => PageAddProduct(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}