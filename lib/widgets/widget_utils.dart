import 'package:collegeadmissionhelper/models/university.dart';
import 'package:flutter/material.dart';

import '../models/major.dart';

Widget buildTextField(
  TextEditingController controller,
  String label, {
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    ),
  );
}

Widget buildMajorCard({required Major major}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.book, color: Colors.white),
      ),
      title: Text(
        major.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Skill: ${major.relatedSkills ?? "None"}",
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              "Description: ${major.description ?? "None"}",
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildUniversityCard({
  required University university,
  required VoidCallback onTap,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.transparent,
                BlendMode.overlay,
              ),
              child: Image.network(
                university.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 40,
                  );
                },
              ),
            ),
          )),
      title: Text(
        university.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "University Code: ${university.universityCode}",
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              "Location: ${university.location}",
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      onTap: onTap,
    ),
  );
}
