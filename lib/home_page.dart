import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'game_board.dart';
import 'home_page_model.dart';
import 'package:chess_app/components/app_bar.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          onLeadingPressed: () {},
          onSettingsPressed: () {},
        ),
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height * 1,
          child: Stack(
            alignment: const AlignmentDirectional(0, -1),
            children: [
              Align(
                alignment: const AlignmentDirectional(-0.1, 0.16),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 1,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 136, 66, 66)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, -0.88),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/chess-home-img.png',
                            width: 350,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              _buildGameOption(
                                context,
                                icon: const FaIcon(
                                  FontAwesomeIcons.puzzlePiece,
                                  color: Color(0xFF855353),
                                  size: 24,
                                ),
                                text: 'Puzzle',
                              ),
                              const SizedBox(height: 10),
                              _buildGameOption(
                                context,
                                icon: const FaIcon(
                                  FontAwesomeIcons.robot,
                                  color: Color(0xFF855353),
                                  size: 24,
                                ),
                                text: 'Play with CPU',
                              ),
                              const SizedBox(height: 10),
                              _buildGameOption(
                                context,
                                icon: const Icon(
                                  Icons.people_alt,
                                  color: Color(0xFF855353),
                                  size: 24,
                                ),
                                text: '2 Players',
                                onTap: () {
                                  // Navigate to GameBoard when the card is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GameBoard()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build game options
  Widget _buildGameOption(BuildContext context,
      {required Widget icon, required String text, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 75,
        decoration: BoxDecoration(
          color: const Color(0xFFE7C38E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE58461),
            width: 2,
          ),
        ),
        alignment: AlignmentDirectional.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Readex Pro',
                    color: const Color(0xFF855353),
                    fontSize: 24,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
