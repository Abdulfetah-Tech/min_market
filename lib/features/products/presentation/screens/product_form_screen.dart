// Product form screen - create/edit product

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:min_market/core/core.dart';
import 'package:min_market/features/products/domain/entities/product.dart';
import 'package:min_market/features/products/presentation/bloc/products_bloc.dart';
import 'package:min_market/features/products/presentation/bloc/products_event.dart';
import 'package:min_market/features/products/presentation/bloc/products_state.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _category = 'smartphones';

  static const _categories = [
    'smartphones',
    'audio',
    'clothing',
    'computers',
    'photography',
    'accessories',
    'furniture',
  ];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;
    if (product != null) {
      _titleController.text = product.title;
      _priceController.text = product.price % 1 == 0
          ? product.price.toInt().toString()
          : product.price.toString();
      _descriptionController.text = product.description;
      _imageUrlController.text = product.imageUrl ?? '';
      _category = _categories.contains(product.category)
          ? product.category
          : _categories.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a title';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a price';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a description';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim().isEmpty
        ? null
        : _imageUrlController.text.trim();

    final product = Product(
      id: _isEditing ? widget.product!.id : 'p${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      price: price,
      category: _category,
      description: description,
      imageUrl: imageUrl,
    );

    if (_isEditing) {
      context.read<ProductsBloc>().add(UpdateProductEvent(product));
    } else {
      context.read<ProductsBloc>().add(CreateProductEvent(product));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Product updated' : 'Product added'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    if (context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (context.mounted) {
            context.pop();
          }
        } else if (state is ProductActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Edit product' : 'Add product',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const _FieldLabel('Title'),
                      AppTextField(
                        controller: _titleController,
                        hint: 'Desk lamp',
                        validator: _validateTitle,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      const _FieldLabel('Price'),
                      AppTextField(
                        controller: _priceController,
                        hint: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _validatePrice,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      const _FieldLabel('Category'),
                      AppDropdownField<String>(
                        value: _category,
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      const _FieldLabel('Description'),
                      AppTextField(
                        controller: _descriptionController,
                        hint: 'Short description',
                        maxLines: 3,
                        validator: _validateDescription,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      const _FieldLabel('Image URL (optional)'),
                      AppTextField(
                        controller: _imageUrlController,
                        hint: 'https://example.com/image.jpg',
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      final isLoading = state is ProductActionLoading;
                      return AppButton(
                        onPressed: isLoading ? null : _save,
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.large,
                        isLoading: isLoading,
                        child: Text(
                          _isEditing ? 'Save changes' : 'Save product',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}