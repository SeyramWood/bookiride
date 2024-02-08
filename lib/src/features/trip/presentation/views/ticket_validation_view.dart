import 'package:bookihub/src/features/trip/presentation/provider/toggle_validation.dart';
import 'package:bookihub/src/features/trip/presentation/views/ticket_detail_view.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:flutter_dash/flutter_dash.dart';

import '../widgets/text_in_column.dart';

class ValidateTicketView extends StatefulWidget {
  const ValidateTicketView({super.key});

  @override
  State<ValidateTicketView> createState() => _ValidateTicketViewState();
}

class _ValidateTicketViewState extends State<ValidateTicketView> {
  final Clicked clicked = Clicked();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Validation"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: clicked,
        builder: (context, stateOfContainer, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SearchField(hintText: 'Search', borderRadius: 25),
              const SizedBox(height: 10),
              Material(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => clicked.isClicked(true),
                          child: _buildButton(
                            text: 'Unchecked',
                            backgroundColor: stateOfContainer ? blue : white,
                            textColor: stateOfContainer ? white : black,
                            showCircle: stateOfContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => clicked.isClicked(false),
                          child: _buildButton(
                            text: 'Verified',
                            backgroundColor: stateOfContainer ? null : blue,
                            textColor: stateOfContainer ? black : white,
                            showCircle: !stateOfContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _ticketTile();
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketTile() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TicketDetailView(),
        ));
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextInColumn(label: 'Ticket Number: ', sub: 'sub'),
                Dash(
                  direction: Axis.vertical,
                  length: 35,
                ),
                TextInColumn(label: 'No. passengers: ', sub: 'sub'),
                Dash(
                  direction: Axis.vertical,
                  length: 35,
                ),
                TextInColumn(label: 'Luggage: ', sub: 'sub'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //button to switch between unchecked and verified
  Widget _buildButton({
    required String text,
    required Color? backgroundColor,
    required Color textColor,
    required bool showCircle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
          if (showCircle)
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('5'),
            ),
        ],
      ),
    );
  }
}

//This a text field for search
class SearchField extends StatelessWidget {
  final String hintText;
  final double borderRadius;

  const SearchField({
    super.key,
    required this.hintText,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }
}
