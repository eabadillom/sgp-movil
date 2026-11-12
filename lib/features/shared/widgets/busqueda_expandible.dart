import 'package:flutter/material.dart';

class BusquedaExpandible extends StatefulWidget 
{
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hintText;
  final String searchTooltip;

  const BusquedaExpandible({super.key, required this.initialValue, required this.onChanged, this.hintText = 'Buscar...', this.searchTooltip = 'Buscar'});

  @override
  State<BusquedaExpandible> createState() => _BusquedaExpandibleState();
}

class _BusquedaExpandibleState extends State<BusquedaExpandible> 
{
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;

  @override
  void initState() 
  {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant BusquedaExpandible oldWidget) 
  {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && _controller.text != widget.initialValue) {
      _setSearchText(widget.initialValue);
    }
  }

  @override
  void dispose() 
  {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      width: _isOpen ? MediaQuery.sizeOf(context).width - 32 : 56,
      height: 56,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(_isOpen ? 16 : 28),
        border: Border.all(color: _isOpen ? colors.outlineVariant : Colors.transparent),
        boxShadow: 
        [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) 
          {
            return FadeTransition(opacity: animation, child: child);
          },
          child: LayoutBuilder(
            key: ValueKey(_isOpen ? 'search-open' : 'search-closed'),
            builder: (context, constraints) 
            {
              if (!_isOpen) {
                return IconButton(
                  tooltip: widget.searchTooltip,
                  onPressed: _toggleSearch,
                  icon: const Icon(Icons.search_rounded),
                );
              }

              if (constraints.maxWidth < 64) 
              {
                return Center(
                  child: Icon(
                    Icons.search_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                );
              }

              final isCompact = constraints.maxWidth < 92;
              final searchField = TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 1,
                textInputAction: TextInputAction.search,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: colors.onSurfaceVariant),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _handleSearchChanged,
              );

              return Row(
                children: [
                  if (isCompact)
                    Icon(Icons.search_rounded, color: colors.onSurfaceVariant)
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Icon(
                        Icons.search_rounded,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  if (!isCompact) const SizedBox(width: 10),
                  Expanded(child: searchField),
                  if (_controller.text.isNotEmpty &&
                      constraints.maxWidth >= 132)
                    IconButton(
                      tooltip: 'Limpiar búsqueda',
                      visualDensity: VisualDensity.compact,
                      onPressed: _clearSearch,
                      icon: const Icon(Icons.cancel_sharp),
                    ),
                  IconButton(
                    tooltip: 'Cerrar búsqueda',
                    visualDensity: VisualDensity.compact,
                    onPressed: _toggleSearch,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  if (!isCompact) const SizedBox(width: 4),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _toggleSearch() 
  {
    if (_isOpen) {
      _focusNode.unfocus();
      setState(() => _isOpen = false);
      return;
    }

    _setSearchText(widget.initialValue);
    setState(() => _isOpen = true);

    WidgetsBinding.instance.addPostFrameCallback((_) 
    {
      if (mounted && _isOpen) {
        _focusNode.requestFocus();
      }
    });
  }

  void _clearSearch() 
  {
    _setSearchText('');
    setState(() {});
    widget.onChanged('');
    _focusNode.requestFocus();
  }

  void _handleSearchChanged(String value) 
  {
    setState(() {});
    widget.onChanged(value);
  }

  void _setSearchText(String value) 
  {
    _controller.value = TextEditingValue(text: value, selection: TextSelection.collapsed(offset: value.length));
  }
}
