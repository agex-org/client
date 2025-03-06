import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  final double width; // Parameter for width
  final Function(String)? onSubmit; // Callback for submit action
  final bool showSubmitButton; // Whether to show the submit button

  const RoundedTextField({
    super.key,
    required this.width,
    this.onSubmit,
    this.showSubmitButton = false, // Default to false
  });

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  final TextEditingController _controller =
      TextEditingController(); // Controller for the TextField

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller, // Assign the controller
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff293038), // Gray background
                prefixIcon:
                    Icon(Icons.search, color: Color(0xff9cabba)), // Search icon
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Color(0xff9cabba), // Gray hint text
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Rounded borders
                  borderSide: BorderSide.none, // No border side
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onSubmitted: (value) {
                if (widget.onSubmit != null) {
                  widget.onSubmit!(value); // Trigger the submit callback
                }
              },
            ),
          ),
          if (widget.showSubmitButton) // Conditionally show the submit button
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                child: Material(
                  color: Colors.blue, // Background color of the button
                  child: InkWell(
                    onTap: () {
                      if (widget.onSubmit != null) {
                        // Trigger the submit callback with the text field's value
                        widget.onSubmit!(_controller.text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Rounded corners
      child: Material(
        color: Color(0xff293038), // Background color of the button
        child: InkWell(
          onTap: onPressed, // Handle button press
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: Color(0xff9cabba), // Icon color
            ),
          ),
        ),
      ),
    );
  }
}
