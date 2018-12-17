import 'package:unpub/models.dart';
import 'package:unpub/unpub_service.dart';

enum DiscreetAnswer { Yes, No, Maybe }

class FeedbackScreenBloc {
  FeedbackScreenBloc(this.selectedGame);

  GameSummary selectedGame;

  String players = '';
  String gameTime = '';
  String firstPlaceScore = '';
  String lastPlaceStore = '';

  bool didWin = true;
  double gameLength = 3;
  double easeOfLearning = 3;
  double playerDownTime = 3;
  double gameDecisions = 3;
  double interactivity = 3;
  double originality = 3;
  double fun = 3;

  DiscreetAnswer endPredictable = DiscreetAnswer.Yes;
  String predictableWhy = '';
  DiscreetAnswer playAgain = DiscreetAnswer.Yes;
  DiscreetAnswer buy = DiscreetAnswer.Yes;

  String oneChange = '';
  String favoritePart = '';
  String additionalComments = '';

  Future<bool> submitFeedback() async {
    // TODO: This should be a model handed off to the UnpubService but serialize here for now
    final fields = {
      'game': selectedGame.id.toString(),
      'winner': didWin ? '1' : '0',
      'players': players,
      'gtime': gameTime,
      'wscore': firstPlaceScore,
      'lscore': lastPlaceStore,
      'length': gameLength.toStringAsFixed(0),
      'learn': easeOfLearning.toStringAsFixed(0),
      'downtime': playerDownTime.toStringAsFixed(0),
      'decision': gameDecisions.toStringAsFixed(0),
      'interactive': gameDecisions.toStringAsFixed(0),
      'original': gameDecisions.toStringAsFixed(0),
      'fun': fun.toStringAsFixed(0),
      'predict': _serializeDiscreetAnswer(endPredictable),
      'predicty': predictableWhy,
      'again': _serializeDiscreetAnswer(playAgain),
      'purchase': _serializeDiscreetAnswer(buy),
      'change': oneChange,
      'favorite': favoritePart,
      'comments': additionalComments
    };

    return await UnpubService().submitFeedback(fields);
  }

  String _serializeDiscreetAnswer(DiscreetAnswer answer) {
    switch (answer) {
      case DiscreetAnswer.Yes:
        return '3';
      case DiscreetAnswer.Maybe:
        return '2';
      case DiscreetAnswer.No:
        return '1';
    }
    return '1';
  }
}
