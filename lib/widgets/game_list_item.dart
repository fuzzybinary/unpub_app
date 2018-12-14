import 'package:flutter/material.dart';
import 'package:unpub/models.dart';

typedef CallbackT<T> = void Function(T);

@immutable
class GameListItem extends StatelessWidget {
  final GameSummary game;
  final CallbackT<GameSummary> onTap;

  const GameListItem({Key key, @required this.game, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap(game),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              game.game,
              style: theme.textTheme.title,
            ),
            Text(
              game.designer,
              style: theme.textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
