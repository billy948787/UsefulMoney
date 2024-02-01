import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/business_logic/services/counting/bloc/couter_cubit.dart';

class Numpad extends StatelessWidget {
  const Numpad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('7');
              },
              child: const Text(
                '7',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('8');
              },
              child: const Text(
                '8',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('9');
              },
              child: const Text(
                '9',
                style: TextStyle(fontSize: 20),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('4');
              },
              child: const Text(
                '4',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('5');
              },
              child: const Text(
                '5',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('6');
              },
              child: const Text(
                '6',
                style: TextStyle(fontSize: 20),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('1');
              },
              child: const Text(
                '1',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('2');
              },
              child: const Text(
                '2',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('3');
              },
              child: const Text(
                '3',
                style: TextStyle(fontSize: 20),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('00');
              },
              child: const Text(
                '00',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: TextButton(
              onPressed: () {
                context.read<CounterCubit>().add('0');
              },
              child: const Text(
                '0',
                style: TextStyle(fontSize: 20),
              ),
            )),
            Expanded(
                child: IconButton(
              onPressed: () {
                context.read<CounterCubit>().clear();
              },
              icon: const Icon(Icons.clear),
            )),
          ],
        ),
      ],
    );
  }
}
