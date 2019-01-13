import 'package:unpub/models.dart';
import 'package:unpub/unpub_service.dart';

enum DiscreetAnswer { Yes, No, Maybe }

class FeedbackScreenBloc {
  GameSummary selectedGame;

  String players;
  String gameTime;
  String firstPlaceScore;
  String lastPlaceStore;

  bool didWin;
  double gameLength;
  double easeOfLearning;
  double playerDownTime;
  double gameDecisions;
  double interactivity;
  double originality;
  double fun;

  DiscreetAnswer endPredictable;
  String predictableWhy;
  DiscreetAnswer playAgain;
  DiscreetAnswer buy;

  String oneChange;
  String favoritePart;
  String additionalComments;

  FeedbackScreenBloc({this.selectedGame}) {
    reset();
  }

  void reset() {
    selectedGame = null;
    players = '';
    gameTime = '';
    firstPlaceScore = '';
    lastPlaceStore = '';
    didWin = true;
    gameLength = 3;
    easeOfLearning = 3;
    playerDownTime = 3;
    gameDecisions = 3;
    interactivity = 3;
    originality = 3;
    fun = 3;
    endPredictable = DiscreetAnswer.Yes;
    predictableWhy = '';
    playAgain = DiscreetAnswer.Yes;
    buy = DiscreetAnswer.Yes;

    oneChange = '';
    favoritePart = '';
    additionalComments = '';
  }

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
      'interactive': interactivity.toStringAsFixed(0),
      'original': originality.toStringAsFixed(0),
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
        return '1';
      case DiscreetAnswer.Maybe:
        return '2';
      case DiscreetAnswer.No:
        return '3';
    }
    return '1';
  }
}
