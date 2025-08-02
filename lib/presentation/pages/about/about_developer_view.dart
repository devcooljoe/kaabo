/*
 * Kaabo - Enterprise Property Rental Platform
 * Copyright (c) 2025 Joseph Onipede (onipedejoseph2018@gmail.com)
 * 
 * Developer: Joseph Onipede
 * Email: onipedejoseph2018@gmail.com
 */

import 'package:flutter/material.dart';
import '../../../core/constants/developer_info.dart';

/// About Developer Page - DO NOT REMOVE
class AboutDeveloperView extends StatelessWidget {
  const AboutDeveloperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Developer'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),

            Text(
              DeveloperInfo.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Software Engineer & Mobile App Developer',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Project Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(DeveloperInfo.projectName),
                    const SizedBox(height: 8),
                    Text(DeveloperInfo.copyright),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.green),
                      title: Text(DeveloperInfo.email),
                    ),

                    const ListTile(
                      leading: Icon(Icons.work, color: Colors.blue),
                      title: Text('LinkedIn Profile'),
                      subtitle: Text('Professional Network'),
                    ),

                    const ListTile(
                      leading: Icon(Icons.code, color: Colors.black),
                      title: Text('GitHub Profile'),
                      subtitle: Text('Source Code & Projects'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Copyright Notice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This software is protected by copyright law. Unauthorized copying, modification, distribution, or use is strictly prohibited without explicit written permission from Joseph Onipede.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
