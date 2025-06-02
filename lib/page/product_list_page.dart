import 'package:cadastro_produto_banco_de_dados/database/product_database.dart';
import 'package:cadastro_produto_banco_de_dados/model/product_model.dart';
import 'package:cadastro_produto_banco_de_dados/page/components/list_item.dart';
import 'package:cadastro_produto_banco_de_dados/page/product_form_page.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<ProdutoModel>> _carregaProdutos() async {
    final db = ProductDatabase();
    return await db.findAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista e Cadastro de Produto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: const [
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Scaffold(
        backgroundColor: Colors.grey[100],

        body: FutureBuilder<List<ProdutoModel>>(
          future: _carregaProdutos(),
          builder: (context, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.grey),
              );
            } else if (snapshort.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar a lista de produtos: ${snapshort.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshort.hasError || snapshort.data!.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum produto cadastrado',
                  style: TextStyle(color: Colors.black87, fontSize: 19.0),
                ),
              );
            }
            final listaProdutos = snapshort.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 75),
              itemCount: listaProdutos.length,
              itemBuilder: (context, index) {
                final produto = snapshort.data![index];
                return ListItem(product: produto);
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductFormPage()),
            );
          },
          label: const Text(
            'Novo Produto',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
