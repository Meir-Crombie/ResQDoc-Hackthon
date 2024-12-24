import 'package:flutter/material.dart';

class ParamedicDoc extends StatefulWidget {
  const ParamedicDoc({super.key});

  @override
  State<ParamedicDoc> createState() => _ParamedicDocState();
}

class _ParamedicDocState extends State<ParamedicDoc> {
  final List<FocusNode> focusNodes = [];
  final List<bool> checkedNodes = [];

  @override
  void initState() {
    super.initState();
    // Create a FocusNode for each DefaultTextField
    for (int i = 0; i < 30; i++) {
      // Adjust based on your total number of fields
      focusNodes.add(FocusNode());
    }
    for (int i = 0; i < 30; i++) {
      // Adjust based on your total number of fields
      checkedNodes.add(false);
    }
  }

  @override
  void dispose() {
    // Dispose of all FocusNodes
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('תיעוד רפואי מלא'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // עטוף את התוכן ב-SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי הכונן',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מזהה כונן',
                        checkedNode: checkedNodes[0],
                        focusNode: focusNodes[0],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[1]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם כונן',
                        checkedNode: checkedNodes[1],
                        focusNode: focusNodes[1],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[2]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי האירוע',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר משימה',
                        checkedNode: checkedNodes[2],
                        focusNode: focusNodes[2],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[3]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן פתיחת האירוע',
                        checkedNode: checkedNodes[3],
                        focusNode: focusNodes[3],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[4]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'עיר',
                    checkedNode: checkedNodes[4],
                    focusNode: focusNodes[4],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[5]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית',
                        checkedNode: checkedNodes[5],
                        focusNode: focusNodes[5],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[6]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב',
                        checkedNode: checkedNodes[6],
                        focusNode: focusNodes[6],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[7]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'שם',
                    checkedNode: checkedNodes[7],
                    focusNode: focusNodes[7],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[8]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'המקרה שהוזנק',
                        checkedNode: checkedNodes[8],
                        focusNode: focusNodes[8],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[9]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן הגעת הכונן',
                        checkedNode: checkedNodes[9],
                        focusNode: focusNodes[9],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[10]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי המטופל',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'ת.ז. או מספר דרכון',
                        checkedNode: checkedNodes[10],
                        focusNode: focusNodes[10],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[11]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם פרטי מטופל',
                        checkedNode: checkedNodes[11],
                        focusNode: focusNodes[11],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[12]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם משפחה מטופל',
                        checkedNode: checkedNodes[12],
                        focusNode: focusNodes[12],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[13]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'גיל המטופל',
                        checkedNode: checkedNodes[13],
                        focusNode: focusNodes[13],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[14]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מין המטופל',
                    checkedNode: checkedNodes[14],
                    focusNode: focusNodes[14],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[15]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'ישוב המטופל',
                    checkedNode: checkedNodes[15],
                    focusNode: focusNodes[15],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[16]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב המטופל',
                        checkedNode: checkedNodes[16],
                        focusNode: focusNodes[16],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[17]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית מטופל',
                        checkedNode: checkedNodes[17],
                        focusNode: focusNodes[17],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[18]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'טלפון המטופל',
                    checkedNode: checkedNodes[18],
                    focusNode: focusNodes[18],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[19]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מייל המטופל',
                    checkedNode: checkedNodes[19],
                    focusNode: focusNodes[19],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[20]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'ממצאים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'המקרה שנמצא',
                        checkedNode: checkedNodes[20],
                        focusNode: focusNodes[20],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[21]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'סטטוס המטופל',
                        checkedNode: checkedNodes[21],
                        focusNode: focusNodes[21],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNodes[22]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'תלונה עיקרית',
                    checkedNode: checkedNodes[22],
                    focusNode: focusNodes[22],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[23]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'אנמנזה וסיפור המקרה',
                    checkedNode: checkedNodes[23],
                    focusNode: focusNodes[23],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[24]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'רגישויות',
                    checkedNode: checkedNodes[24],
                    focusNode: focusNodes[24],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(focusNodes[25]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'מדדים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת הכרה',
                        focusNode: _focusNodes[25],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes[26]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'האזנה לריאות ',
                        focusNode: _focusNodes[26],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes[27]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב נשימה',
                        focusNode: _focusNodes[27],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes[28]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'קצב נשימה',
                        focusNode: _focusNodes[28],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes[29]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מצב העור',
                    focusNode: _focusNodes[29],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_focusNodes[30]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultTextField extends StatefulWidget {
  final String labelText;
  bool checkedNode; // Made mutable to toggle on double-tap
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  DefaultTextField({
    required this.labelText,
    required this.checkedNode,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (widget.checkedNode == true) {
          setState(() {
            widget.checkedNode =
                false; // Change checkedNode to true on double-tap
          });
        } else {
          setState(() {
            widget.checkedNode =
                true; // Change checkedNode to true on double-tap
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(
            8), // Optional: Adds padding inside the container
        child: TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: widget.checkedNode
                ? Colors.green
                : Colors.red, // Background based on checkedNode
          ),
        ),
      ),
    );
  }
}
