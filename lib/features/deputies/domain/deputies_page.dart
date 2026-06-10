import 'package:parlamento_pt/features/deputies/domain/deputy.dart';

/// A paginated page of deputies from the votoaberto list API.
///
/// Response shape: `{ "data": [...], "pagination": { "limit", "offset", "total" } }`
class DeputiesPage {
  const DeputiesPage({
    required this.deputies,
    required this.limit,
    required this.offset,
    required this.total,
  });

  final List<Deputy> deputies;
  final int limit;
  final int offset;
  final int total;

  static const String _fieldData = 'data';
  static const String _fieldPagination = 'pagination';
  static const String _fieldLimit = 'limit';
  static const String _fieldOffset = 'offset';
  static const String _fieldTotal = 'total';

  factory DeputiesPage.fromJson(Map<String, dynamic> json) {
    final data = json[_fieldData] as List<dynamic>;
    final pagination = json[_fieldPagination] as Map<String, dynamic>;

    return DeputiesPage(
      deputies: data
          .map((item) => Deputy.fromJson(item as Map<String, dynamic>))
          .toList(),
      limit: (pagination[_fieldLimit] as num).toInt(),
      offset: (pagination[_fieldOffset] as num).toInt(),
      total: (pagination[_fieldTotal] as num).toInt(),
    );
  }
}
