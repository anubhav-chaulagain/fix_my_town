import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Entity to Hive Model Conversion", () {
    test("Convert to Hive Model From Entity", () {
      final authEntity = UserEntity(
        fullName: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );
      UserHiveModel expectedModel = UserHiveModel(
        fullname: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );
      UserHiveModel actualModel = UserHiveModel.fromEntity(authEntity);

      expect(actualModel.email, expectedModel.email);
      expect(actualModel.fullname, expectedModel.fullname);
    });

    test("Convert to Entity From Hive Model", () {
      final model = UserHiveModel(
        fullname: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );

      UserEntity expectedEntity = UserEntity(
        fullName: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );

      UserEntity actualEntity = model.toEntity();

      expect(actualEntity.email, expectedEntity.email);
      expect(actualEntity.fullName, expectedEntity.fullName);
    });
  });
}
