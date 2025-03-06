import 'package:agex_client/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AgexLanding extends StatelessWidget {
  const AgexLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavigationBar(),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  FirstHero(),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          "AI assistant, at your service",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SecondHero(),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          "Network health",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  NetworkStatusSection(),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          "Featured questions",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FeaturedQuestions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      child: Row(
        children: [
          Text(
            "Agex",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          RoundedTextField(width: 300, showSubmitButton: true),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class FeaturedQuestions extends StatelessWidget {
  const FeaturedQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomListTile(
          title: "What is the average block time?",
          subtitle: "The average block time is 10 seconds",
        ),
        CustomListTile(
          title: "What is the TPS of the network?",
          subtitle: "The average transactions per second on the network is 100",
        )
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff293038),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.star_outline_rounded),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff9cabba),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkStatusSection extends StatelessWidget {
  const NetworkStatusSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NetworkStatusTile(
              title: "Block height",
              value: 12345,
              change: 1.23,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: NetworkStatusTile(
              title: "Active addresses",
              value: 54321,
              change: 4.56,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: NetworkStatusTile(
              title: "Transactions last 24h",
              value: 6789,
              change: 7.89,
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkStatusTile extends StatelessWidget {
  const NetworkStatusTile({
    required this.title,
    required this.value,
    required this.change,
    super.key,
  });

  final String title;
  final double value;
  final double change;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blueGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 5),
          Text(
            change.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 16, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class SecondHero extends StatelessWidget {
  const SecondHero({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textsPart = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Agex AI Assistant",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Color(0xff9cabba),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ask Agex anything about the blockchain",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Agex is an Al assistant that can help you explore the blockchain. You can ask Agex questions about transactions, addresses, or blocks. Agex will give you the most relevant information and help you understand what's happening on the blockchain.",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Color(0xff9cabba),
          ),
        ),
      ],
    );

    var width = MediaQuery.of(context).size.width;

    if (width <= 800) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/hero2.png",
              width: width * 0.8,
            ),
          ),
          SizedBox(height: 20),
          textsPart,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: textsPart),
        SizedBox(
          width: 40,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/images/hero2.png",
            width: 300,
          ),
        ),
      ],
    );
  }
}

class FirstHero extends StatelessWidget {
  const FirstHero({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print(width);

    var heroTexts = Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "An AI-powered blockchain explorer",
          // softWrap: false,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Agex is the next generation of blockchain explorers. It's built on advanced Al models and provides a unique way to interact with blockchain data.",
          // softWrap: false,
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(width: width * 0.8, showSubmitButton: true),
      ],
    );

    if (width <= 800) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/hero1.png",
              width: width * 0.8,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          heroTexts,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/hero1.png",
              // width: 400,
            ),
          ),
        ),
        SizedBox(
          width: 40,
        ),
        SizedBox(width: 360, child: heroTexts),
      ],
    );
  }
}
