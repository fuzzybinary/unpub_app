import 'package:unpub/models.dart';

enum DiscreetAnswer { Yes, No, Maybe }

class FeedbackScreenBloc {
  GameSummary selectedGame;

  bool didWin = true;
  double gameLength = 3;
  double easeOfLearning = 3;
  double playerDownTime = 3;
  double gameDecisions = 3;
  double interactivity = 3;
  double originality = 3;
  double fun = 3;

  DiscreetAnswer endPredictable = DiscreetAnswer.Yes;
  String predictableWhy;
  DiscreetAnswer playAgain = DiscreetAnswer.Yes;
  DiscreetAnswer buy = DiscreetAnswer.Yes;

  String oneChange;
  String favoritePart;
  String additionalComments;

  Future<void> submitFeedback() async {}
}
