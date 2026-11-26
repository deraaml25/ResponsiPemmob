import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/view_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/location_model.dart';
import '../../viewmodels/favorite_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../widgets/city_weather_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_icon_button.dart';

/// Layar Pencarian Lokasi & Daftar Favorit dengan Kartu Cuaca Berwarna (Gaya Referensi)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Refresh data cuaca kartu favorit saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteViewModel>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLocationSelected(BuildContext context, LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();
    final favoriteVM = context.watch<FavoriteViewModel>();

    return Scaffold(
      backgroundColor: AppColors.warmSand,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GlassIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Kembali',
            iconColor: AppColors.deepNavy,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Cari Lokasi',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.deepNavy,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                // Kolom Pencarian Bergaya Kaca dengan Debounce 500 ms
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: GlassCard(
                    borderRadius: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepNavy,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Cari kota (misal: Purwokerto, Jakarta)...',
                        hintStyle: TextStyle(
                          color: AppColors.deepNavy.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.deepNavy,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.deepNavy,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  searchVM.clearSearch();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) {
                        searchVM.onQueryChanged(val);
                        setState(() {});
                      },
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          searchVM.searchCity(val.trim());
                        }
                      },
                    ),
                  ),
                ),

                // Konten: Hasil Pencarian Geocoding ATAU Daftar Kartu Favorit Berwarna
                Expanded(
                  child: _buildBodyContent(context, searchVM, favoriteVM),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    SearchViewModel searchVM,
    FavoriteViewModel favoriteVM,
  ) {
    final query = _searchController.text.trim();

    // Jika kolom pencarian aktif atau sedang ada proses pencarian
    if (query.isNotEmpty || searchVM.state != ViewState.initial) {
      switch (searchVM.state) {
        case ViewState.loading:
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepNavy),
                ),
                SizedBox(height: 16),
                Text(
                  'Mencari data lokasi...',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepNavy,
                  ),
                ),
              ],
            ),
          );

        case ViewState.error:
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 52, color: Colors.redAccent),
                  const SizedBox(height: 14),
                  Text(
                    searchVM.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: AppColors.deepNavy),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => searchVM.searchCity(query),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );

        case ViewState.empty:
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    size: 56,
                    color: AppColors.deepNavy.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Kota tidak ditemukan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Periksa kembali ejaan nama kota yang Anda masukkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.deepNavy.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );

        case ViewState.success:
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: searchVM.searchResults.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final loc = searchVM.searchResults[index];
              final isFav = favoriteVM.isFavorite(loc.id);

              // Menggunakan InkWell di dalam Material(color: Colors.transparent)
              // untuk mencegah exception runtime DecoratedBox vs ListTile di Flutter
              return GlassCard(
                borderRadius: 20,
                padding: EdgeInsets.zero,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _onLocationSelected(context, loc),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.oceanGlass.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.location_city_rounded,
                              color: AppColors.deepNavy,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  loc.locationSubtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepNavy.withValues(alpha: 0.75),
                                  ),
                                ),
                                Text(
                                  'Lat: ${loc.latitude.toStringAsFixed(2)}, Lon: ${loc.longitude.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.deepNavy.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFav ? const Color(0xFFE53935) : AppColors.deepNavy,
                            ),
                            onPressed: () => favoriteVM.toggleFavorite(loc),
                            tooltip: isFav ? 'Hapus dari favorit' : 'Simpan ke favorit',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

        case ViewState.initial:
          break;
      }
    }

    // Default: Tampilkan Lokasi Favorit sebagai Kartu Berwarna per Kondisi Cuaca
    return _buildFavoritesSection(context, favoriteVM);
  }

  Widget _buildFavoritesSection(
    BuildContext context,
    FavoriteViewModel favoriteVM,
  ) {
    final favorites = favoriteVM.favoriteWeathers;

    if (favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.oceanGlass.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_outline_rounded,
                  size: 48,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Belum Ada Lokasi Favorit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cari nama kota lalu simpan sebagai favorit untuk akses cepat kondisi cuaca.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.deepNavy.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lokasi Favorit (${favorites.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepNavy,
                ),
              ),
              Text(
                'Geser kartu untuk menghapus',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepNavy.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;

              if (isWide) {
                // Tampilan 2 Kolom untuk Layar Lebar / Tablet
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 104,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return CityWeatherCard(
                      item: item,
                      onTap: () => _onLocationSelected(context, item.location),
                      onDelete: () => favoriteVM.removeFavorite(item.location.id),
                      onRetry: () => favoriteVM.retryFavoriteWeather(item.location.id),
                    );
                  },
                );
              }

              // Tampilan 1 Kolom untuk Layar Mobile
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return CityWeatherCard(
                    item: item,
                    onTap: () => _onLocationSelected(context, item.location),
                    onDelete: () => favoriteVM.removeFavorite(item.location.id),
                    onRetry: () => favoriteVM.retryFavoriteWeather(item.location.id),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
