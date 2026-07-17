import 'package:flutter/material.dart';
import 'dart:io';

class ClassificationResultScreen extends StatefulWidget {
  final String classificationType; // 'weed' or 'plant'
  final Map<String, dynamic> result;
  final String imageFile;

  const ClassificationResultScreen({
    Key? key,
    required this.classificationType,
    required this.result,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<ClassificationResultScreen> createState() =>
      _ClassificationResultScreenState();
}

class _ClassificationResultScreenState
    extends State<ClassificationResultScreen> {
  bool _showMoreInfo = false;

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.classificationType == 'weed' ? 'Weed Classified' : 'Crop Analyzed';
    final String itemName = widget.result['name'] ?? 'Unknown';
    final String description =
        widget.result['description'] ?? 'No description available';
    final double confidence = (widget.result['confidence'] ?? 0.0) as double;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BBF59),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Image
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF6BBF59),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Image Display
                  if (widget.imageFile != null)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.imageFile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Confidence Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}% Confidence',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Result Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.classificationType == 'weed'
                              ? 'Weed Identified'
                              : 'Crop Detected',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          itemName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Database Photo Display
                  if (widget.result['photo'] != null && 
                      widget.result['photo'].toString().isNotEmpty)
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(16),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.08),
                    //         blurRadius: 12,
                    //         offset: const Offset(0, 4),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'Reference Image',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600,
                    //           color: Colors.black87,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 12),
                    //       ClipRRect(
                    //         borderRadius: BorderRadius.circular(12),
                    //         child: Image.network(
                    //           widget.result['photo'] as String,
                    //           width: double.infinity,
                    //           height: 200,
                    //           fit: BoxFit.cover,
                    //           errorBuilder: (context, error, stackTrace) {
                    //             return Container(
                    //               width: double.infinity,
                    //               height: 200,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.grey[200],
                    //                 borderRadius: BorderRadius.circular(12),
                    //               ),
                    //               child: const Center(
                    //                 child: Icon(
                    //                   Icons.image_not_supported,
                    //                   size: 48,
                    //                   color: Colors.grey,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           loadingBuilder: (context, child, loadingProgress) {
                    //             if (loadingProgress == null) return child;
                    //             return Container(
                    //               width: double.infinity,
                    //               height: 200,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.grey[200],
                    //                 borderRadius: BorderRadius.circular(12),
                    //               ),
                    //               child: const Center(
                    //                 child: CircularProgressIndicator(),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  const SizedBox(height: 16),
                  // Detailed Info Sections
                  if (widget.result['characteristics'] != null)
                    _buildInfoSection(
                      title: 'Characteristics',
                      content: widget.result['characteristics'] as String,
                    ),
                  if (widget.result['morphology'] != null)
                    _buildInfoSection(
                      title: 'Morphology',
                      content: widget.result['morphology'] as String,
                    ),
                  if (widget.result['habitat'] != null)
                    _buildInfoSection(
                      title: 'Habitat',
                      content: widget.result['habitat'] as String,
                    ),
                  // Disease/Treatment Info
                  if (widget.classificationType == 'plant' &&
                      widget.result['disease'] != null)
                    _buildWarningSection(
                      title: 'Disease Detected',
                      content: widget.result['disease'] as String,
                      isWarning: true,
                    ),
                  if (widget.result['treatment'] != null)
                    _buildInfoSection(
                      title: 'Recommended Treatment',
                      content: widget.result['treatment'] as String,
                    ),
                  if (widget.result['control_methods'] != null)
                    _buildInfoSection(
                      title: 'Control Methods',
                      content: widget.result['control_methods'] as String,
                    ),
                  const SizedBox(height: 16),
                  // Herbicide/Pesticide Recommendations
                  if (widget.result['herbicides'] != null ||
                      widget.result['pesticides'] != null)
                    _buildRecommendationsSection(
                      herbicides: widget.result['herbicides'],
                      pesticides: widget.result['pesticides'],
                    ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF6BBF59),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6BBF59),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Share result functionality
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text('Result shared!'),
                      //           duration: Duration(seconds: 2),
                      //         ),
                      //       );
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: const Color(0xFF6BBF59),
                      //       padding: const EdgeInsets.symmetric(vertical: 14),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //     ),
                      //     child: const Text(
                      //       'Share',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w600,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection({
    required String title,
    required String content,
    bool isWarning = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.red.withOpacity(0.05)
            : const Color(0xFF6BBF59).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning
              ? Colors.red.withOpacity(0.2)
              : const Color(0xFF6BBF59).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isWarning ? Icons.warning : Icons.info,
                color: isWarning ? Colors.red[700] : const Color(0xFF6BBF59),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isWarning ? Colors.red[700] : const Color(0xFF6BBF59),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection({
    dynamic herbicides,
    dynamic pesticides,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_pharmacy,
                color: Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recommended Products',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (herbicides != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Herbicides:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  herbicides.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          if (pesticides != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesticides:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pesticides.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
