import 'package:fruit_app/data/datasources/fruit_remote_data_source.dart';
import 'package:fruit_app/data/models/fruit_model.dart';
import 'package:fruit_app/domain/repositories/fruit_repository.dart';

class FruitRepositoryImpl implements FruitRepository {
  final FruitRemoteDataSource remoteDataSource;

  FruitRepositoryImpl() : remoteDataSource = FruitRemoteDataSource();

  @override
  Future<List<FruitModel>> getAllFruits() async {
    return await remoteDataSource.getAllFruits();
  }
}