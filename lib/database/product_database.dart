import 'package:cadastro_produto_banco_de_dados/model/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductDatabase {
  static final ProductDatabase _instance = ProductDatabase._internal();

  factory ProductDatabase() => _instance;
  ProductDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();

    return _db!;
  }

  Future<Database> _initDB() async {
    final dbCaminho = await getDatabasesPath();
    final caminhoCompleto = join(dbCaminho, 'produtos_database_db');

    return await openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: (db, version) async {
        return await db.execute('''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            preco REAL NOT NULL,
            preco_venda REAL NOT NULL,
            quantidade INTEGER NOT NULL,
            categoria TEXT NOT NULL,
            descricao TEXT,
            imagem TEXT,
            ativo INTEGER NOT NULL DEFAULT 1,
            em_promocao INTEGER NOT NULL DEFAULT 0,
            data_cadastro TEXT NOT NULL DEFAULT (datatime('now')),
            desconto REAL NOT NULL DEFAULT 0.0
            )
          ''');
      },
    );
  }

  Future<int> insertProduct(ProdutoModel productModel) async {
    final db = await database;
    return await db.insert('produtos', productModel.toMap());
  }

  Future<List<ProdutoModel>> findAllProducts() async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, Object?>> listMap = await db.query('produtos');
    return listMap.map((map) => ProdutoModel.fromMap(map)).toList();
  }

  Future<int> updateProduct(int id, ProdutoModel productModel) async {
    final db = await database;
    return await db.update(
      'produtos',
      productModel.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id, ProdutoModel productModel) async {
    final db = await database;
    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }
}
