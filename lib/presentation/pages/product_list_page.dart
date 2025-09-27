import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/presentation/blocs/list/product_list_bloc.dart';
import 'package:klontong/presentation/widgets/product_card.dart';
import 'package:klontong/presentation/widgets/product_grid_card.dart';
import 'package:klontong/presentation/widgets/product_grid_shimmer.dart';
import 'package:klontong/presentation/widgets/product_shimmer.dart';
import 'package:klontong/routes/app_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _controller = TextEditingController();
  bool _isGridView = false;
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    context.read<ProductListBloc>().add(ProductListLoaded());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductListBloc>().add(ProductListLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ProductListBloc>().add(ProductListLoaded());
  }

  Future<void> _simulateError() async {
    try {
      throw StateError('Simulated error from ProductListPage');
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('page', 'ProductListPage');
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Error simulation sent successfully'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildSearchAndToggle(context),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ProductListBloc, ProductListState>(
                  builder: (context, state) {
                    if (state.status == ProductListStatus.loading) {
                      return _buildShimmer();
                    }
                    // Error state tetap bisa pull-to-refresh
                    else if (state.status == ProductListStatus.failure) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 200),
                            Center(
                              child: Text(
                                state.error ?? 'Unknown error',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    // Success & loadingMore state
                    else if (state.status == ProductListStatus.success ||
                        state.status == ProductListStatus.loadingMore) {
                      final data = state.data!;
                      if (data.totalItems == 0) {
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 200),
                              Center(child: Text('No products')),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        child:
                            _isGridView
                                ? _buildGridView(data.items, state)
                                : _buildListView(data.items, state),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Klontong',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _simulateError,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.bug_report, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Simulate Error',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRouter.productForm,
                    );
                    if (result == true && context.mounted) {
                      context.read<ProductListBloc>().add(ProductListLoaded());
                    }
                  },

                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                hintText: 'Search product...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _controller.clear();
                            context.read<ProductListBloc>().add(
                              ProductListQueryChanged(''),
                            );
                            setState(() {}); // refresh biar X hilang
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 400), () {
                  context.read<ProductListBloc>().add(
                    ProductListQueryChanged(value),
                  );
                });
                setState(() {}); // update suffixIcon
              },
              onSubmitted: (value) {
                // Optional: langsung search saat tekan enter
                context.read<ProductListBloc>().add(
                  ProductListQueryChanged(value),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildIconBox(
          icon: _isGridView ? Icons.view_list : Icons.grid_view,
          onTap: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
      ],
    );
  }

  Widget _buildIconBox({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[600]),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildListView(List<dynamic> items, ProductListState state) {
    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount:
          items.length +
          (state.status == ProductListStatus.loadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final p = items[i];
        return ProductCard(
          product: p,
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRouter.productDetail,
              arguments: p.id,
            );
            if (result == true && context.mounted) {
              context.read<ProductListBloc>().add(ProductListLoaded());
            }
          },
        );
      },
    );
  }

  Widget _buildGridView(List<dynamic> items, ProductListState state) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount:
          items.length +
          (state.status == ProductListStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final p = items[i];
        return ProductGridCard(
          product: p,
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRouter.productDetail,
              arguments: p.id,
            );
            if (result == true && context.mounted) {
              context.read<ProductListBloc>().add(ProductListLoaded());
            }
          },
        );
      },
    );
  }

  Widget _buildShimmer() {
    if (_isGridView) {
      return GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, __) => const ProductGridShimmer(),
      );
    } else {
      return ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const ProductShimmer(),
      );
    }
  }
}
