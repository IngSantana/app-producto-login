import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/Models/producto_model.dart';

class ProdctosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

//referencias a nuestro productos providers para poder realizar la peticion a cada uno de los procesos
  final _productosProvider = new ProductosProvider();

//escuchamos nuestros controllers
  Stream<List<ProductoModel>> get productosStream => _productosController;
  Stream<bool> get cargando => _cargandoController;

  //metodos para manejar los productos
  void cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

//cerrando controllers
  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
