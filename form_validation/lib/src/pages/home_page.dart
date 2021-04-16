import 'package:flutter/material.dart';
import 'package:form_validation/src/Models/producto_model.dart';
import 'package:form_validation/src/bloc/provider.dart';
//import 'package:form_validation/src/bloc/provider.dart';
//import 'package:form_validation/src/providers/productos_providers.dart';

class HomePage extends StatelessWidget {
  //  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: //Container(),
          _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return Scrollbar(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              itemCount: productos.length,
              itemBuilder: (context, i) =>
                  _crearItem(context, productosBloc, productos[i]),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    /* return FutureBuilder(
      //   future: productosProvider.cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );*/
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) => productosBloc.borrarProductos(producto.id),
        /*{
         productosProvider.borrarProducto(producto.id);
          
        }*/
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}
