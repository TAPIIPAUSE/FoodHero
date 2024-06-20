import 'package:flutter/material.dart';
import 'package:foodhero/example/model/product_model.dart';
import 'package:foodhero/example/service/http.dart';

class PUT extends StatefulWidget {
  final Product data;
  const PUT({super.key, required this.data});

  @override
  State<PUT> createState() => _PUTState();
}

class _PUTState extends State<PUT> {
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data.name.toString();
    priceController.text = widget.data.price.toString();
    descController.text = widget.data.desc.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                label: Text("Name"),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                label: Text("Price"),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                label: Text("Desc"),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Http.putProduct(widget.data.id, {
                  "id": widget.data.id,
                  "name": nameController.text,
                  "price": priceController.text,
                  "desc": descController.text,
                });
              },
              child: const Text("PUT"),
            ),
          ],
        ),
      ),
    );
  }
}
