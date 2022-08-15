import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../config/theme/global_theme.dart';
import '../../providers/ui_elements_provider.dart';
import '../custom_icon_button.dart';

class AppBarWithSearchTextField extends StatelessWidget
    implements PreferredSizeWidget {
  final String label;
  final Function(String value)? onChanged;

  const AppBarWithSearchTextField({
    super.key,
    required this.label,
    this.onChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GlobalTheme.lightTheme,
      child: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              _BackButton(),
              _Title(label: label),
              _SearchTextField(onChanged: (String value) {
                onChanged!(value.trim());
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final UIElementsProvider _uiElementsProvider = UIElementsProvider();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: CustomIconButton(
        icon: _uiElementsProvider.getAppBarBackIcon(),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String label;

  const _Title({required this.label});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 60,
      right: 60,
      child: SizedBox(
        height: kToolbarHeight,
        child: Center(
          child: Text(
            label,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchTextField extends StatefulWidget {
  final Function(String value)? onChanged;

  const _SearchTextField({required this.onChanged});

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late bool _isSearchMode;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _isSearchMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      bottom: 0,
      left: _isSearchMode ? 0 : screenWidth - 56,
      child: Container(
        width: screenWidth,
        height: kToolbarHeight,
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Row(
          children: [
            CustomIconButton(
              icon: MdiIcons.magnify,
              onPressed: () {
                if (_isSearchMode == false) {
                  setState(() {
                    _isSearchMode = true;
                    _focusNode.requestFocus();
                  });
                }
              },
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                onChanged: widget.onChanged,
                decoration: const InputDecoration(
                  hintText: 'Szukaj',
                  border: InputBorder.none,
                ),
              ),
            ),
            CustomIconButton(
              icon: MdiIcons.arrowRight,
              onPressed: () {
                if (_isSearchMode) {
                  setState(() {
                    _isSearchMode = false;
                    _focusNode.unfocus();
                    _controller.text = '';
                  });
                  widget.onChanged!('');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
