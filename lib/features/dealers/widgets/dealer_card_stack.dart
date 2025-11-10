import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import '../../../main.dart';
import '../../../model/cars/dealer/dealer.dart';
import '../../../utils/constants/colors.dart';
import '../../dealer_details/views/dealer_details_page.dart';

class DealerCardStack extends StatefulWidget {
  final List<Dealer> dealers;
  final VoidCallback? onStackEmpty;
  final Function(int index, dynamic info)? onForward;

  const DealerCardStack({
    super.key,
    required this.dealers,
    this.onStackEmpty,
    this.onForward,
  });

  @override
  State<DealerCardStack> createState() => _DealerCardStackState();
}

class _DealerCardStackState extends State<DealerCardStack> {
  late List<Dealer> _remainingDealers;
  final TCardController _tCardController = TCardController();

  @override
  void initState() {
    super.initState();
    _remainingDealers = List<Dealer>.from(widget.dealers);
  }

  @override
  void didUpdateWidget(DealerCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dealers != oldWidget.dealers) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _remainingDealers = List<Dealer>.from(widget.dealers);
          });
          _tCardController.reset();
        }
      });
    }
  }

  void resetStack() {
    if (mounted) {
      setState(() {
        _remainingDealers = List<Dealer>.from(widget.dealers)..shuffle();
      });
    }
    _tCardController.reset();
  }

  @override
  void dispose() {
    _tCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safety check: ensure we have valid data
    if (widget.dealers.isEmpty || _remainingDealers.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCardStack();
  }

  Widget _buildCardStack() {
    // Ensure we have cards to display
    if (_remainingDealers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and subtitle section
        const SizedBox(height: 16),

        TCard(
          controller: _tCardController,
          cards: _remainingDealers.map((dealer) => _buildDealerCard(dealer)).toList(),
          onEnd: () {
            if (mounted) {
              setState(() {
                _remainingDealers.clear();
              });
            }
            widget.onStackEmpty?.call();
          },
          onForward: widget.onForward,
          size: const Size(340, 460),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios_new_outlined,
              color: MyColors.grey600,
              size: 16,
            ),
            Text(
              tr('swipe to explore'),
              style: const TextStyle(
                color: MyColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Transform.flip(
              flipX: true,
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: MyColors.grey600,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(_tCardController.index >= 0 && _tCardController.index < _remainingDealers.length) ? _tCardController.index + 1 : 1}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              ' ${tr('of')} ',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              widget.dealers.length.toString(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDealerCard(Dealer dealer) {
    return Container(
      width: 320,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DealerDetailsPage(dealer: dealer),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primary.withValues(alpha: 0.3),
                        MyColors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: dealer.logo != null ? CachedNetworkImageProvider(dealer.logo!) : null,
                    child: dealer.logo == null
                        ? Icon(
                            Icons.store_outlined,
                            size: 36,
                            color: MyColors.primary,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 10),

                // Name Section
                Text(
                  dealer.storeName ?? 'Unknown Dealer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 20),

                // Contact Information Cards
                Expanded(
                  child: Column(
                    children: [
                      // Phone Card
                      if (dealer.phoneNumber != null && dealer.phoneNumber!.isNotEmpty)
                        _buildInfoCard(
                          icon: Icons.phone_outlined,
                          label: tr('phone'),
                          value: dealer.phoneNumber!,
                          color: Colors.green,
                        ),

                      const SizedBox(height: 8),

                      // Email Card
                      if (dealer.email != null && dealer.email!.isNotEmpty)
                        _buildInfoCard(
                          icon: Icons.email_outlined,
                          label: tr('email'),
                          value: dealer.email!,
                          color: Colors.blue,
                        ),

                      const SizedBox(height: 8),

                      // Address Card
                      if (dealer.address != null && dealer.address!.isNotEmpty)
                        _buildInfoCard(
                          icon: Icons.location_on_outlined,
                          label: tr('address'),
                          value: dealer.address!,
                          color: Colors.orange,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Action Button
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primary,
                        MyColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DealerDetailsPage(dealer: dealer),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              color: MyColors.black,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tr('view details'),
                              style: const TextStyle(
                                color: MyColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for info cards
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: MyColors.primary),
          const SizedBox(height: 20),
          Text(
            tr('you have explored all dealers'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primary,
                  MyColors.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: resetStack,
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr('explore again'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
