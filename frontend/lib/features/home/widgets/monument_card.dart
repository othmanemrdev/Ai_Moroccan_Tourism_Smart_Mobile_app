import 'package:flutter/material.dart';

class MonumentCard extends StatelessWidget {
  final String name;
  final String city;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final double? width; // Make width optional for flexible sizing
  final EdgeInsetsGeometry? margin; // Make margin optional for grid use
  final double? imageHeight; // Make image height configurable
  final EdgeInsetsGeometry? contentPadding; // Make content padding configurable

  const MonumentCard({
    super.key,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    this.width, // Optional width parameter
    this.margin, // Optional margin parameter
    this.imageHeight, // Optional image height
    this.contentPadding, // Optional content padding
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width, // Use provided width, null means expand to fill
        margin:
            margin ??
            const EdgeInsets.only(
              right: 16,
              bottom: 10,
              top: 5,
            ), // Use provided margin or default
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageHeight != null) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: imageHeight,
                        width: width, // Use provided width, null means expand
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          onFavoriteTap();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFFC1272D),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: SizedBox.expand(
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            onFavoriteTap();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFFC1272D),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: contentPadding ?? const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF006233),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            city,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
