//-----------------------CustomeTextField---------------------------

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.icon,
    required this.text,
    required this.keyboardType,
    required this.obscureText,
  });
  final IconData icon;
  final String text;
  final dynamic keyboardType;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 320,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.amber,
          ),
          hintText: text,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }
}

//--------------Message BOx or Review Box----------------

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(),
          hintMaxLines: 3,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 6,
      ),
    );
  }
}

//----------Small Button for login/singup----------------

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade400,
          foregroundColor: Colors.black,
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

//---------------------Long Button-------------------------

class LongButton extends StatelessWidget {
  const LongButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade300,
          foregroundColor: Colors.black,
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

//---------------Transparant Button Used on Prodile screen------------
class TransLongButton extends StatelessWidget {
  const TransLongButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  final String text;
  final void Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade300,
          foregroundColor: Colors.black,
          side: const BorderSide(
            color: Colors.black,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.amberAccent,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

//-----------Custome List tile----------------
class CustomeListTile extends StatelessWidget {
  const CustomeListTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.review,
  });

  final dynamic image;
  final String title;
  final String subtitle;
  final String review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 340,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                style: BorderStyle.solid,
                color: Colors.grey.shade300,
                width: 1)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 35,
                    foregroundImage: AssetImage(
                      image,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
                left: 20,
              ),
              child: Text(
                review,
                style: const TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
