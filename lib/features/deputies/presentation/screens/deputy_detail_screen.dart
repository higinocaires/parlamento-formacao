import 'package:flutter/material.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativa.dart';
import 'package:parlamento_pt/features/deputies/presentation/utils/party_colors.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/iniciativa_card.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/party_badge.dart';

class DeputyDetailScreen extends StatefulWidget {
  const DeputyDetailScreen({
    required this.depCadId,
    this.repository,
    super.key,
  });

  final int depCadId;
  final DeputiesRepository? repository;

  @override
  State<DeputyDetailScreen> createState() => _DeputyDetailScreenState();
}

class _DeputyDetailData {
  const _DeputyDetailData({
    required this.deputy,
    required this.iniciativas,
  });

  final Deputy deputy;
  final List<Iniciativa> iniciativas;
}

class _DeputyDetailScreenState extends State<DeputyDetailScreen> {
  late Future<_DeputyDetailData> _detailFuture;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() {
    final repository = widget.repository ?? DeputiesRepository();
    setState(() {
      _detailFuture = _fetchDetail(repository);
    });
  }

  Future<_DeputyDetailData> _fetchDetail(DeputiesRepository repository) async {
    final results = await Future.wait([
      repository.fetchDeputy(widget.depCadId),
      repository.fetchIniciativas(widget.depCadId),
    ]);
    return _DeputyDetailData(
      deputy: results[0] as Deputy,
      iniciativas: results[1] as List<Iniciativa>,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DeputyDetailData>(
      future: _detailFuture,
      builder: (context, snapshot) {
        final deputy = snapshot.data?.deputy;
        final title = deputy?.nomeParlamentar ?? 'Deputado';

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<_DeputyDetailData> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      final message = snapshot.error is DeputiesRepositoryException
          ? (snapshot.error! as DeputiesRepositoryException).message
          : 'Ocorreu um erro ao carregar o deputado.';

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadDetail,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final data = snapshot.data!;
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PartyBadge(
                    partyName: data.deputy.partidoAtual,
                    color: PartyColors.forParty(data.deputy.partidoAtual),
                  ),
                  if (data.deputy.circuloAtual != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Círculo: ${data.deputy.circuloAtual}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (data.deputy.nomeCompleto != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      data.deputy.nomeCompleto!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Iniciativas',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (data.iniciativas.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(child: Text('Sem iniciativas registadas')),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return IniciativaCard(iniciativa: data.iniciativas[index]);
              },
              childCount: data.iniciativas.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }
}
