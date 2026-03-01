import 'package:flutter_google_maps_webservices/places.dart';

import '../../../../../core/constants/app_values.dart';

class PlacesService {
 final String apiKey = AppValues.googleMapsApiKey;
  GoogleMapsPlaces get _places => GoogleMapsPlaces(apiKey: apiKey);

  Future<List<Prediction>> search(String input) async {
    final response = await _places.autocomplete(
      input,
      language: "ar",
      components: [Component(Component.country, "eg")],
    );

    return response.predictions;
  }

  Future<PlacesDetailsResponse> getDetails(String placeId) async {
    return await _places.getDetailsByPlaceId(placeId);
  }
}
