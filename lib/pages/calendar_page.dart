import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sobrius_app/models/relapse_model.dart';
import 'package:sobrius_app/viewmodels/relapse_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // O controlador para o TableCalendar
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<RelapseModel> _selectedEvents = [];

  // Método para obter os eventos (recaídas) para um dia específico.
  // Ele filtra a lista de recaídas do ViewModel.
  List<RelapseModel> _getEventsForDay(DateTime day, List<RelapseModel> allRelapses) {
    return allRelapses.where((relapse) {
      return isSameDay(relapse.relapseDate, day);
    }).toList();
  }

  // Lógica para quando um dia é selecionado no calendário
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay, RelapseViewModel viewModel) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // Atualiza a lista de eventos para o dia selecionado
        _selectedEvents = _getEventsForDay(selectedDay, viewModel.relapses);
      });
    }
  }

  // Método para exibir uma notificação de sucesso ou erro
  void _showSnackbar(BuildContext context, String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Recaídas'),
      ),
      body: Consumer<RelapseViewModel>(
        builder: (context, viewModel, child) {
          // Exibe o indicador de carregamento enquanto os dados estão sendo buscados
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Exibe mensagem de erro se houver
          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackbar(context, viewModel.errorMessage!, isSuccess: false);
              // Limpa a mensagem de erro para que ela não reapareça
              viewModel.dispose();
            });
          }

          // Exibe mensagem de sucesso se houver
          if (viewModel.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackbar(context, viewModel.successMessage!);
              // Limpa a mensagem de sucesso
              viewModel.dispose();
            });
          }

          // Retorna a interface do usuário principal após o carregamento
          return SingleChildScrollView(
            child: Column(
              children: [
                // Calendário
                TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: (day) => _getEventsForDay(day, viewModel.relapses),
                  onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay, viewModel),
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  locale: 'pt_BR', // Defina o idioma para o calendário
                  // Estilização do calendário
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Divider(),
                // Lista de recaídas para o dia selecionado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedDay != null
                            ? 'Recaídas em ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}'
                            : 'Selecione uma data para ver as recaídas.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      // Exibe a lista de recaídas do dia selecionado
                      ..._selectedEvents.map((event) {
                        return ListTile(
                          title: Text('Recaída em: ${DateFormat('HH:mm').format(event.relapseDate)}'),
                          subtitle: Text('ID da Recaída: ${event.id}'),
                          trailing: const Icon(Icons.healing, color: Colors.blue),
                        );
                      }),
                      if (_selectedEvents.isEmpty && _selectedDay != null)
                        const Center(child: Text('Nenhuma recaída registrada para esta data.')),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // Botão para adicionar uma nova recaída
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final viewModel = Provider.of<RelapseViewModel>(context, listen: false);
          // Salva uma nova recaída na data e hora atuais
          await viewModel.saveRelapse(DateTime.now());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
