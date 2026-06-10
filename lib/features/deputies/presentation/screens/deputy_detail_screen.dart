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

class _DeputyDetailScreenState extends State<DeputyDetailScreen> {
  late Future<Deputy> _deputyFuture;
  final List<Iniciativa> _iniciativas = [];
  int _iniciativasTotal = 0;
  bool _loadingIniciativas = true;
  bool _loadingMoreIniciativas = false;
  String? _iniciativasError;

  DeputiesRepository get _repository =>
      widget.repository ?? DeputiesRepository();

  @override
  void initState() {
    super.initState();
    _loadDeputy();
    _loadIniciativas(fromStart: true);
  }

  void _loadDeputy() {
    setState(() {
      _deputyFuture = _repository.fetchDeputy(widget.depCadId);
    });
  }

  Future<void> _loadIniciativas({required bool fromStart}) async {
    if (fromStart) {
      setState(() {
        _loadingIniciativas = true;
        _iniciativasError = null;
        _iniciativas.clear();
        _iniciativasTotal = 0;
      });
    } else {
      if (_loadingMoreIniciativas ||
          _iniciativas.length >= _iniciativasTotal) {
        return;
      }
      setState(() => _loadingMoreIniciativas = true);
    }

    try {
      final page = await _repository.fetchIniciativasPage(
        widget.depCadId,
        offset: fromStart ? 0 : _iniciativas.length,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _iniciativas.addAll(page.iniciativas);
        _iniciativasTotal = page.total;
        _loadingIniciativas = false;
        _loadingMoreIniciativas = false;
        _iniciativasError = null;
      });
    } on DeputiesRepositoryException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _iniciativasError = error.message;
        _loadingIniciativas = false;
        _loadingMoreIniciativas = false;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _iniciativasError = 'Ocorreu um erro ao carregar as iniciativas.';
        _loadingIniciativas = false;
        _loadingMoreIniciativas = false;
      });
    }
  }

  bool get _hasMoreIniciativas => _iniciativas.length < _iniciativasTotal;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Deputy>(
      future: _deputyFuture,
      builder: (context, snapshot) {
        final deputy = snapshot.data;
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

  Widget _buildBody(BuildContext context, AsyncSnapshot<Deputy> snapshot) {
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
                onPressed: _loadDeputy,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final deputy = snapshot.data!;
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
                    partyName: deputy.partidoAtual,
                    color: PartyColors.forParty(deputy.partidoAtual),
                  ),
                  if (deputy.circuloAtual != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Círculo: ${deputy.circuloAtual}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (deputy.nomeCompleto != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      deputy.nomeCompleto!,
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
              _iniciativasTotal > 0
                  ? 'Iniciativas (${_iniciativas.length} de $_iniciativasTotal)'
                  : 'Iniciativas',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (_loadingIniciativas)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_iniciativasError != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Text(_iniciativasError!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _loadIniciativas(fromStart: true),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          )
        else if (_iniciativas.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(child: Text('Sem iniciativas registadas')),
            ),
          )
        else ...[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return IniciativaCard(iniciativa: _iniciativas[index]);
              },
              childCount: _iniciativas.length,
            ),
          ),
          if (_hasMoreIniciativas)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: _loadingMoreIniciativas
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton.tonal(
                        onPressed: () => _loadIniciativas(fromStart: false),
                        child: const Text('Carregar mais'),
                      ),
              ),
            )
          else
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ],
    );
  }
}
