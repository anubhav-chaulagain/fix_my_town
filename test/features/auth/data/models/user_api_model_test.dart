import 'package:fix_my_town/features/auth/data/models/user_api_model.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("JSON to Api Model Conversion", () {
    test("Convert to Api Model From JSON", () {
      Map<String, dynamic> json = {
        "fullname": "Anubhav Chaulagain",
        "email": "anubhav.chaulagain@example.com",
      };

      final expectedModel = UserApiModel(
        fullName: "Anubhav Chaulagain",
        email: "anubhav.chaulagain@example.com",
      );

      final actualApiModel = UserApiModel.fromJson(json);
      expect(actualApiModel.email, expectedModel.email);
      expect(actualApiModel.fullName, expectedModel.fullName);
    });

    test("Convert to JSON From Api Model", () {
      final apiModel = UserApiModel(
        fullName: "Anubhav Chaulagain",
        email: "anubhav.chaulagain@example.com",
      );

      Map<String, dynamic> expectedJson = {
        "fullname": "Anubhav Chaulagain",
        "email": "anubhav.chaulagain@example.com",
      };

      Map<String, dynamic> actualJson = apiModel.toJson();
      expect(actualJson["fullname"], expectedJson["fullname"]);
      expect(actualJson["email"], expectedJson["email"]);
    });

    test("Convert to Auth entity from Api Model", () {
      final apiModel = UserApiModel(
        fullName: "Anubhav Chaulagain",
        email: "anubhav.chaulagain@example.com",
      );

      UserEntity expectedEntity = UserEntity(
        fullName: "Anubhav Chaulagain",
        email: "anubhav.chaulagain@example.com",
      );

      UserEntity actualEntity = apiModel.toEntity();
      expect(actualEntity, expectedEntity);
    });
  });
}
