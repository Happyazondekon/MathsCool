import '../models/exercise_model.dart';

final Map<String, Map<String, List<Exercise>>> staticExercises = {
  'CI': {
    'Addition': [
      Exercise(question: '1 + 1 = ?', options: ['1', '2', '3'], correctAnswer: 1),
      Exercise(question: '2 + 3 = ?', options: ['4', '5', '6'], correctAnswer: 1),
      Exercise(question: '4 + 0 = ?', options: ['3', '4', '5'], correctAnswer: 1),
      Exercise(question: '5 + 1 = ?', options: ['5', '6', '7'], correctAnswer: 2),
      Exercise(question: '3 + 2 = ?', options: ['4', '5', '6'], correctAnswer: 1),
    ],
    'Soustraction': [
      Exercise(question: '2 - 1 = ?', options: ['1', '2', '3'], correctAnswer: 0),
      Exercise(question: '5 - 3 = ?', options: ['1', '2', '3'], correctAnswer: 1),
      Exercise(question: '4 - 2 = ?', options: ['1', '2', '3'], correctAnswer: 1),
      Exercise(question: '6 - 1 = ?', options: ['4', '5', '6'], correctAnswer: 1),
      Exercise(question: '3 - 1 = ?', options: ['1', '2', '3'], correctAnswer: 1),
    ],
    'Géométrie': [
      Exercise(question: 'Combien de côtés a un carré ?', options: ['3', '4', '5'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un triangle ?', options: ['3', '4', '5'], correctAnswer: 0),
      Exercise(question: 'Un cercle a combien de côtés ?', options: ['0', '1', '2'], correctAnswer: 0),
      Exercise(question: 'Combien d\'angles droits a un rectangle ?', options: ['2', '3', '4'], correctAnswer: 2),
      Exercise(question: 'Combien de sommets a un carré ?', options: ['3', '4', '5'], correctAnswer: 1),
    ],
  },
  'CP': {
    'Addition': [
      Exercise(question: '10 + 5 = ?', options: ['14', '15', '16'], correctAnswer: 1),
      Exercise(question: '6 + 7 = ?', options: ['12', '13', '14'], correctAnswer: 1),
      Exercise(question: '8 + 3 = ?', options: ['10', '11', '12'], correctAnswer: 1),
      Exercise(question: '9 + 2 = ?', options: ['10', '11', '12'], correctAnswer: 1),
      Exercise(question: '7 + 5 = ?', options: ['11', '12', '13'], correctAnswer: 1),
    ],
    'Multiplication': [
      Exercise(question: '2 x 3 = ?', options: ['5', '6', '7'], correctAnswer: 1),
      Exercise(question: '4 x 2 = ?', options: ['6', '8', '10'], correctAnswer: 1),
      Exercise(question: '5 x 1 = ?', options: ['4', '5', '6'], correctAnswer: 1),
      Exercise(question: '3 x 3 = ?', options: ['6', '9', '12'], correctAnswer: 1),
      Exercise(question: '6 x 2 = ?', options: ['10', '12', '14'], correctAnswer: 1),
    ],
    'Division': [
      Exercise(question: '6 ÷ 2 = ?', options: ['2', '3', '4'], correctAnswer: 1),
      Exercise(question: '8 ÷ 4 = ?', options: ['1', '2', '3'], correctAnswer: 1),
      Exercise(question: '9 ÷ 3 = ?', options: ['2', '3', '4'], correctAnswer: 1),
      Exercise(question: '12 ÷ 6 = ?', options: ['1', '2', '3'], correctAnswer: 1),
      Exercise(question: '10 ÷ 5 = ?', options: ['1', '2', '3'], correctAnswer: 1),
    ],
  },
  'CE1': {
    'Addition': [
      Exercise(question: '15 + 10 = ?', options: ['20', '25', '30'], correctAnswer: 1),
      Exercise(question: '20 + 5 = ?', options: ['24', '25', '26'], correctAnswer: 1),
      Exercise(question: '18 + 12 = ?', options: ['29', '30', '31'], correctAnswer: 1),
      Exercise(question: '25 + 13 = ?', options: ['37', '38', '39'], correctAnswer: 1),
      Exercise(question: '32 + 16 = ?', options: ['47', '48', '49'], correctAnswer: 1),
    ],
    'Soustraction': [
      Exercise(question: '20 - 5 = ?', options: ['14', '15', '16'], correctAnswer: 1),
      Exercise(question: '18 - 7 = ?', options: ['10', '11', '12'], correctAnswer: 1),
      Exercise(question: '25 - 13 = ?', options: ['11', '12', '13'], correctAnswer: 1),
      Exercise(question: '30 - 14 = ?', options: ['15', '16', '17'], correctAnswer: 1),
      Exercise(question: '40 - 20 = ?', options: ['19', '20', '21'], correctAnswer: 1),
    ],
    'Géométrie': [
      Exercise(question: 'Un rectangle a combien de côtés ?', options: ['2', '3', '4'], correctAnswer: 2),
      Exercise(question: 'Combien d\'angles droits a un carré ?', options: ['2', '3', '4'], correctAnswer: 2),
      Exercise(question: 'Un triangle a combien d\'angles ?', options: ['2', '3', '4'], correctAnswer: 1),
      Exercise(question: 'Un hexagone a combien de côtés ?', options: ['5', '6', '7'], correctAnswer: 1),
      Exercise(question: 'Un pentagone a combien de côtés ?', options: ['4', '5', '6'], correctAnswer: 1),
    ],
  },
  // Ajouter d'autres niveaux et thèmes ici
};