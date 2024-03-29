import 'package:flutter/material.dart';
import 'package:flutter_products/models/product.dart';
import 'package:flutter_products/pages/product_add.dart';
import 'package:flutter_products/provider/products_service.dart';
import 'package:flutter_products/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key, required this.onTapCallback});

  final Function(Product) onTapCallback;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  bool showSearch = false;
  bool showFilters = false;

  late TextEditingController searchBarController;
  late FocusNode searchFocusNode;

  bool? sortNameAsc;
  bool? sortPriceAsc;
  bool? sortRatingAsc;

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sortNameAsc = context.watch<ProductsService>().sortNameAsc;
    sortPriceAsc = context.watch<ProductsService>().sortPriceAsc;
    sortRatingAsc = context.watch<ProductsService>().sortRatingAsc;

    return ChangeNotifierProvider.value(
        value: context.read<ProductsService>(),
        child: Consumer<ProductsService>(
          builder: (context, service, child) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Productos'),
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Actualizar',
                        onPressed: () {
                          service.updateProducts();
                        }),
                    IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Buscar Producto',
                        onPressed: () {
                          setState(() {
                            showSearch = !showSearch;
                          });
                          if (!showSearch) {
                            searchBarController.clear();
                            service.filterProducts('');
                          } else {
                            searchFocusNode.requestFocus();
                          }
                        }),
                    IconButton(
                        icon: const Icon(Icons.sort),
                        tooltip: 'Ordenar Productos',
                        onPressed: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.add_outlined),
                        tooltip: 'Nuevo Producto',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductAdd()),
                          ).then((value) => {service.updateProducts()});
                        })
                  ],
                ),
                body: Row(
                  children: [
                    Expanded(
                      child: Column(children: [
                        Container(
                          width: double.infinity,
                          padding: service.lastError.isNotEmpty
                              ? const EdgeInsets.all(10)
                              : EdgeInsets.zero,
                          color: Colors.red[100],
                          child: service.lastError.isNotEmpty
                              ? Text(
                                  service.lastError,
                                  style: const TextStyle(color: Colors.black),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SEARCH BAR
                            !showSearch
                                ? const SizedBox.shrink()
                                : Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SearchBar(
                                                controller: searchBarController,
                                                focusNode: searchFocusNode,
                                                padding:
                                                    const MaterialStatePropertyAll<
                                                            EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.0)),
                                                onChanged: (value) => {
                                                      service.filterProducts(
                                                          value),
                                                    },
                                                onSubmitted: (value) => {
                                                      service.filterProducts(
                                                          value),
                                                    },
                                                leading: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      const Icon(Icons.search),
                                                ),
                                                trailing: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.close),
                                                    tooltip: 'Limpiar',
                                                    onPressed: () {
                                                      searchBarController
                                                          .clear();
                                                      service
                                                          .filterProducts('');
                                                    },
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            // filters
                            !showFilters
                                ? const SizedBox.shrink()
                                : Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          ActionChip(
                                            avatar: Icon((sortNameAsc != null)
                                                ? (sortNameAsc!
                                                    ? Icons.arrow_downward
                                                    : Icons.arrow_upward)
                                                : Icons.sort),
                                            label: const Text('Nombre'),
                                            onPressed: () =>
                                                {service.sortName()},
                                          ),
                                          const SizedBox(width: 10),
                                          ActionChip(
                                            avatar: Icon((sortPriceAsc != null)
                                                ? (sortPriceAsc!
                                                    ? Icons.arrow_downward
                                                    : Icons.arrow_upward)
                                                : Icons.sort),
                                            label: const Text('Precio'),
                                            onPressed: () =>
                                                {service.sortPrice()},
                                          ),
                                          const SizedBox(width: 10),
                                          ActionChip(
                                            avatar: Icon((sortRatingAsc != null)
                                                ? (sortRatingAsc!
                                                    ? Icons.arrow_downward
                                                    : Icons.arrow_upward)
                                                : Icons.sort),
                                            label: const Text('Rating'),
                                            onPressed: () =>
                                                {service.sortRating()},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        // // SEARCH BAR
                        // !showSearch
                        //     ? const SizedBox.shrink()
                        //     : Container(
                        //         padding: const EdgeInsets.all(10),
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               child: SearchBar(
                        //                   controller: searchBarController,
                        //                   focusNode: searchFocusNode,
                        //                   padding:
                        //                       const MaterialStatePropertyAll<
                        //                               EdgeInsets>(
                        //                           EdgeInsets.symmetric(
                        //                               horizontal: 10.0)),
                        //                   onChanged: (value) => {
                        //                         service.filterProducts(value),
                        //                         debugPrint(
                        //                             'SearchBar onChanged: $value'),
                        //                       },
                        //                   onSubmitted: (value) => {
                        //                         service.filterProducts(value),
                        //                         debugPrint(
                        //                             'SearchBar onSubmitted: $value'),
                        //                       },
                        //                   leading: Container(
                        //                     padding: const EdgeInsets.all(10),
                        //                     child: const Icon(Icons.search),
                        //                   ),
                        //                   trailing: [
                        //                     IconButton(
                        //                       icon: const Icon(Icons.close),
                        //                       tooltip: 'Limpiar',
                        //                       onPressed: () {
                        //                         searchBarController.clear();
                        //                         service.filterProducts('');
                        //                       },
                        //                     ),
                        //                   ]),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        // // filters
                        // !showFilters
                        //     ? const SizedBox.shrink()
                        //     : Container(
                        //         padding: const EdgeInsets.all(10),
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               child: SearchBar(
                        //                   controller: searchBarController,
                        //                   focusNode: searchFocusNode,
                        //                   padding:
                        //                       const MaterialStatePropertyAll<
                        //                               EdgeInsets>(
                        //                           EdgeInsets.symmetric(
                        //                               horizontal: 10.0)),
                        //                   onChanged: (value) => {
                        //                         service.filterProducts(value),
                        //                         debugPrint(
                        //                             'SearchBar onChanged: $value'),
                        //                       },
                        //                   onSubmitted: (value) => {
                        //                         service.filterProducts(value),
                        //                         debugPrint(
                        //                             'SearchBar onSubmitted: $value'),
                        //                       },
                        //                   leading: Container(
                        //                     padding: const EdgeInsets.all(10),
                        //                     child: const Icon(Icons.search),
                        //                   ),
                        //                   trailing: [
                        //                     IconButton(
                        //                       icon: const Icon(Icons.close),
                        //                       tooltip: 'Limpiar',
                        //                       onPressed: () {
                        //                         searchBarController.clear();
                        //                         service.filterProducts('');
                        //                       },
                        //                     ),
                        //                   ]),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: service.filteredProducts.length,
                            itemBuilder: (context, index) {
                              return ProductListItem(
                                product: service.filteredProducts[index],
                                onTapCallback: (product) =>
                                    widget.onTapCallback(product),
                              );
                            },
                          ),
                        )
                      ]),
                    ),
                  ],
                ));
          },
        ));
  }

  Widget buildProductsList(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductListItem(
          product: products[index],
          onTapCallback: (product) => widget.onTapCallback(product),
        );
      },
    );
  }
}
