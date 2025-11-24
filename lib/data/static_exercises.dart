import '../models/exercise_model.dart';

final Map<String, Map<String, List<Exercise>>> staticExercises = {
  'CI': {
    'Addition': [
      Exercise(question: '1 + 1 = ?', options: ['2', '1', '3', '0'], correctAnswer: 0),
      Exercise(question: '2 + 3 = ?', options: ['4', '5', '6', '3'], correctAnswer: 1),
      Exercise(question: '4 + 0 = ?', options: ['5', '3', '4', '2'], correctAnswer: 2),
      Exercise(question: '5 + 1 = ?', options: ['7', '8', '6', '5'], correctAnswer: 2),
      Exercise(question: '3 + 2 = ?', options: ['5', '6', '7', '4'], correctAnswer: 0),
      Exercise(question: '0 + 4 = ?', options: ['1', '6', '5', '4'], correctAnswer: 3),
      Exercise(question: '2 + 2 = ?', options: ['5', '2', '4', '3'], correctAnswer: 2),
      Exercise(question: '1 + 3 = ?', options: ['4', '2', '1', '5'], correctAnswer: 0),
      Exercise(question: '0 + 0 = ?', options: ['0', '1', '2', '3'], correctAnswer: 0),
      Exercise(question: '2 + 1 = ?', options: ['4', '3', '2', '1'], correctAnswer: 1),
      // Nouveaux exercices d'Addition (11 à 20)
      Exercise(question: '3 + 3 = ?', options: ['5', '6', '7', '4'], correctAnswer: 1),
      Exercise(question: '1 + 4 = ?', options: ['4', '6', '5', '3'], correctAnswer: 2),
      Exercise(question: '0 + 5 = ?', options: ['0', '6', '4', '5'], correctAnswer: 3),
      Exercise(question: '2 + 4 = ?', options: ['5', '7', '6', '4'], correctAnswer: 2),
      Exercise(question: '5 + 0 = ?', options: ['6', '5', '4', '3'], correctAnswer: 1),
      Exercise(question: '1 + 0 = ?', options: ['0', '2', '1', '3'], correctAnswer: 2),
      Exercise(question: '4 + 1 = ?', options: ['6', '5', '3', '4'], correctAnswer: 1),
      Exercise(question: '0 + 3 = ?', options: ['1', '3', '2', '4'], correctAnswer: 1),
      Exercise(question: '3 + 1 = ?', options: ['4', '3', '5', '6'], correctAnswer: 0),
      Exercise(question: '1 + 5 = ?', options: ['5', '7', '6', '4'], correctAnswer: 2),
    ],
    'Soustraction': [
      Exercise(question: '2 - 1 = ?', options: ['1', '2', '0', '3'], correctAnswer: 0),
      Exercise(question: '5 - 3 = ?', options: ['1', '0', '3', '2'], correctAnswer: 3),
      Exercise(question: '4 - 2 = ?', options: ['3', '1', '2', '0'], correctAnswer: 2),
      Exercise(question: '6 - 1 = ?', options: ['6', '5', '4', '3'], correctAnswer: 1),
      Exercise(question: '3 - 1 = ?', options: ['2', '3', '1', '0'], correctAnswer: 0),
      Exercise(question: '5 - 0 = ?', options: ['4', '5', '0', '3'], correctAnswer: 1),
      Exercise(question: '4 - 3 = ?', options: ['2', '1', '0', '3'], correctAnswer: 1),
      Exercise(question: '3 - 3 = ?', options: ['1', '2', '3', '0'], correctAnswer: 3),
      Exercise(question: '2 - 0 = ?', options: ['2', '0', '1', '3'], correctAnswer: 0),
      Exercise(question: '1 - 1 = ?', options: ['2', '3', '1', '0'], correctAnswer: 3),
      // Nouveaux exercices de Soustraction (11 à 20)
      Exercise(question: '6 - 2 = ?', options: ['3', '5', '4', '2'], correctAnswer: 2),
      Exercise(question: '5 - 2 = ?', options: ['4', '2', '3', '1'], correctAnswer: 2),
      Exercise(question: '4 - 0 = ?', options: ['5', '3', '4', '0'], correctAnswer: 2),
      Exercise(question: '6 - 3 = ?', options: ['2', '4', '3', '1'], correctAnswer: 2),
      Exercise(question: '3 - 0 = ?', options: ['4', '2', '3', '1'], correctAnswer: 2),
      Exercise(question: '5 - 4 = ?', options: ['0', '2', '1', '3'], correctAnswer: 2),
      Exercise(question: '6 - 0 = ?', options: ['6', '5', '4', '3'], correctAnswer: 0),
      Exercise(question: '4 - 1 = ?', options: ['2', '4', '3', '1'], correctAnswer: 2),
      Exercise(question: '6 - 5 = ?', options: ['2', '1', '0', '3'], correctAnswer: 1),
      Exercise(question: '5 - 5 = ?', options: ['1', '0', '2', '5'], correctAnswer: 1),
    ],
    'Multiplication': [],
    'Division': [],
    'Géométrie': [],
  },
  'CP': {
    'Addition': [
      Exercise(question: '10 + 5 = ?', options: ['15', '14', '13', '16'], correctAnswer: 0),
      Exercise(question: '8 + 4 = ?', options: ['13', '14', '12', '11'], correctAnswer: 2),
      Exercise(question: '6 + 3 = ?', options: ['8', '9', '7', '10'], correctAnswer: 1),
      Exercise(question: '7 + 2 = ?', options: ['9', '8', '10', '7'], correctAnswer: 0),
      Exercise(question: '5 + 4 = ?', options: ['10', '9', '8', '11'], correctAnswer: 1),
      Exercise(question: '4 + 7 = ?', options: ['10', '9', '12', '11'], correctAnswer: 3),
      Exercise(question: '3 + 8 = ?', options: ['10', '11', '12', '9'], correctAnswer: 1),
      Exercise(question: '2 + 9 = ?', options: ['11', '10', '12', '13'], correctAnswer: 0),
      Exercise(question: '1 + 5 = ?', options: ['5', '7', '6', '8'], correctAnswer: 2),
      Exercise(question: '0 + 8 = ?', options: ['7', '8', '9', '6'], correctAnswer: 1),
      Exercise(question: '9 + 6 = ?', options: ['15', '14', '16', '13'], correctAnswer: 0),
      Exercise(question: '12 + 3 = ?', options: ['14', '15', '16', '13'], correctAnswer: 1),
      // Exercices supplémentaires
      Exercise(question: '11 + 9 = ?', options: ['19', '21', '20', '18'], correctAnswer: 2),
      Exercise(question: '15 + 2 = ?', options: ['18', '17', '16', '15'], correctAnswer: 1),
      Exercise(question: '10 + 10 = ?', options: ['19', '20', '21', '18'], correctAnswer: 1),
      Exercise(question: '14 + 5 = ?', options: ['18', '20', '19', '17'], correctAnswer: 2),
      Exercise(question: '1 + 13 = ?', options: ['14', '13', '15', '16'], correctAnswer: 0),
      Exercise(question: '7 + 7 = ?', options: ['13', '15', '14', '12'], correctAnswer: 2),
      Exercise(question: '16 + 4 = ?', options: ['19', '21', '20', '18'], correctAnswer: 2),
      Exercise(question: '17 + 1 = ?', options: ['17', '19', '16', '18'], correctAnswer: 3),
    ],
    'Soustraction': [
      Exercise(question: '12 - 3 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '14 - 6 = ?', options: ['8', '7', '9', '6'], correctAnswer: 0),
      Exercise(question: '10 - 4 = ?', options: ['5', '6', '7', '4'], correctAnswer: 1),
      Exercise(question: '13 - 5 = ?', options: ['9', '6', '7', '8'], correctAnswer: 3),
      Exercise(question: '9 - 2 = ?', options: ['7', '8', '6', '5'], correctAnswer: 0),
      Exercise(question: '11 - 7 = ?', options: ['3', '5', '4', '6'], correctAnswer: 2),
      Exercise(question: '8 - 3 = ?', options: ['6', '5', '4', '3'], correctAnswer: 1),
      Exercise(question: '15 - 6 = ?', options: ['9', '10', '8', '11'], correctAnswer: 0),
      Exercise(question: '7 - 2 = ?', options: ['5', '4', '6', '3'], correctAnswer: 0),
      Exercise(question: '10 - 8 = ?', options: ['2', '3', '1', '4'], correctAnswer: 0),
      Exercise(question: '6 - 1 = ?', options: ['4', '3', '5', '6'], correctAnswer: 2),
      Exercise(question: '13 - 8 = ?', options: ['6', '4', '5', '7'], correctAnswer: 2),
      // Exercices supplémentaires
      Exercise(question: '18 - 5 = ?', options: ['12', '13', '14', '11'], correctAnswer: 1),
      Exercise(question: '20 - 10 = ?', options: ['9', '11', '10', '12'], correctAnswer: 2),
      Exercise(question: '16 - 7 = ?', options: ['8', '10', '9', '7'], correctAnswer: 2),
      Exercise(question: '11 - 3 = ?', options: ['7', '9', '8', '6'], correctAnswer: 2),
      Exercise(question: '17 - 1 = ?', options: ['15', '17', '16', '14'], correctAnswer: 2),
      Exercise(question: '19 - 9 = ?', options: ['11', '10', '9', '8'], correctAnswer: 1),
      Exercise(question: '15 - 7 = ?', options: ['9', '7', '8', '6'], correctAnswer: 2),
      Exercise(question: '12 - 5 = ?', options: ['6', '8', '7', '5'], correctAnswer: 2),
    ],
    'Multiplication': [
      Exercise(question: '2 x 3 = ?', options: ['6', '5', '7', '4'], correctAnswer: 0),
      Exercise(question: '4 x 2 = ?', options: ['8', '10', '7', '6'], correctAnswer: 0),
      Exercise(question: '5 x 1 = ?', options: ['4', '5', '6', '7'], correctAnswer: 1),
      Exercise(question: '3 x 3 = ?', options: ['12', '9', '3', '6'], correctAnswer: 1),
      Exercise(question: '6 x 2 = ?', options: ['10', '14', '12', '8'], correctAnswer: 2),
      Exercise(question: '7 x 1 = ?', options: ['7', '6', '8', '9'], correctAnswer: 0),
      Exercise(question: '2 x 4 = ?', options: ['8', '6', '7', '10'], correctAnswer: 0),
      Exercise(question: '1 x 9 = ?', options: ['10', '9', '8', '7'], correctAnswer: 1),
      Exercise(question: '3 x 5 = ?', options: ['15', '12', '13', '14'], correctAnswer: 0),
      Exercise(question: '2 x 6 = ?', options: ['10', '12', '11', '8'], correctAnswer: 1),
      Exercise(question: '4 x 3 = ?', options: ['11', '12', '13', '14'], correctAnswer: 1),
      Exercise(question: '5 x 2 = ?', options: ['12', '9', '10', '11'], correctAnswer: 2),
      // Exercices supplémentaires
      Exercise(question: '5 x 4 = ?', options: ['20', '15', '25', '18'], correctAnswer: 0),
      Exercise(question: '3 x 4 = ?', options: ['10', '14', '12', '13'], correctAnswer: 2),
      Exercise(question: '2 x 5 = ?', options: ['8', '12', '10', '9'], correctAnswer: 2),
      Exercise(question: '10 x 1 = ?', options: ['10', '9', '11', '12'], correctAnswer: 0),
      Exercise(question: '4 x 4 = ?', options: ['12', '16', '14', '18'], correctAnswer: 1),
      Exercise(question: '5 x 5 = ?', options: ['20', '25', '30', '15'], correctAnswer: 1),
      Exercise(question: '6 x 3 = ?', options: ['15', '18', '21', '16'], correctAnswer: 1),
      Exercise(question: '2 x 7 = ?', options: ['12', '16', '14', '15'], correctAnswer: 2),
    ],
    'Division': [
      Exercise(question: '6 ÷ 2 = ?', options: ['2', '3', '4', '6'], correctAnswer: 1),
      Exercise(question: '8 ÷ 4 = ?', options: ['2', '1', '3', '4'], correctAnswer: 0),
      Exercise(question: '9 ÷ 3 = ?', options: ['2', '3', '4', '5'], correctAnswer: 1),
      Exercise(question: '12 ÷ 6 = ?', options: ['1', '2', '3', '4'], correctAnswer: 1),
      Exercise(question: '10 ÷ 5 = ?', options: ['2', '3', '1', '4'], correctAnswer: 0),
      Exercise(question: '15 ÷ 3 = ?', options: ['5', '4', '6', '3'], correctAnswer: 0),
      Exercise(question: '16 ÷ 4 = ?', options: ['2', '3', '4', '5'], correctAnswer: 2),
      Exercise(question: '18 ÷ 2 = ?', options: ['8', '9', '10', '7'], correctAnswer: 1),
      Exercise(question: '20 ÷ 5 = ?', options: ['4', '5', '3', '2'], correctAnswer: 0),
      Exercise(question: '14 ÷ 7 = ?', options: ['1', '0', '3', '2'], correctAnswer: 3),
      Exercise(question: '8 ÷ 2 = ?', options: ['4', '3', '2', '5'], correctAnswer: 0),
      Exercise(question: '6 ÷ 3 = ?', options: ['3', '2', '1', '0'], correctAnswer: 1),
      // Exercices supplémentaires
      Exercise(question: '12 ÷ 4 = ?', options: ['4', '3', '2', '5'], correctAnswer: 1),
      Exercise(question: '25 ÷ 5 = ?', options: ['4', '6', '5', '3'], correctAnswer: 2),
      Exercise(question: '10 ÷ 2 = ?', options: ['6', '4', '5', '3'], correctAnswer: 2),
      Exercise(question: '18 ÷ 3 = ?', options: ['7', '5', '6', '8'], correctAnswer: 2),
      Exercise(question: '16 ÷ 8 = ?', options: ['3', '2', '4', '1'], correctAnswer: 1),
      Exercise(question: '20 ÷ 4 = ?', options: ['6', '5', '4', '3'], correctAnswer: 1),
      Exercise(question: '12 ÷ 3 = ?', options: ['5', '3', '4', '6'], correctAnswer: 2),
      Exercise(question: '9 ÷ 1 = ?', options: ['8', '9', '10', '7'], correctAnswer: 1),
    ],
    'Géométrie': [
      Exercise(question: 'Combien de côtés a un rectangle ?', options: ['3', '5', '4', '6'], correctAnswer: 2),
      Exercise(question: 'Combien de sommets a un triangle ?', options: ['3', '2', '4', '5'], correctAnswer: 0),
      Exercise(question: 'Le carré a combien d\'angles droits ?', options: ['5', '4', '3', '2'], correctAnswer: 1),
      Exercise(question: 'Quel est le nombre de côtés d\'un cercle ?', options: ['0', '1', '2', 'infini'], correctAnswer: 0),
      Exercise(question: 'Combien de côtés a un pentagone ?', options: ['4', '6', '5', '7'], correctAnswer: 2),
      Exercise(question: 'Combien de faces a un cube ?', options: ['8', '6', '7', '5'], correctAnswer: 1),
      Exercise(question: 'Combien d\'arêtes a un triangle ?', options: ['2', '3', '4', '5'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un hexagone ?', options: ['6', '7', '8', '5'], correctAnswer: 0),
      Exercise(question: 'Combien de sommets a un carré ?', options: ['4', '3', '5', '6'], correctAnswer: 0),
      Exercise(question: 'Combien de faces a une pyramide ?', options: ['5', '4', '6', '3'], correctAnswer: 0),
      Exercise(question: 'Combien de sommets a un cube ?', options: ['5', '6', '7', '8'], correctAnswer: 3),
      Exercise(question: 'Combien de côtés a un triangle ?', options: ['3', '2', '4', '5'], correctAnswer: 0),
      // Exercices supplémentaires
      Exercise(question: 'Quelle figure a six côtés égaux ?', options: ['Carré', 'Triangle', 'Hexagone', 'Pentagone'], correctAnswer: 2),
      Exercise(question: 'Quel corps solide ressemble à une balle de football ?', options: ['Cube', 'Cône', 'Sphère', 'Cylindre'], correctAnswer: 2),
      Exercise(question: 'Un triangle a-t-il toujours trois angles ?', options: ['Non', 'Oui', 'Parfois', 'Deux'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un trapèze ?', options: ['3', '4', '5', '6'], correctAnswer: 1),
      Exercise(question: 'Le soleil est-il un exemple de... ?', options: ['Cylindre', 'Cône', 'Sphère', 'Pyramide'], correctAnswer: 2),
      Exercise(question: 'Combien de sommets a un cône ?', options: ['1', '2', '0', '3'], correctAnswer: 0),
      Exercise(question: 'Quelle figure a quatre côtés égaux et quatre angles droits ?', options: ['Rectangle', 'Losange', 'Trapèze', 'Carré'], correctAnswer: 3),
      Exercise(question: 'Combien d\'arêtes a un cube ?', options: ['8', '10', '12', '6'], correctAnswer: 2),
    ],
  },
  'CE1': {
    'Addition': [
      Exercise(question: '15 + 10 = ?', options: ['24', '25', '26', '27'], correctAnswer: 1),
      Exercise(question: '6 + 13 = ?', options: ['17', '18', '19', '20'], correctAnswer: 2),
      Exercise(question: '9 + 7 = ?', options: ['15', '16', '17', '18'], correctAnswer: 1),
      Exercise(question: '14 + 8 = ?', options: ['21', '23', '22', '24'], correctAnswer: 2),
      Exercise(question: '12 + 11 = ?', options: ['23', '22', '21', '24'], correctAnswer: 0),
      Exercise(question: '17 + 5 = ?', options: ['21', '22', '23', '24'], correctAnswer: 1),
      Exercise(question: '18 + 6 = ?', options: ['24', '23', '25', '26'], correctAnswer: 0),
      Exercise(question: '11 + 14 = ?', options: ['23', '26', '24', '25'], correctAnswer: 3),
      Exercise(question: '20 + 9 = ?', options: ['27', '28', '29', '30'], correctAnswer: 2),
      Exercise(question: '8 + 13 = ?', options: ['20', '23', '22', '21'], correctAnswer: 3),
      Exercise(question: '7 + 16 = ?', options: ['21', '22', '23', '24'], correctAnswer: 2),
      Exercise(question: '19 + 4 = ?', options: ['22', '23', '24', '25'], correctAnswer: 1),
      // Exercices supplémentaires
      Exercise(question: '25 + 7 = ?', options: ['31', '33', '32', '34'], correctAnswer: 2),
      Exercise(question: '10 + 20 = ?', options: ['20', '30', '35', '25'], correctAnswer: 1),
      Exercise(question: '16 + 15 = ?', options: ['30', '32', '31', '29'], correctAnswer: 2),
      Exercise(question: '13 + 13 = ?', options: ['24', '26', '28', '25'], correctAnswer: 1),
      Exercise(question: '21 + 9 = ?', options: ['29', '31', '30', '28'], correctAnswer: 2),
      Exercise(question: '19 + 11 = ?', options: ['29', '30', '31', '32'], correctAnswer: 1),
      Exercise(question: '3 + 28 = ?', options: ['30', '31', '29', '32'], correctAnswer: 1),
      Exercise(question: '15 + 15 = ?', options: ['28', '30', '32', '31'], correctAnswer: 1),
    ],
    'Soustraction': [
      Exercise(question: '20 - 9 = ?', options: ['10', '11', '12', '13'], correctAnswer: 1),
      Exercise(question: '18 - 7 = ?', options: ['11', '10', '12', '13'], correctAnswer: 0),
      Exercise(question: '15 - 8 = ?', options: ['7', '8', '9', '10'], correctAnswer: 0),
      Exercise(question: '24 - 12 = ?', options: ['11', '12', '13', '14'], correctAnswer: 1),
      Exercise(question: '17 - 6 = ?', options: ['10', '13', '12', '11'], correctAnswer: 3),
      Exercise(question: '22 - 13 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '30 - 15 = ?', options: ['13', '14', '15', '16'], correctAnswer: 2),
      Exercise(question: '25 - 9 = ?', options: ['14', '15', '16', '17'], correctAnswer: 2),
      Exercise(question: '17 - 8 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '23 - 16 = ?', options: ['7', '6', '8', '9'], correctAnswer: 0),
      Exercise(question: '14 - 5 = ?', options: ['8', '10', '9', '11'], correctAnswer: 2),
      Exercise(question: '26 - 17 = ?', options: ['7', '8', '9', '10'], correctAnswer: 2),
      // Exercices supplémentaires
      Exercise(question: '19 - 6 = ?', options: ['12', '13', '14', '15'], correctAnswer: 1),
      Exercise(question: '28 - 10 = ?', options: ['17', '18', '19', '16'], correctAnswer: 1),
      Exercise(question: '35 - 5 = ?', options: ['31', '30', '29', '28'], correctAnswer: 1),
      Exercise(question: '21 - 4 = ?', options: ['16', '18', '17', '15'], correctAnswer: 2),
      Exercise(question: '16 - 9 = ?', options: ['6', '8', '7', '5'], correctAnswer: 2),
      Exercise(question: '29 - 11 = ?', options: ['17', '19', '18', '20'], correctAnswer: 2),
      Exercise(question: '25 - 18 = ?', options: ['8', '7', '6', '5'], correctAnswer: 1),
      Exercise(question: '33 - 13 = ?', options: ['19', '20', '21', '22'], correctAnswer: 1),
    ],
    'Multiplication': [
      Exercise(question: '3 x 6 = ?', options: ['18', '17', '16', '19'], correctAnswer: 0),
      Exercise(question: '4 x 4 = ?', options: ['15', '16', '17', '18'], correctAnswer: 1),
      Exercise(question: '7 x 2 = ?', options: ['13', '15', '14', '16'], correctAnswer: 2),
      Exercise(question: '5 x 3 = ?', options: ['15', '16', '14', '13'], correctAnswer: 0),
      Exercise(question: '8 x 2 = ?', options: ['16', '15', '14', '17'], correctAnswer: 0),
      Exercise(question: '6 x 5 = ?', options: ['29', '30', '31', '32'], correctAnswer: 1),
      Exercise(question: '9 x 2 = ?', options: ['16', '17', '18', '19'], correctAnswer: 2),
      Exercise(question: '3 x 7 = ?', options: ['21', '22', '23', '24'], correctAnswer: 0),
      Exercise(question: '2 x 9 = ?', options: ['17', '20', '19', '18'], correctAnswer: 3),
      Exercise(question: '4 x 5 = ?', options: ['19', '20', '21', '22'], correctAnswer: 1),
      Exercise(question: '7 x 3 = ?', options: ['20', '21', '22', '23'], correctAnswer: 1),
      Exercise(question: '2 x 8 = ?', options: ['15', '18', '17', '16'], correctAnswer: 3),
      // Exercices supplémentaires
      Exercise(question: '10 x 4 = ?', options: ['30', '40', '50', '20'], correctAnswer: 1),
      Exercise(question: '5 x 6 = ?', options: ['35', '30', '25', '40'], correctAnswer: 1),
      Exercise(question: '4 x 7 = ?', options: ['26', '28', '24', '30'], correctAnswer: 1),
      Exercise(question: '3 x 8 = ?', options: ['21', '24', '27', '25'], correctAnswer: 1),
      Exercise(question: '10 x 3 = ?', options: ['20', '30', '40', '50'], correctAnswer: 1),
      Exercise(question: '5 x 9 = ?', options: ['40', '45', '50', '35'], correctAnswer: 1),
      Exercise(question: '4 x 8 = ?', options: ['30', '32', '34', '36'], correctAnswer: 1),
      Exercise(question: '6 x 4 = ?', options: ['22', '24', '26', '28'], correctAnswer: 1),
    ],
    'Division': [
      Exercise(question: '16 ÷ 4 = ?', options: ['4', '3', '2', '5'], correctAnswer: 0),
      Exercise(question: '18 ÷ 3 = ?', options: ['5', '6', '7', '8'], correctAnswer: 1),
      Exercise(question: '20 ÷ 5 = ?', options: ['3', '5', '4', '6'], correctAnswer: 2),
      Exercise(question: '24 ÷ 6 = ?', options: ['4', '3', '5', '6'], correctAnswer: 0 ),
      Exercise(question: '36 ÷ 4 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '21 ÷ 7 = ?', options: ['2', '5', '4', '3'], correctAnswer: 3),
      Exercise(question: '12 ÷ 6 = ?', options: ['1', '2', '3', '4'], correctAnswer: 1),
      Exercise(question: '28 ÷ 7 = ?', options: ['3', '6', '5', '4'], correctAnswer: 3),
      Exercise(question: '32 ÷ 8 = ?', options: ['3', '4', '5', '6'], correctAnswer: 1),
      Exercise(question: '27 ÷ 3 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '14 ÷ 2 = ?', options: ['5', '6', '7', '8'], correctAnswer: 2),
      Exercise(question: '18 ÷ 2 = ?', options: ['9', '8', '10', '7'], correctAnswer: 0),
      // Exercices supplémentaires
      Exercise(question: '30 ÷ 5 = ?', options: ['5', '6', '7', '4'], correctAnswer: 1),
      Exercise(question: '40 ÷ 10 = ?', options: ['3', '5', '4', '6'], correctAnswer: 2),
      Exercise(question: '24 ÷ 4 = ?', options: ['5', '7', '6', '8'], correctAnswer: 2),
      Exercise(question: '30 ÷ 3 = ?', options: ['9', '11', '10', '12'], correctAnswer: 2),
      Exercise(question: '35 ÷ 5 = ?', options: ['6', '8', '7', '9'], correctAnswer: 2),
      Exercise(question: '45 ÷ 9 = ?', options: ['5', '6', '4', '7'], correctAnswer: 0),
      Exercise(question: '20 ÷ 2 = ?', options: ['8', '10', '9', '11'], correctAnswer: 1),
      Exercise(question: '15 ÷ 3 = ?', options: ['4', '5', '6', '3'], correctAnswer: 1),
    ],
    'Géométrie': [
      Exercise(question: 'Combien de côtés a un rectangle ?', options: ['2', '3', '4', '5'], correctAnswer: 2),
      Exercise(question: 'Combien d\'angles droits a un carré ?', options: ['2', '3', '4', '1'], correctAnswer: 2),
      Exercise(question: 'Un triangle a combien d\'angles ?', options: ['3', '2', '4', '5'], correctAnswer: 0),
      Exercise(question: 'Un hexagone a combien de côtés ?', options: ['8', '5', '7', '6'], correctAnswer: 3),
      Exercise(question: 'Un pentagone a combien de côtés ?', options: ['4', '5', '6', '7'], correctAnswer: 1),
      Exercise(question: 'Combien de faces a un cube ?', options: ['5', '6', '7', '4'], correctAnswer: 1),
      Exercise(question: 'Combien de sommets a un cube ?', options: ['7', '8', '9', '6'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un carré ?', options: ['4', '5', '3', '6'], correctAnswer: 0),
      Exercise(question: 'Combien de faces a une pyramide ?', options: ['4', '5', '6', '3'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un cercle ?', options: ['0', '1', '2', '3'], correctAnswer: 0),
      Exercise(question: 'Combien de faces a un parallélépipède ?', options: ['6', '7', '5', '8'], correctAnswer: 0),
      Exercise(question: 'Combien d\'arêtes a un cube ?', options: ['14', '11', '13', '12'], correctAnswer: 3),
      // Exercices supplémentaires
      Exercise(question: 'Quelle forme a une face circulaire et un sommet ?', options: ['Cylindre', 'Cône', 'Sphère', 'Cube'], correctAnswer: 1),
      Exercise(question: 'Combien de côtés a un octogone ?', options: ['7', '8', '9', '6'], correctAnswer: 1),
      Exercise(question: 'Un cube a-t-il des arêtes courbes ?', options: ['Oui', 'Non', 'Parfois', 'Seulement 4'], correctAnswer: 1),
      Exercise(question: 'Quel est le nom d\'une figure à 3 côtés ?', options: ['Carré', 'Triangle', 'Cercle', 'Rectangle'], correctAnswer: 1),
      Exercise(question: 'Combien de faces a un cylindre ?', options: ['1', '2', '3', '4'], correctAnswer: 2),
      Exercise(question: 'Un losange a combien de côtés ?', options: ['3', '4', '5', '6'], correctAnswer: 1),
      Exercise(question: 'Quelle figure est ronde et plate ?', options: ['Cercle', 'Cube', 'Cylindre', 'Triangle'], correctAnswer: 0),
      Exercise(question: 'Une ligne droite qui ne se termine jamais est appelée...', options: ['Segment', 'Rayon', 'Ligne', 'Point'], correctAnswer: 2),
    ],
  },
  'CE2': {
    'Addition': [
      Exercise(
          question: 'Sarah a 125 billes et en gagne 87 à la récréation. Combien de billes a-t-elle maintenant ?',
          options: ['212', '210', '213', '211'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un bus transporte 134 passagers le matin et 96 passagers l\'après-midi. Combien de passagers ont été transportés en tout ?',
          options: ['229', '232', '230', '231'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Lucas lit 56 pages lundi et 49 pages mardi. Combien de pages a-t-il lues en tout ?',
          options: ['106', '107', '105', '104'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Julie a 87 bonbons. Elle en reçoit 58 de sa maman. Combien de bonbons a-t-elle en tout ?',
          options: ['147', '146', '144', '145'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une école a 198 élèves en CE2 et 207 en CM1. Combien d\'élèves y a-t-il dans ces deux classes ?',
          options: ['407', '408', '406', '405'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Dans une bibliothèque, il y a 156 livres et on en ajoute 64. Combien y a-t-il de livres maintenant ?',
          options: ['219', '222', '220', '221'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un magasin vend 89 jouets le matin et 111 jouets l\'après-midi. Combien de jouets ont été vendus en tout ?',
          options: ['201', '200', '198', '199'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Au goûter, Léo mange 123 biscuits et sa sœur 66 biscuits. Combien en ont-ils mangé ensemble ?',
          options: ['188', '191', '190', '189'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un fermier récolte 150 pommes et en cueille encore 75. Combien de pommes a-t-il ?',
          options: ['224', '226', '225', '227'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Paul ramasse 43 feuilles puis 58 de plus. Combien de feuilles a-t-il ramassées ?',
          options: ['103', '101', '102', '100'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Une classe récolte 77 euros et une autre 33 euros. Quelle somme ont-ils en tout ?',
          options: ['112', '109', '110', '111'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Maman achète 180 g de farine et 19 g de sucre. Quel est le poids total ?',
          options: ['201', '199', '198', '200'],
          correctAnswer: 1
      ),
      // Exercices supplémentaires d'Addition
      Exercise(
          question: 'Dans un train, il y a 238 personnes. 145 personnes montent à l\'arrêt suivant. Combien y a-t-il de personnes dans le train ?',
          options: ['383', '381', '382', '384'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un jeu vidéo coûte 129 euros, et un autre 78 euros. Quel est le coût total ?',
          options: ['205', '206', '207', '204'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Jules a 200 images, et sa sœur lui donne 115 de plus. Combien d\'images a-t-il ?',
          options: ['314', '316', '315', '317'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une voiture roule 175 km puis 185 km. Quelle distance a-t-elle parcourue ?',
          options: ['360', '350', '340', '370'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un boulanger prépare 250 croissants le matin et 130 l\'après-midi. Combien de croissants a-t-il préparés ?',
          options: ['390', '380', '370', '400'],
          correctAnswer: 1
      ),
      Exercise(
          question: '49 + 253 = ?',
          options: ['301', '302', '303', '304'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un sac pèse 215 g. On ajoute 95 g de sable. Quel est le poids total ?',
          options: ['300', '310', '320', '315'],
          correctAnswer: 2
      ),
      Exercise(
          question: '105 + 98 = ?',
          options: ['203', '204', '202', '205'],
          correctAnswer: 0
      ),
    ],
    'Soustraction': [
      Exercise(
          question: 'Paul avait 156 billes. Il en donne 79 à son ami. Combien lui en reste-t-il ?',
          options: ['79', '76', '77', '78'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une bibliothèque a 245 livres. 89 sont empruntés. Combien de livres restent-ils ?',
          options: ['155', '156', '158', '157'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Il y avait 300 gâteaux et on en mange 128. Combien en reste-t-il ?',
          options: ['173', '172', '171', '174'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un magasin a 230 jouets. Il en vend 98. Combien en reste-t-il ?',
          options: ['131', '133', '130', '132'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Pierre a 160 billes. Il en perd 87. Combien lui reste-t-il ?',
          options: ['72', '74', '73', '75'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une boîte contient 200 billes. On en retire 65. Combien de billes restent dans la boîte ?',
          options: ['134', '137', '136', '135'],
          correctAnswer: 3
      ),
      Exercise(
          question: '178 élèves sont inscrits à la cantine, 99 sont absents. Combien mangent à la cantine ?',
          options: ['81', '80', '79', '78'],
          correctAnswer: 2
      ),
      Exercise(
          question: '141 enfants partent en sortie, 70 restent à l\'école. Combien sont partis en sortie ?',
          options: ['73', '71', '70', '72'],
          correctAnswer: 1
      ),
      Exercise(
          question: '189 voitures étaient garées, 64 sont parties. Combien en reste-t-il ?',
          options: ['124', '127', '126', '125'],
          correctAnswer: 3
      ),
      Exercise(
          question: '175 oiseaux étaient sur un fil, 75 s\'envolent. Combien restent-ils ?',
          options: ['101', '100', '102', '99'],
          correctAnswer: 1
      ),
      Exercise(
          question: '210 stylos, 101 sont utilisés. Combien restent-ils neufs ?',
          options: ['108', '110', '111', '109'],
          correctAnswer: 3
      ),
      Exercise(
          question: '325 élèves étaient prévus, 123 sont absents. Combien d\'élèves sont présents ?',
          options: ['203', '202', '201', '200'],
          correctAnswer: 1
      ),
      // Exercices supplémentaires de Soustraction
      Exercise(
          question: 'Dans un réservoir de 350 litres, on en utilise 150. Combien de litres restent ?',
          options: ['190', '200', '210', '180'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un voyageur parcourt 400 km. Il lui en reste 115 à faire. Combien de km a-t-il déjà parcouru ?',
          options: ['285', '275', '295', '265'],
          correctAnswer: 2
      ),
      Exercise(
          question: '315 - 90 = ?',
          options: ['220', '215', '225', '230'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Le prix était de 299 euros. Il baisse de 100 euros. Quel est le nouveau prix ?',
          options: ['199', '200', '198', '201'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Dans un carton de 250 œufs, 75 sont cassés. Combien d\'œufs restent ?',
          options: ['170', '185', '165', '175'],
          correctAnswer: 4
      ),
      Exercise(
          question: '450 - 150 = ?',
          options: ['200', '300', '350', '250'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un paquet de 100 feuilles en contient 42 qui sont gâchées. Combien de feuilles utilisables ?',
          options: ['57', '58', '59', '56'],
          correctAnswer: 1
      ),
      Exercise(
          question: '190 - 78 = ?',
          options: ['112', '110', '113', '111'],
          correctAnswer: 0
      ),
    ],
    'Multiplication': [
      Exercise(
          question: 'Il y a 12 boîtes avec 3 bonbons dans chaque. Combien y a-t-il de bonbons en tout ?',
          options: ['34', '37', '35', '36'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un jardinier plante 9 rangées de 6 arbres. Combien d\'arbres au total ?',
          options: ['55', '54', '53', '56'],
          correctAnswer: 1
      ),
      Exercise(
          question: '7 paniers contiennent chacun 8 pommes. Combien de pommes en tout ?',
          options: ['57', '58', '55', '56'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un commerçant vend 11 caisses de 4 bouteilles. Combien de bouteilles vendues ?',
          options: ['45', '47', '44', '46'],
          correctAnswer: 2
      ),
      Exercise(
          question: '6 sacs contiennent chacun 9 billes. Combien de billes au total ?',
          options: ['54', '53', '56', '55'],
          correctAnswer: 0
      ),
      Exercise(
          question: '8 enfants reçoivent chacun 5 cartes. Combien de cartes distribuées ?',
          options: ['43', '42', '41', '40'],
          correctAnswer: 3
      ),
      Exercise(
          question: '7 boîtes avec 7 billes chacune. Combien de billes en tout ?',
          options: ['50', '49', '51', '48'],
          correctAnswer: 1
      ),
      Exercise(
          question: '5 amis collectionnent chacun 9 images. Combien d\'images en tout ?',
          options: ['47', '44', '46', '45'],
          correctAnswer: 3
      ),
      Exercise(
          question: '4 caisses de 9 oranges chacune. Combien d\'oranges ?',
          options: ['38', '35', '37', '36'],
          correctAnswer: 3
      ),
      Exercise(
          question: '8 paquets de 3 chocolats. Combien de chocolats ?',
          options: ['26', '23', '25', '24'],
          correctAnswer: 3
      ),
      Exercise(
          question: '2 boîtes de 12 crayons. Combien de crayons ?',
          options: ['24', '23', '25', '26'],
          correctAnswer: 0
      ),
      Exercise(
          question: '6 enfants font chacun 7 dessins. Combien de dessins ?',
          options: ['41', '44', '43', '42'],
          correctAnswer: 3
      ),
      // Exercices supplémentaires de Multiplication
      Exercise(
          question: '10 boîtes de 50 trombones. Combien de trombones en tout ?',
          options: ['400', '500', '600', '450'],
          correctAnswer: 1
      ),
      Exercise(
          question: '5 paquets de 15 feutres. Combien de feutres ?',
          options: ['70', '75', '80', '65'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Combien font 12 x 5 ?',
          options: ['65', '55', '60', '70'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien font 9 x 10 ?',
          options: ['80', '100', '90', '95'],
          correctAnswer: 2
      ),
      Exercise(
          question: '3 rangées de 12 chaises. Combien de chaises ?',
          options: ['33', '35', '36', '37'],
          correctAnswer: 2
      ),
      Exercise(
          question: '4 boîtes de 10 gommes. Combien de gommes ?',
          options: ['40', '50', '30', '45'],
          correctAnswer: 0
      ),
      Exercise(
          question: '15 pièces de 2 euros. Quelle somme ?',
          options: ['28', '35', '30', '32'],
          correctAnswer: 2
      ),
      Exercise(
          question: '8 x 8 = ?',
          options: ['65', '64', '63', '62'],
          correctAnswer: 1
      ),
    ],
    'Division': [
      Exercise(
          question: '72 bonbons sont partagés entre 8 enfants. Combien chacun reçoit-il ?',
          options: ['7', '10', '8', '9'],
          correctAnswer: 3
      ),
      Exercise(
          question: '96 crayons répartis dans 12 boîtes. Combien de crayons par boîte ?',
          options: ['9', '10', '7', '8'],
          correctAnswer: 3
      ),
      Exercise(
          question: '80 pommes sont mises en 10 paniers. Combien par panier ?',
          options: ['8', '7', '9', '10'],
          correctAnswer: 0
      ),
      Exercise(
          question: '60 élèves sont répartis en 5 groupes. Combien d\'élèves dans chaque groupe ?',
          options: ['13', '15', '14', '12'],
          correctAnswer: 3
      ),
      Exercise(
          question: '48 bonbons pour 6 enfants. Combien chacun reçoit-il ?',
          options: ['7', '6', '9', '8'],
          correctAnswer: 3
      ),
      Exercise(
          question: '90 billes à partager entre 9 enfants. Combien chaque enfant ?',
          options: ['11', '8', '9', '10'],
          correctAnswer: 3
      ),
      Exercise(
          question: '100 billes à répartir dans 4 boîtes. Combien par boîte ?',
          options: ['24', '26', '25', '23'],
          correctAnswer: 2
      ),
      Exercise(
          question: '36 bonbons à partager entre 6 enfants. Combien chacun ?',
          options: ['4', '7', '5', '6'],
          correctAnswer: 3
      ),
      Exercise(
          question: '81 pommes à répartir en 9 paniers. Combien par panier ?',
          options: ['6', '7', '8', '9'],
          correctAnswer: 3
      ),
      Exercise(
          question: '56 gâteaux à distribuer en 8 parts égales. Combien par part ?',
          options: ['6', '9', '8', '7'],
          correctAnswer: 3
      ),
      Exercise(
          question: '72 billes pour 6 enfants. Combien chacun ?',
          options: ['14', '11', '13', '12'],
          correctAnswer: 3
      ),
      Exercise(
          question: '84 bonbons partagés entre 7 enfants. Combien chacun ?',
          options: ['11', '10', '9', '12'],
          correctAnswer: 3
      ),
      // Exercices supplémentaires de Division
      Exercise(
          question: '49 stylos à ranger par 7. Combien de groupes ?',
          options: ['6', '7', '8', '5'],
          correctAnswer: 1
      ),
      Exercise(
          question: '50 cahiers à distribuer à 10 élèves. Combien chacun ?',
          options: ['6', '5', '4', '7'],
          correctAnswer: 1
      ),
      Exercise(
          question: '40 ÷ 8 = ?',
          options: ['4', '5', '6', '3'],
          correctAnswer: 1
      ),
      Exercise(
          question: '120 billes à répartir en 10 boîtes. Combien par boîte ?',
          options: ['10', '12', '11', '13'],
          correctAnswer: 1
      ),
      Exercise(
          question: '45 ÷ 5 = ?',
          options: ['8', '10', '7', '9'],
          correctAnswer: 3
      ),
      Exercise(
          question: '30 ÷ 3 = ?',
          options: ['9', '11', '10', '12'],
          correctAnswer: 2
      ),
      Exercise(
          question: '144 ÷ 12 = ?',
          options: ['13', '11', '12', '10'],
          correctAnswer: 2
      ),
      Exercise(
          question: '200 élèves répartis en 5 classes. Combien par classe ?',
          options: ['30', '50', '40', '60'],
          correctAnswer: 2
      ),
    ],
    'Géométrie': [
      Exercise(question: 'Un losange a combien de côtés égaux ?', options: ['3', '5', '4', '2'], correctAnswer: 2),
      Exercise(question: 'Combien de côtés a un octogone ?', options: ['9', '6', '8', '7'], correctAnswer: 2),
      Exercise(question: 'Un trapèze a combien de côtés parallèles ?', options: ['0', '2', '3', '1'], correctAnswer: 1),
      Exercise(question: 'Quel solide a 6 faces carrées ?', options: ['Prisme', 'Cylindre', 'Pyramide', 'Cube'], correctAnswer: 3),
      Exercise(question: 'Combien de faces a un prisme rectangulaire ?', options: ['8', '7', '6', '5'], correctAnswer: 2),
      Exercise(question: 'Combien de sommets a un cube ?', options: ['10', '6', '8', '12'], correctAnswer: 2),
      Exercise(question: 'Combien d\'arêtes a un cube ?', options: ['13', '14', '11', '12'], correctAnswer: 3),
      Exercise(question: 'Combien de faces a un tétraèdre ?', options: ['3', '5', '6', '4'], correctAnswer: 3),
      Exercise(question: 'Combien de côtés a un décagone ?', options: ['12', '9', '11', '10'], correctAnswer: 3),
      Exercise(question: 'Combien d\'angles droits a un rectangle ?', options: ['5', '2', '3', '4'], correctAnswer: 3),
      Exercise(question: 'Combien de faces a une pyramide à base carrée ?', options: ['7', '4', '6', '5'], correctAnswer: 3),
      Exercise(question: 'Combien de sommets a une pyramide à base carrée ?', options: ['7', '6', '4', '5'], correctAnswer: 3),
      // Exercices supplémentaires de Géométrie
      Exercise(question: 'Quelle forme 3D a un cercle pour base et un sommet ?', options: ['Cylindre', 'Cône', 'Sphère', 'Cube'], correctAnswer: 1),
      Exercise(question: 'Comment appelle-t-on la figure qui a 5 côtés ?', options: ['Hexagone', 'Pentagone', 'Octogone', 'Trapèze'], correctAnswer: 1),
      Exercise(question: 'Une ligne qui passe par le centre d\'un cercle s\'appelle le ... ?', options: ['Rayon', 'Diamètre', 'Côté', 'Arête'], correctAnswer: 1),
      Exercise(question: 'Quel solide ressemble à une boîte de conserve ?', options: ['Cône', 'Pyramide', 'Cylindre', 'Cube'], correctAnswer: 2),
      Exercise(question: 'Un triangle qui a tous ses côtés égaux est un triangle ... ?', options: ['Rectangle', 'Isocèle', 'Scalène', 'Équilatéral'], correctAnswer: 3),
      Exercise(question: 'Combien de faces a un pavé droit ?', options: ['4', '6', '8', '12'], correctAnswer: 1),
      Exercise(question: 'Quatre côtés égaux sans angle droit, c\'est un... ?', options: ['Carré', 'Rectangle', 'Losange', 'Trapèze'], correctAnswer: 2),
      Exercise(question: 'La distance du centre à la bordure d\'un cercle est le... ?', options: ['Diamètre', 'Rayon', 'Périmètre', 'Côté'], correctAnswer: 1),
    ],
  },
  'CM1': {
    'Addition': [
      Exercise(
          question: 'Un club sportif compte 1 235 filles et 1 897 garçons. Quel est le nombre total d\'adhérents ?',
          options: ['3134', '3133', '3135', '3132'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Mathieu collectionne 786 cartes et en reçoit 943 de plus. Combien en a-t-il maintenant ?',
          options: ['1729', '1728', '1730', '1731'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une classe possède 28 stylos rouges et 24 stylos bleus. Combien de stylos au total ?',
          options: ['51', '53', '52', '54'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un magasin vend 432 livres le matin et 567 l\'après-midi. Quel est le nombre total de livres vendus ?',
          options: ['999', '998', '1000', '997'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Le bus 1 transporte 245 passagers, le bus 2 en transporte 198. Combien de passagers ont voyagé ?',
          options: ['444', '442', '443', '445'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une bibliothèque contient 543 livres de contes et 257 livres d\'aventure. Combien de livres au total ?',
          options: ['799', '801', '800', '802'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un collège a 324 élèves en 6e et 476 en 5e. Combien d\'élèves dans ces deux classes ?',
          options: ['800', '799', '801', '802'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'L\'association collecte 512 jouets puis en reçoit 384 de plus. Combien de jouets au total ?',
          options: ['898', '895', '897', '896'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un agriculteur récolte 250 kg de pommes et 175 kg de poires. Quel est le poids total ?',
          options: ['425', '426', '427', '424'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'La boulangerie vend 399 baguettes ce matin et 601 cet après-midi. Combien en tout ?',
          options: ['1002', '999', '1001', '1000'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un supermarché enregistre 1000 ventes le lundi et 234 le mardi. Combien de ventes en tout ?',
          options: ['1233', '1235', '1234', '1236'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'La classe A récolte 789 pièces et la classe B 211 pièces. Combien de pièces en tout ?',
          options: ['1001', '999', '1002', '1000'],
          correctAnswer: 3
      ),
      // Exercices supplémentaires d'Addition
      Exercise(
          question: '3 450 + 1 670 = ?',
          options: ['5 120', '5 020', '5 110', '5 010'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une école achète 1 500 feuilles bleues et 850 feuilles jaunes. Combien de feuilles au total ?',
          options: ['2 340', '2 350', '2 450', '2 250'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Le prix d\'une télévision est 499 euros et celui d\'un lecteur DVD 129 euros. Prix total ?',
          options: ['628', '627', '638', '618'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un agriculteur a 950 moutons et 1050 vaches. Combien d\'animaux a-t-il au total ?',
          options: ['1 900', '2 100', '2 000', '2 050'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Le train parcourt 560 km puis 440 km. Quelle est la distance totale parcourue ?',
          options: ['900', '1 100', '1 000', '950'],
          correctAnswer: 2
      ),
      Exercise(
          question: '2 100 + 99 = ?',
          options: ['2 199', '2 201', '2 200', '2 198'],
          correctAnswer: 0
      ),
      Exercise(
          question: '1 250 + 750 = ?',
          options: ['1 900', '2 100', '2 000', '1 950'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'La population d\'un village est de 400 habitants. 15 nouveaux s\'installent. Nouvelle population ?',
          options: ['414', '416', '415', '417'],
          correctAnswer: 2
      ),
    ],
    'Soustraction': [
      Exercise(
          question: 'Un entrepôt avait 2 000 boîtes. Il en livre 1 234. Combien en reste-t-il ?',
          options: ['766', '765', '767', '768'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Julie a 980 perles. Elle en utilise 487. Combien lui en reste-t-il ?',
          options: ['492', '493', '491', '494'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un avion parcourt 1 500 km. Après 725 km, quelle distance reste-t-il ?',
          options: ['775', '774', '776', '777'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une piscine contenait 1 200 litres d\'eau. On en vide 843 litres. Combien reste-t-il ?',
          options: ['357', '356', '358', '359'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Thomas avait 870 billes. Il en a donné 395. Combien lui reste-t-il ?',
          options: ['476', '474', '475', '477'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un stock de 1 500 articles subit une perte de 436 unités. Combien reste-t-il ?',
          options: ['1063', '1064', '1065', '1066'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Le collège avait 1 720 élèves, 880 sont partis en sortie. Combien restent-ils ?',
          options: ['840', '841', '839', '842'],
          correctAnswer: 0
      ),
      Exercise(
          question: '999 élèves sont inscrits, 666 sont absents. Combien sont présents ?',
          options: ['333', '332', '334', '335'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une classe de 1 800 élèves, 900 partent en vacances. Combien restent-ils ?',
          options: ['902', '899', '901', '900'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Le magasin reçoit 720 produits, en vend 250. Combien restent-ils ?',
          options: ['470', '469', '471', '472'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un commerçant a 650 euros, il dépense 321 euros. Combien lui reste-t-il ?',
          options: ['330', '328', '329', '331'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'La bibliothèque a 545 livres, 123 sont empruntés. Combien restent-ils ?',
          options: ['422', '421', '423', '424'],
          correctAnswer: 0
      ),
      // Exercices supplémentaires de Soustraction
      Exercise(
          question: '4 000 - 1 500 = ?',
          options: ['2 400', '2 500', '2 600', '2 300'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un stade a 3 500 places. 1 875 sont déjà occupées. Combien de places restantes ?',
          options: ['1 625', '1 725', '1 600', '1 700'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une ville avait 5 000 habitants. 1 348 déménagent. Combien reste-t-il ?',
          options: ['3 652', '3 752', '3 552', '3 648'],
          correctAnswer: 0
      ),
      Exercise(
          question: '2 150 - 520 = ?',
          options: ['1 630', '1 730', '1 530', '1 430'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un arbre mesurait 250 cm. On coupe 75 cm. Quelle est sa nouvelle taille ?',
          options: ['175', '180', '165', '170'],
          correctAnswer: 0
      ),
      Exercise(
          question: '1 000 - 45 = ?',
          options: ['955', '965', '945', '950'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un jeu de 360 cartes en perd 105. Combien en reste-t-il ?',
          options: ['255', '265', '245', '275'],
          correctAnswer: 0
      ),
      Exercise(
          question: '524 - 180 = ?',
          options: ['344', '334', '354', '364'],
          correctAnswer: 1
      ),
    ],
    'Multiplication': [
      Exercise(
          question: 'Une boîte contient 35 bonbons, on en ouvre 4 boîtes. Combien de bonbons au total ?',
          options: ['139', '140', '141', '142'],
          correctAnswer: 1
      ),
      Exercise(
          question: '28 élèves sont répartis en 6 groupes de même taille. Combien d\'élèves par groupe ?',
          options: ['170', '167', '169', '168'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Dans un stade, il y a 14 rangées de 12 sièges. Combien de sièges au total ?',
          options: ['168', '167', '169', '170'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une ferme possède 25 cages avec 8 poules chacune. Combien de poules ?',
          options: ['199', '200', '201', '202'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un jardin a 19 rangées de 9 arbres. Combien d\'arbres ?',
          options: ['170', '171', '172', '173'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un parking a 33 places sur 3 étages. Combien de places ?',
          options: ['99', '98', '100', '101'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un élève lit 27 pages par jour pendant 6 jours. Combien de pages lues ?',
          options: ['161', '162', '163', '164'],
          correctAnswer: 1
      ),
      Exercise(
          question: '24 équipes participent à 7 matchs chacune. Combien de matchs au total ?',
          options: ['169', '167', '168', '170'],
          correctAnswer: 2
      ),
      Exercise(
          question: '13 boîtes contiennent 11 billes chacune. Combien de billes en tout ?',
          options: ['141', '143', '142', '144'],
          correctAnswer: 1
      ),
      Exercise(
          question: '12 classes travaillent chacune 12 chapitres. Combien de chapitres ?',
          options: ['143', '144', '145', '146'],
          correctAnswer: 1
      ),
      Exercise(
          question: '21 voitures transportent 5 enfants chacune. Combien d\'enfants ?',
          options: ['106', '104', '105', '107'],
          correctAnswer: 2
      ),
      Exercise(
          question: '18 équipes jouent 7 matchs. Combien de matchs au total ?',
          options: ['124', '126', '125', '127'],
          correctAnswer: 1
      ),
      // Exercices supplémentaires de Multiplication
      Exercise(
          question: 'Un carton contient 100 paquets de 10 mouchoirs. Combien de mouchoirs au total ?',
          options: ['100', '1 000', '10 000', '100 000'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un magasin vend 15 sacs de 20 billes. Combien de billes vendues ?',
          options: ['200', '300', '350', '250'],
          correctAnswer: 1
      ),
      Exercise(
          question: '16 x 5 = ?',
          options: ['70', '80', '90', '75'],
          correctAnswer: 1
      ),
      Exercise(
          question: '22 x 4 = ?',
          options: ['84', '88', '92', '96'],
          correctAnswer: 1
      ),
      Exercise(
          question: '10 enfants reçoivent chacun 12 autocollants. Combien d\'autocollants au total ?',
          options: ['110', '120', '130', '140'],
          correctAnswer: 1
      ),
      Exercise(
          question: '9 x 15 = ?',
          options: ['130', '135', '140', '145'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Le prix est de 2 euros. Si 50 personnes l\'achètent, quelle est la recette ?',
          options: ['90', '110', '100', '105'],
          correctAnswer: 2
      ),
      Exercise(
          question: '11 x 8 = ?',
          options: ['86', '98', '88', '96'],
          correctAnswer: 2
      ),
    ],
    'Division': [
      Exercise(
          question: '144 bonbons sont partagés entre 12 enfants. Combien chacun reçoit-il ?',
          options: ['11', '13', '12', '14'],
          correctAnswer: 2
      ),
      Exercise(
          question: '200 pages à lire en 10 jours. Combien de pages chaque jour ?',
          options: ['20', '19', '21', '22'],
          correctAnswer: 0
      ),
      Exercise(
          question: '168 élèves répartis en 6 classes. Combien par classe ?',
          options: ['29', '27', '30', '28'],
          correctAnswer: 3
      ),
      Exercise(
          question: '132 pommes dans 11 caisses. Combien de pommes par caisse ?',
          options: ['12', '11', '13', '14'],
          correctAnswer: 0
      ),
      Exercise(
          question: '210 stylos en 7 boîtes. Combien dans chaque boîte ?',
          options: ['33', '29', '31', '30'],
          correctAnswer: 3
      ),
      Exercise(
          question: '225 billes réparties dans 9 sacs. Combien de billes par sac ?',
          options: ['24', '25', '26', '27'],
          correctAnswer: 1
      ),
      Exercise(
          question: '90 bonbons à partager entre 5 enfants. Combien chacun ?',
          options: ['20', '17', '19', '18'],
          correctAnswer: 3
      ),
      Exercise(
          question: '300 fruits à répartir dans 3 paniers. Combien par panier ?',
          options: ['100', '101', '102', '103'],
          correctAnswer: 0
      ),
      Exercise(
          question: '121 billes à répartir dans 11 pots. Combien par pot ?',
          options: ['11', '10', '12', '13'],
          correctAnswer: 0
      ),
      Exercise(
          question: '72 jouets partagés entre 8 enfants. Combien chacun ?',
          options: ['8', '9', '10', '7'],
          correctAnswer: 1
      ),
      Exercise(
          question: '135 pages à lire en 9 jours. Combien de pages par jour ?',
          options: ['14', '15', '16', '17'],
          correctAnswer: 1
      ),
      Exercise(
          question: '270 billes à répartir dans 6 sacs. Combien de billes par sac ?',
          options: ['45', '44', '46', '47'],
          correctAnswer: 0
      ),
      // Exercices supplémentaires de Division
      Exercise(
          question: '480 g de farine pour 8 gâteaux. Combien de grammes par gâteau ?',
          options: ['50', '60', '70', '80'],
          correctAnswer: 1
      ),
      Exercise(
          question: '360 minutes à diviser en 6 films. Quelle est la durée moyenne d\'un film ?',
          options: ['55', '65', '60', '70'],
          correctAnswer: 2
      ),
      Exercise(
          question: '190 ÷ 5 = ?',
          options: ['36', '40', '38', '35'],
          correctAnswer: 2
      ),
      Exercise(
          question: '400 ÷ 8 = ?',
          options: ['40', '50', '60', '30'],
          correctAnswer: 1
      ),
      Exercise(
          question: '1 000 timbres à coller sur 100 enveloppes. Combien de timbres par enveloppe ?',
          options: ['10', '100', '1', '20'],
          correctAnswer: 0
      ),
      Exercise(
          question: '288 ÷ 12 = ?',
          options: ['22', '24', '26', '28'],
          correctAnswer: 1
      ),
      Exercise(
          question: '500 élèves répartis en 20 classes. Combien par classe ?',
          options: ['20', '25', '30', '15'],
          correctAnswer: 1
      ),
      Exercise(
          question: '320 ÷ 4 = ?',
          options: ['70', '90', '80', '60'],
          correctAnswer: 2
      ),
    ],
    'Géométrie': [
      Exercise(
          question: 'Quel est le périmètre d\'un carré de côté 8 cm ?',
          options: ['31', '32', '30', '33'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Combien d\'axes de symétrie a un cercle ?',
          options: ['0', '1', 'infini', '2'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Quel est le volume d\'un cube de 3 cm d\'arête ?',
          options: ['27', '29', '28', '30'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Combien de faces a un prisme rectangulaire ?',
          options: ['6', '7', '5', '8'],
          correctAnswer: 0 // Correction : un prisme rectangulaire (pavé droit) a 6 faces.
      ),
      Exercise(
          question: 'Combien d\'angles a un octogone ?',
          options: ['8', '9', '10', '7'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Combien de faces a un cube ?',
          options: ['7', '8', '6', '5'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de sommets a un prisme à base triangulaire ?',
          options: ['6', '4', '7', '5'],
          correctAnswer: 0 // Correction : un prisme à base triangulaire a 6 sommets (3 en haut, 3 en bas).
      ),
      Exercise(
          question: 'Combien de faces a un cylindre ?',
          options: ['2', '3', '4', '5'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Combien d\'arêtes a un cube ?',
          options: ['12', '13', '14', '15'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Combien de faces a une pyramide à base triangulaire ?',
          options: ['3', '4', '5', '6'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Combien de faces a un parallélépipède ?',
          options: ['6', '7', '8', '9'],
          correctAnswer: 0 // Correction : un parallélépipède a 6 faces.
      ),
      Exercise(
          question: 'Combien de sommets a un octogone ?',
          options: ['9', '10', '8', '11'],
          correctAnswer: 2
      ),
      // Exercices supplémentaires de Géométrie
      Exercise(
          question: 'Quel est le périmètre d\'un rectangle de 10 cm de long et 5 cm de large ?',
          options: ['30', '25', '35', '20'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'L\'aire d\'un carré de 5 cm de côté est de ... ?',
          options: ['10 cm²', '20 cm²', '25 cm²', '30 cm²'],
          correctAnswer: 2
      ),
      Exercise(
          question: '1 mètre équivaut à combien de centimètres ?',
          options: ['10', '100', '1 000', '10 000'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Quel est l\'aire d\'un rectangle de 8 cm de long et 4 cm de large ?',
          options: ['32 cm²', '24 cm²', '36 cm²', '12 cm²'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un triangle qui a deux côtés égaux est dit ... ?',
          options: ['Équilatéral', 'Rectangle', 'Scalène', 'Isocèle'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Quel est le périmètre d\'un triangle dont les côtés mesurent 5 cm, 7 cm et 9 cm ?',
          options: ['20 cm', '21 cm', '22 cm', '19 cm'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de millimètres y a-t-il dans 1 centimètre ?',
          options: ['10', '100', '1 000', '1'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un angle qui mesure moins de 90° est un angle ... ?',
          options: ['Droit', 'Obtus', 'Plat', 'Aigu'],
          correctAnswer: 3
      ),
    ],
  },
  'CM2': {
    'Addition': [
      Exercise(
          question: 'Une bibliothèque possède 2 345 livres. Elle en reçoit 1 978 de plus. Combien a-t-elle de livres maintenant ?',
          options: ['4322', '4324', '4323', '4325'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une société vend 8 465 articles en janvier et 9 874 en février. Combien d\'articles au total ?',
          options: ['18338', '18337', '18336', '18339'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une ville a 12 500 habitants en 2020 et 13 789 en 2021. Combien au total sur 2 ans ?',
          options: ['26287', '26289', '26288', '26290'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Marc lit 245 pages par semaine pendant 4 semaines. Combien de pages a-t-il lues ?',
          options: ['981', '979', '980', '982'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une école a 456 garçons et 389 filles. Combien d\'élèves en tout ?',
          options: ['846', '844', '847', '845'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un magasin reçoit 1 654 commandes puis 3 784 de plus. Combien de commandes au total ?',
          options: ['5439', '5437', '5438', '5440'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Paul possède 1 999 billes et en gagne 2 001. Combien possède-t-il maintenant ?',
          options: ['4000', '4002', '4003', '3999'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une entreprise distribue 2 450 colis puis 1 875 de plus. Combien de colis au total ?',
          options: ['4327', '4324', '4326', '4325'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une ferme récolte 3 000 pommes puis 1 200 poires. Combien de fruits au total ?',
          options: ['4202', '4200', '4201', '4199'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Une association collecte 7 000 jouets puis 2 999 autres. Quel est le total ?',
          options: ['10001', '9998', '9999', '10000'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un supermarché vend 9 800 produits puis 201 autres. Total vendu ?',
          options: ['10003', '10000', '10002', '10001'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une classe réunit 4 123 cahiers puis 987 de plus. Combien de cahiers en tout ?',
          options: ['5111', '5109', '5110', '5112'],
          correctAnswer: 2
      ),
      // Exercices supplémentaires d'Addition
      Exercise(
          question: '5 678 + 4 322 = ?',
          options: ['10 000', '9 990', '10 010', '9 900'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un pays compte 45 670 hommes et 51 230 femmes. Quelle est la population totale ?',
          options: ['96 900', '97 000', '96 800', '97 100'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un stock contient 15 000 vis, et on en ajoute 3 500. Combien de vis au total ?',
          options: ['18 500', '18 400', '17 500', '19 500'],
          correctAnswer: 0
      ),
      Exercise(
          question: '6 000 + 4 567 + 1 000 = ?',
          options: ['11 567', '11 667', '10 567', '11 467'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une voiture pèse 1 230 kg et son chargement 45 kg. Quel est le poids total ?',
          options: ['1 274', '1 275', '1 285', '1 265'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Le budget est de 18 900 € pour la construction et 5 600 € pour le matériel. Budget total ?',
          options: ['24 500', '23 500', '24 000', '25 000'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un athlète court 1 500 mètres puis 2 750 mètres. Distance totale ?',
          options: ['4 250', '4 300', '4 150', '4 200'],
          correctAnswer: 0
      ),
      Exercise(
          question: '10 000 + 999 = ?',
          options: ['10 999', '11 000', '10 900', '11 999'],
          correctAnswer: 0
      ),
    ],
    'Soustraction': [
      Exercise(
          question: 'Un avion parcourt 10 000 km. Après 6 789 km, combien reste-t-il à parcourir ?',
          options: ['3212', '3213', '3210', '3211'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une usine produit 5 000 pièces. Elle en livre 3 456. Combien de pièces restent ?',
          options: ['1543', '1544', '1545', '1546'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Julien avait 3 200 €. Il dépense 1 789 €. Combien lui reste-t-il ?',
          options: ['1412', '1411', '1413', '1410'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Une réserve contenait 8 000 litres d\'eau. On en a retiré 5 632. Combien reste-t-il ?',
          options: ['2370', '2369', '2367', '2368'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une école a 1 234 cahiers. 789 sont distribués. Combien restent-ils ?',
          options: ['444', '447', '445', '446'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une société a 5 000 employés, 3 278 partent à la retraite. Combien restent-ils ?',
          options: ['1721', '1724', '1722', '1723'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un magasin a 9 999 produits, 8 765 sont vendus. Combien restent-ils ?',
          options: ['1233', '1236', '1235', '1234'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'La ville comptait 9 876 habitants, 5 432 sont partis. Combien restent-ils ?',
          options: ['4446', '4445', '4447', '4444'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une entreprise avait 15 000 dossiers, 7 890 sont terminés. Combien en reste-t-il ?',
          options: ['7109', '7111', '7110', '7112'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une usine produit 20 000 pièces, 12 001 sont livrées. Combien en reste-t-il ?',
          options: ['8001', '8000', '7999', '7998'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un entrepôt a 8 000 colis, 1 234 partent. Combien reste-t-il ?',
          options: ['6768', '6767', '6766', '6765'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'L\'école avait 14 000 élèves, 4 567 changent d\'établissement. Combien restent-ils ?',
          options: ['9435', '9433', '9436', '9434'],
          correctAnswer: 1
      ),
      // Exercices supplémentaires de Soustraction
      Exercise(
          question: 'Un stock de 12 000 articles diminue de 4 500 unités. Combien en reste-t-il ?',
          options: ['7 500', '7 600', '7 400', '8 500'],
          correctAnswer: 0
      ),
      Exercise(
          question: '3 000 - 15 = ?',
          options: ['2 984', '2 985', '2 975', '2 995'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un budget de 25 000 € est réduit de 7 890 €. Quel est le nouveau budget ?',
          options: ['17 110', '17 210', '18 110', '17 010'],
          correctAnswer: 0
      ),
      Exercise(
          question: '9 750 - 4 321 = ?',
          options: ['5 428', '5 429', '5 439', '5 438'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'La distance totale est de 500 km. Après 198 km, combien reste-t-il ?',
          options: ['301', '302', '303', '300'],
          correctAnswer: 1
      ),
      Exercise(
          question: '1 000 - 543 = ?',
          options: ['457', '458', '467', '468'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Une somme de 12 500 € est donnée. Il en reste 6 250 € après un achat. Quel est le coût de l\'achat ?',
          options: ['6 350', '6 250', '6 150', '6 050'],
          correctAnswer: 1
      ),
      Exercise(
          question: '21 500 - 9 800 = ?',
          options: ['11 700', '11 600', '12 700', '11 500'],
          correctAnswer: 0
      ),
    ],
    'Multiplication': [
      Exercise(
          question: 'Une usine fabrique 125 caisses de 12 bouteilles chacune. Combien de bouteilles ?',
          options: ['1501', '1500', '1499', '1502'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un agriculteur récolte 84 cagettes contenant chacune 9 pommes. Combien de pommes ?',
          options: ['758', '757', '755', '756'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un commerçant vend 37 boîtes de 25 biscuits. Combien de biscuits au total ?',
          options: ['924', '925', '927', '926'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un garage reçoit 96 lots de 11 pneus chacun. Combien de pneus ?',
          options: ['1056', '1058', '1057', '1055'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un jardinier plante 63 rangées de 14 fleurs. Combien de fleurs ?',
          options: ['881', '884', '883', '882'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une école distribue 48 lots de 25 stylos. Combien de stylos au total ?',
          options: ['1200', '1199', '1201', '1202'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un élève écrit 99 mots sur 9 pages. Combien de mots au total ?',
          options: ['893', '892', '894', '891'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un ouvrier emballe 75 boîtes de 12 objets. Combien d\'objets ?',
          options: ['900', '901', '902', '899'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un cuisinier prépare 56 assiettes de 19 raviolis. Combien de raviolis ?',
          options: ['1065', '1063', '1064', '1066'],
          correctAnswer: 2
      ),
      Exercise(
          question: '33 équipes jouent 17 matchs chacune. Combien de matchs au total ?',
          options: ['560', '562', '561', '563'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Une classe écrit 81 phrases de 13 mots. Combien de mots ?',
          options: ['1052', '1054', '1055', '1053'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un boulanger vend 72 sachets de 11 pains. Combien de pains au total ?',
          options: ['793', '791', '792', '794'],
          correctAnswer: 2
      ),
      // Exercices supplémentaires de Multiplication
      Exercise(
          question: '300 boîtes de 50 trombones. Combien de trombones ?',
          options: ['15 000', '1 500', '150 000', '1 500 000'],
          correctAnswer: 0
      ),
      Exercise(
          question: '150 x 20 = ?',
          options: ['3 000', '300', '3 500', '30 000'],
          correctAnswer: 0
      ),
      Exercise(
          question: '25 x 44 = ?',
          options: ['1 100', '1 000', '1 200', '1 150'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un mur est fait de 50 rangées de 35 briques. Combien de briques ?',
          options: ['1 750', '1 800', '1 650', '1 700'],
          correctAnswer: 0
      ),
      Exercise(
          question: '100 x 99 = ?',
          options: ['990', '9900', '9 990', '9090'],
          correctAnswer: 1
      ),
      Exercise(
          question: '14 x 15 = ?',
          options: ['200', '210', '220', '230'],
          correctAnswer: 1
      ),
      Exercise(
          question: '60 boîtes de 12 stylos. Combien de stylos au total ?',
          options: ['700', '710', '720', '730'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Un magasin vend 24 produits à 50 € chacun. Quelle est la recette ?',
          options: ['1 200', '1 100', '1 250', '1 150'],
          correctAnswer: 0
      ),
    ],
    'Division': [
      Exercise(
          question: '1 440 litres répartis en 12 barils. Combien de litres par baril ?',
          options: ['119', '120', '122', '121'],
          correctAnswer: 1
      ),
      Exercise(
          question: '256 pages à lire en 8 jours. Combien de pages chaque jour ?',
          options: ['33', '34', '32', '31'],
          correctAnswer: 2
      ),
      Exercise(
          question: '735 élèves répartis en 15 classes. Combien par classe ?',
          options: ['48', '46', '47', '49'],
          correctAnswer: 0
      ),
      Exercise(
          question: '1 020 pommes pour 12 paniers. Combien par panier ?',
          options: ['87', '84', '86', '85'],
          correctAnswer: 3
      ),
      Exercise(
          question: '560 stylos pour 10 boîtes. Combien dans chaque boîte ?',
          options: ['57', '55', '56', '58'],
          correctAnswer: 2
      ),
      Exercise(
          question: '990 gâteaux à partager entre 15 enfants. Combien chacun ?',
          options: ['65', '63', '64', '66'],
          correctAnswer: 3
      ),
      Exercise(
          question: '888 pages à lire sur 12 jours. Combien par jour ?',
          options: ['76', '75', '74', '73'],
          correctAnswer: 2
      ),
      Exercise(
          question: '144 bonbons à répartir entre 8 enfants. Combien chacun ?',
          options: ['17', '19', '18', '16'],
          correctAnswer: 2
      ),
      Exercise(
          question: '1 332 billes à ranger dans 12 boîtes. Combien par boîte ?',
          options: ['112', '110', '111', '113'],
          correctAnswer: 2
      ),
      Exercise(
          question: '1 210 élèves répartis dans 11 classes. Combien par classe ?',
          options: ['111', '112', '110', '109'],
          correctAnswer: 2
      ),
      Exercise(
          question: '2 250 pages à lire en 25 jours. Combien de pages par jour ?',
          options: ['91', '90', '92', '89'],
          correctAnswer: 1
      ),
      Exercise(
          question: '1 568 bonbons à partager entre 14 enfants. Combien chacun ?',
          options: ['110', '113', '112', '111'],
          correctAnswer: 2
      ),
      // Exercices supplémentaires de Division
      Exercise(
          question: '3 600 secondes à partager entre 6 personnes. Combien chacun ?',
          options: ['60', '600', '6', '6000'],
          correctAnswer: 1
      ),
      Exercise(
          question: '1 250 € à répartir entre 25 gagnants. Combien chacun ?',
          options: ['40', '50', '60', '70'],
          correctAnswer: 1
      ),
      Exercise(
          question: '4 000 ÷ 100 = ?',
          options: ['40', '400', '4', '4 000'],
          correctAnswer: 0
      ),
      Exercise(
          question: '945 ÷ 9 = ?',
          options: ['105', '115', '106', '110'],
          correctAnswer: 0
      ),
      Exercise(
          question: '1 000 crayons à diviser en 40 lots. Combien de crayons par lot ?',
          options: ['20', '25', '30', '15'],
          correctAnswer: 1
      ),
      Exercise(
          question: '550 ÷ 50 = ?',
          options: ['12', '10', '11', '13'],
          correctAnswer: 2
      ),
      Exercise(
          question: '1 600 élèves à répartir dans 32 classes. Combien par classe ?',
          options: ['40', '50', '60', '30'],
          correctAnswer: 1
      ),
      Exercise(
          question: '2 100 ÷ 7 = ?',
          options: ['30', '300', '3 000', '3'],
          correctAnswer: 1
      ),
    ],
    'Géométrie': [
      Exercise(
          question: 'Quel est l\'aire d\'un rectangle de 12 cm x 15 cm ?',
          options: ['181', '180', '179', '182'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Combien d\'arêtes a un cube ?',
          options: ['11', '13', '12', '14'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Quel solide a une base circulaire et une pointe ?',
          options: ['Cylindre', 'Pyramide', 'Cône', 'Cube'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de sommets a une pyramide à base carrée ?',
          options: ['4', '6', '7', '5'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Un hexagone régulier a combien d\'axes de symétrie ?',
          options: ['4', '7', '6', '5'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de faces a un tétraèdre ?',
          options: ['3', '5', '4', '6'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de côtés a un décagone ?',
          options: ['12', '11', '10', '9'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de faces a un cube ?',
          options: ['8', '9', '6', '7'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de sommets a un prisme à base carrée ?',
          options: ['9', '10', '8', '11'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de faces a un pavé droit ?',
          options: ['10', '8', '6', '12'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de sommets a un octogone ?',
          options: ['11', '10', '8', '9'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Combien de faces a un prisme hexagonal ?',
          options: ['8', '12', '10', '14'],
          correctAnswer: 0 // Correction : un prisme hexagonal a 2 bases (hexagones) + 6 faces latérales (rectangles) = 8 faces.
      ),
      // Exercices supplémentaires de Géométrie
      Exercise(
          question: 'Quel est le volume d\'un pavé droit de 5 cm x 4 cm x 3 cm ?',
          options: ['60 cm³', '50 cm³', '65 cm³', '70 cm³'],
          correctAnswer: 0
      ),
      Exercise(
          question: '1 litre équivaut à combien de millilitres ?',
          options: ['10', '100', '1 000', '10 000'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'L\'aire d\'un triangle dont la base mesure 10 cm et la hauteur 8 cm est de ... ?',
          options: ['40 cm²', '80 cm²', '18 cm²', '20 cm²'],
          correctAnswer: 0 // Aire = (base x hauteur) / 2
      ),
      Exercise(
          question: 'Quelle est la formule du périmètre d\'un carré de côté c ?',
          options: ['c x c', 'c / 4', 'c + 4', '4 x c'],
          correctAnswer: 3
      ),
      Exercise(
          question: '1 kilomètre équivaut à combien de mètres ?',
          options: ['100', '1 000', '10 000', '10'],
          correctAnswer: 1
      ),
      Exercise(
          question: 'Un angle qui mesure plus de 90° est un angle ... ?',
          options: ['Aigu', 'Droit', 'Obtus', 'Plat'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Quel solide a une base carrée et quatre faces triangulaires ?',
          options: ['Prisme', 'Cube', 'Pyramide', 'Cylindre'],
          correctAnswer: 2
      ),
    ],
  },

  //COLEGES

  '6ème': {
    'Nombres Relatifs': [
      // En 6ème, on commence l'introduction ou on travaille les décimaux/comparaisons
      Exercise(question: 'Quel nombre est le plus grand ?', options: ['12,4', '12,39', '12,04', '12,41'], correctAnswer: 3),
      Exercise(question: 'Quel est l\'entier le plus proche de 9,8 ?', options: ['9', '10', '11', '8'], correctAnswer: 1),
      Exercise(question: 'Quel signe convient : 4,5 ... 4,50 ?', options: ['<', '>', '=', '≠'], correctAnswer: 2),
      Exercise(question: 'Quelle est la température la plus froide ?', options: ['2°C', '-5°C', '0°C', '-1°C'], correctAnswer: 1),
      Exercise(question: 'Ranger dans l\'ordre croissant : 3; -2; 0', options: ['0; -2; 3', '-2; 0; 3', '3; 0; -2', '-2; 3; 0'], correctAnswer: 1),
      Exercise(question: 'L\'opposé de 5 est...', options: ['0', '5', '-5', '1/5'], correctAnswer: 2),
      Exercise(question: 'L\'opposé de -2,5 est...', options: ['2,5', '-2,5', '0', '25'], correctAnswer: 0),
      Exercise(question: 'Sur une droite graduée, où est -3 par rapport à 0 ?', options: ['À droite', 'À gauche', 'Au même endroit', 'En haut'], correctAnswer: 1),
      Exercise(question: 'Quel nombre est entre -2 et 1 ?', options: ['-3', '-1', '2', '-4'], correctAnswer: 1),
      Exercise(question: 'Combien y a-t-il de nombres entiers entre -1,5 et 2,5 ?', options: ['2', '3', '4', '5'], correctAnswer: 2), // -1, 0, 1, 2
      Exercise(question: 'La distance à zéro de -4 est...', options: ['-4', '4', '0', '0,4'], correctAnswer: 1),
      Exercise(question: 'Calculer : 5 - 12 = ?', options: ['7', '-7', '17', '-17'], correctAnswer: 1),
      Exercise(question: 'Quel est le signe de -3 + (-5) ?', options: ['Positif', 'Négatif', 'Nul', 'Impossible'], correctAnswer: 1),
      Exercise(question: 'Un ascenseur descend de 3 étages depuis le 1er. Il est au...', options: ['-1', '-2', '0', '-3'], correctAnswer: 1),
      Exercise(question: 'Intercaler un nombre : 6,1 < ... < 6,2', options: ['6,05', '6,15', '6,25', '6,10'], correctAnswer: 1),
    ],
    'Fractions': [
      Exercise(question: 'Quelle fraction représente la moitié ?', options: ['1/3', '1/4', '1/2', '2/3'], correctAnswer: 2),
      Exercise(question: 'Dans 3/4, quel est le numérateur ?', options: ['3', '4', '7', '1'], correctAnswer: 0),
      Exercise(question: '0,5 est égal à la fraction...', options: ['1/5', '1/2', '5/100', '5/1'], correctAnswer: 1),
      Exercise(question: '3/4 est égal à...', options: ['0,34', '0,75', '3,4', '0,5'], correctAnswer: 1),
      Exercise(question: '1/4 de 20, c\'est...', options: ['4', '5', '10', '8'], correctAnswer: 1),
      Exercise(question: 'Quelle fraction est égale à 1 ?', options: ['1/2', '4/4', '2/3', '0/1'], correctAnswer: 1),
      Exercise(question: 'Si je mange 1/3 du gâteau, combien reste-t-il ?', options: ['1/3', '2/3', '3/3', '0'], correctAnswer: 1),
      Exercise(question: '10/2 est égal à...', options: ['2', '10', '5', '20'], correctAnswer: 2),
      Exercise(question: 'Quelle fraction est plus grande que 1 ?', options: ['1/2', '3/4', '5/4', '2/3'], correctAnswer: 2),
      Exercise(question: 'Simplifie la fraction 2/4.', options: ['1/3', '1/2', '1/4', '2/2'], correctAnswer: 1),
      Exercise(question: 'Combien de quarts pour faire 2 unités ?', options: ['4', '6', '8', '2'], correctAnswer: 2),
      Exercise(question: '1/10 s\'écrit en décimal...', options: ['0,1', '0,01', '1,0', '10'], correctAnswer: 0),
      Exercise(question: 'Trois demis s\'écrit...', options: ['3/1', '1/3', '3/2', '2/3'], correctAnswer: 2),
      Exercise(question: 'Quel est le tiers de 27 ?', options: ['7', '8', '9', '10'], correctAnswer: 2),
      Exercise(question: '20/100 s\'écrit...', options: ['0,2', '0,02', '2', '20'], correctAnswer: 0),
    ],
    'Algèbre': [
      // Introduction à l'algèbre : trous et formules
      Exercise(question: 'Trouve le nombre manquant : ? + 5 = 12', options: ['6', '7', '8', '5'], correctAnswer: 1),
      Exercise(question: 'Trouve le nombre manquant : 3 x ? = 15', options: ['4', '5', '6', '3'], correctAnswer: 1),
      Exercise(question: 'Si a = 3, combien vaut a + 4 ?', options: ['6', '7', '8', '34'], correctAnswer: 1),
      Exercise(question: 'La formule du périmètre d\'un carré de côté c est...', options: ['c x c', '4 x c', 'c + 4', '2 x c'], correctAnswer: 1),
      Exercise(question: '15 - ? = 8', options: ['7', '6', '8', '9'], correctAnswer: 0),
      Exercise(question: 'Le double de x s\'écrit...', options: ['x + 2', 'x x 2', 'x - 2', 'x / 2'], correctAnswer: 1),
      Exercise(question: 'Si y = 10, que vaut y ÷ 2 ?', options: ['2', '5', '10', '20'], correctAnswer: 1),
      Exercise(question: 'Que vaut 2 x a si a = 5 ?', options: ['7', '10', '25', '52'], correctAnswer: 1),
      Exercise(question: 'Complète : 10 x ... = 100', options: ['10', '100', '1', '0'], correctAnswer: 0),
      Exercise(question: 'Quel est le périmètre d\'un rectangle (L=5, l=2) ?', options: ['7', '10', '14', '20'], correctAnswer: 2),
      Exercise(question: 'L\'expression "la somme de x et 3" s\'écrit...', options: ['x - 3', 'x x 3', 'x + 3', 'x / 3'], correctAnswer: 2),
      Exercise(question: 'Si x = 2, alors 3 + x = ?', options: ['4', '5', '6', '32'], correctAnswer: 1),
      Exercise(question: 'Trouve z : z - 4 = 6', options: ['2', '4', '10', '24'], correctAnswer: 2),
      Exercise(question: 'Quel nombre multiplié par 4 donne 20 ?', options: ['4', '5', '6', '16'], correctAnswer: 1),
      Exercise(question: 'La moitié de x s\'écrit...', options: ['x - 2', 'x x 2', 'x / 2', '2 - x'], correctAnswer: 2),
    ],
    'Puissances': [
      // Introduction : Carrés et puissances de 10
      Exercise(question: 'Comment s\'écrit 5 au carré ?', options: ['5 x 2', '5 + 5', '5²', '2⁵'], correctAnswer: 2),
      Exercise(question: 'Que vaut 3² (3 au carré) ?', options: ['6', '9', '3', '5'], correctAnswer: 1),
      Exercise(question: 'Que vaut 10² ?', options: ['20', '100', '200', '10'], correctAnswer: 1),
      Exercise(question: 'L\'aire d\'un carré de 4 cm est...', options: ['8 cm²', '12 cm²', '16 cm²', '4 cm²'], correctAnswer: 2),
      Exercise(question: '10 x 10 x 10 s\'écrit...', options: ['10³', '30', '3¹⁰', '100'], correctAnswer: 0),
      Exercise(question: 'Que vaut 2³ (2 cube) ?', options: ['6', '8', '4', '9'], correctAnswer: 1),
      Exercise(question: 'Un million c\'est 10 puissance...', options: ['3', '6', '9', '12'], correctAnswer: 1),
      Exercise(question: '4² = ?', options: ['8', '12', '16', '6'], correctAnswer: 2),
      Exercise(question: 'Quelle unité est une aire ?', options: ['cm', 'cm²', 'cm³', 'kg'], correctAnswer: 1),
      Exercise(question: '1 m² est égal à...', options: ['100 cm²', '10 000 cm²', '10 cm²', '1 000 cm²'], correctAnswer: 1),
      Exercise(question: '5 x 5 s\'écrit aussi...', options: ['5²', '5 x 2', '2⁵', '10'], correctAnswer: 0),
      Exercise(question: 'Quel nombre est un carré parfait ?', options: ['20', '24', '25', '30'], correctAnswer: 2),
      Exercise(question: '10³ est égal à...', options: ['30', '100', '1000', '300'], correctAnswer: 2),
      Exercise(question: 'Le carré de 1 est...', options: ['1', '2', '0', '11'], correctAnswer: 0),
      Exercise(question: '6² = ?', options: ['12', '36', '18', '24'], correctAnswer: 1),
    ],
    'Théorèmes': [
      // En 6ème, ce sont les propriétés géométriques (Droites, Angles, Figures)
      Exercise(question: 'Deux droites qui ne se coupent jamais sont...', options: ['Sécantes', 'Perpendiculaires', 'Parallèles', 'Confondues'], correctAnswer: 2),
      Exercise(question: 'Deux droites formant un angle droit sont...', options: ['Parallèles', 'Perpendiculaires', 'Alignées', 'Courbes'], correctAnswer: 1),
      Exercise(question: 'La somme des angles d\'un triangle est...', options: ['90°', '100°', '180°', '360°'], correctAnswer: 2),
      Exercise(question: 'Un triangle avec 3 côtés égaux est...', options: ['Isocèle', 'Rectangle', 'Équilatéral', 'Quelconque'], correctAnswer: 2),
      Exercise(question: 'Un angle de 90° est un angle...', options: ['Aigu', 'Obtus', 'Droit', 'Plat'], correctAnswer: 2),
      Exercise(question: 'Un quadrilatère avec 4 angles droits est un...', options: ['Losange', 'Trapèze', 'Rectangle', 'Triangle'], correctAnswer: 2),
      Exercise(question: 'La médiatrice d\'un segment passe par son...', options: ['Milieu', 'Sommet', 'Extrémité', 'Tiers'], correctAnswer: 0),
      Exercise(question: 'La médiatrice est ... au segment.', options: ['Parallèle', 'Perpendiculaire', 'Égale', 'Sécante'], correctAnswer: 1),
      Exercise(question: 'Un cercle se trace avec un...', options: ['Règle', 'Équerre', 'Compas', 'Rapporteur'], correctAnswer: 2),
      Exercise(question: 'Le plus grand côté d\'un triangle rectangle est...', options: ['L\'hypoténuse', 'La cathète', 'Le rayon', 'La hauteur'], correctAnswer: 0),
      Exercise(question: 'La corde passant par le centre est le...', options: ['Rayon', 'Diamètre', 'Arc', 'Sommet'], correctAnswer: 1),
      Exercise(question: 'Deux angles opposés par le sommet sont...', options: ['Égaux', 'Complémentaires', 'Différents', 'Droits'], correctAnswer: 0),
      Exercise(question: 'Pour mesurer un angle, on utilise un...', options: ['Compas', 'Règle', 'Rapporteur', 'Équerre'], correctAnswer: 2),
      Exercise(question: 'Un angle inférieur à 90° est...', options: ['Aigu', 'Obtus', 'Droit', 'Plat'], correctAnswer: 0),
      Exercise(question: 'Un triangle avec 2 côtés égaux est...', options: ['Isocèle', 'Équilatéral', 'Rectangle', 'Scalène'], correctAnswer: 0),
    ],
    'Statistiques': [
      Exercise(question: 'Dans un tableau, les données sont en...', options: ['Lignes et colonnes', 'Cercles', 'Diagonales', 'Vagues'], correctAnswer: 0),
      Exercise(question: 'Quel graphique utilise des barres ?', options: ['Circulaire', 'Diagramme en bâtons', 'Courbe', 'Tableau'], correctAnswer: 1),
      Exercise(question: 'Pour représenter des parts, on utilise un...', options: ['Diagramme circulaire', 'Tableau', 'Axe', 'Texte'], correctAnswer: 0),
      Exercise(question: 'Si j\'ai 2 chats et 3 chiens, l\'effectif total est...', options: ['2', '3', '5', '6'], correctAnswer: 2),
      Exercise(question: 'Dans la série 2, 5, 2, 8, quel est l\'effectif de 2 ?', options: ['1', '2', '3', '4'], correctAnswer: 1),
      Exercise(question: 'Une fréquence s\'exprime souvent en...', options: ['Kg', 'Mètres', 'Pourcentage', 'Degrés'], correctAnswer: 2),
      Exercise(question: 'Sur un axe, l\'origine est le point...', options: ['1', '10', '0', '100'], correctAnswer: 2),
      Exercise(question: 'Si 50% des élèves aiment le bleu, cela fait...', options: ['La moitié', 'Le quart', 'Tout le monde', 'Personne'], correctAnswer: 0),
      Exercise(question: 'Dans un diagramme, la hauteur de la barre indique...', options: ['La couleur', 'L\'effectif', 'Le nom', 'La date'], correctAnswer: 1),
      Exercise(question: 'Quel outil sert à lire des données ?', options: ['Une légende', 'Un compas', 'Une équerre', 'Une gomme'], correctAnswer: 0),
      Exercise(question: 'Si 10 élèves sur 20 portent des lunettes, la fraction est...', options: ['1/4', '1/2', '1/3', '1/10'], correctAnswer: 1),
      Exercise(question: 'Un tableau à double entrée se lit en croisant...', options: ['Ligne et colonne', 'Haut et bas', 'Droite et gauche', 'Nord et Sud'], correctAnswer: 0),
      Exercise(question: 'L\'effectif total est la somme de...', options: ['Toutes les valeurs', 'Tous les effectifs', 'Toutes les lignes', 'Toutes les colonnes'], correctAnswer: 1),
      Exercise(question: 'La donnée la plus fréquente s\'appelle...', options: ['Le mode', 'La moyenne', 'L\'écart', 'Le total'], correctAnswer: 0),
      Exercise(question: 'Pour comparer des évolutions, on utilise une...', options: ['Courbe', 'Camembert', 'Barre', 'Liste'], correctAnswer: 0),
    ],
  },

  '5ème': {
    'Nombres Relatifs': [
      Exercise(question: 'Calculer : (-5) + (-3) = ?', options: ['-8', '-2', '8', '2'], correctAnswer: 0),
      Exercise(question: 'Calculer : (-4) + (+7) = ?', options: ['-3', '3', '-11', '11'], correctAnswer: 1),
      Exercise(question: 'La somme de deux nombres négatifs est...', options: ['Toujours positive', 'Toujours négative', 'Nulle', 'Ça dépend'], correctAnswer: 1),
      Exercise(question: 'Calculer : 12 - 15 = ?', options: ['3', '-3', '27', '-27'], correctAnswer: 1),
      Exercise(question: 'Quel est le signe de (-3) + (-3) + (-3) ?', options: ['Positif', 'Négatif', 'Nul', 'Impossible'], correctAnswer: 1),
      Exercise(question: 'Soustraire un nombre revient à...', options: ['Ajouter son opposé', 'Soustraire son opposé', 'Multiplier par -1', 'Diviser par 2'], correctAnswer: 0),
      Exercise(question: 'Calculer : (-6) - (-2) = ?', options: ['-8', '-4', '4', '8'], correctAnswer: 1),
      Exercise(question: 'Quelle est la distance entre -3 et +2 sur une droite ?', options: ['1', '5', '-5', '-1'], correctAnswer: 1),
      Exercise(question: 'Le point A(-2; 3) est dans quel cadran ?', options: ['Haut-Gauche', 'Haut-Droite', 'Bas-Gauche', 'Bas-Droite'], correctAnswer: 0),
      Exercise(question: 'Calculer : 5 - 12 + 2 = ?', options: ['-5', '-9', '9', '5'], correctAnswer: 0),
      Exercise(question: '(-10) + (+10) = ?', options: ['20', '-20', '0', '100'], correctAnswer: 2),
      Exercise(question: 'Quel nombre est inférieur à -5 ?', options: ['-4', '-6', '0', '5'], correctAnswer: 1),
      Exercise(question: 'Calculer : -8 + 15 = ?', options: ['7', '-7', '23', '-23'], correctAnswer: 0),
      Exercise(question: 'L\'abscisse de l\'origine est...', options: ['1', '0', '-1', '10'], correctAnswer: 1),
      Exercise(question: 'Si il fait -2°C et que la température baisse de 3°C, il fait...', options: ['-5°C', '1°C', '-1°C', '5°C'], correctAnswer: 0),
    ],
    'Fractions': [
      Exercise(question: 'Pour additionner deux fractions, il faut...', options: ['Le même numérateur', 'Le même dénominateur', 'Multiplier en croix', 'Rien faire'], correctAnswer: 1),
      Exercise(question: 'Calculer : 2/5 + 1/5 = ?', options: ['3/10', '3/5', '2/25', '1/5'], correctAnswer: 1),
      Exercise(question: 'Comparaison : 3/4 ... 1/2', options: ['<', '>', '=', '≠'], correctAnswer: 1),
      Exercise(question: 'Calculer : 7/8 - 3/8 = ?', options: ['4/0', '4/8', '10/8', '4/16'], correctAnswer: 1),
      Exercise(question: 'Simplifier 4/8 donne...', options: ['1/2', '2/8', '1/4', '4/2'], correctAnswer: 0),
      Exercise(question: '5/3 est une fraction...', options: ['Inférieure à 1', 'Supérieure à 1', 'Égale à 1', 'Nulle'], correctAnswer: 1),
      Exercise(question: 'Quelle fraction est égale à 3 ?', options: ['1/3', '3/3', '9/3', '6/3'], correctAnswer: 2),
      Exercise(question: '4 x 2/3 = ?', options: ['8/3', '6/3', '8/12', '4/3'], correctAnswer: 0),
      Exercise(question: 'Dans 7/9, 9 est le...', options: ['Numérateur', 'Dénominateur', 'Quotient', 'Produit'], correctAnswer: 1),
      Exercise(question: 'Quel est le double de 1/4 ?', options: ['1/8', '2/8', '1/2', '2/2'], correctAnswer: 2),
      Exercise(question: '3/10 + 4/10 = ?', options: ['7/20', '7/100', '7/10', '12/10'], correctAnswer: 2),
      Exercise(question: '9/4 = ? (en décimal)', options: ['2,25', '2,5', '2,4', '2,9'], correctAnswer: 0),
      Exercise(question: 'Trouver l\'intrus : 1/2, 5/10, 0.5, 2/5', options: ['1/2', '5/10', '0.5', '2/5'], correctAnswer: 3),
      Exercise(question: 'Pour avoir 1 avec des tiers, il en faut...', options: ['1', '2', '3', '4'], correctAnswer: 2),
      Exercise(question: '1 - 1/4 = ?', options: ['0', '3/4', '1/4', '4/3'], correctAnswer: 1),
    ],
    'Algèbre': [
      // Calcul littéral : Simplification et Distributivité simple k(a+b)
      Exercise(question: 'Simplifier : 2a + 3a', options: ['5a', '6a', '5a²', '6a²'], correctAnswer: 0),
      Exercise(question: 'Que signifie 3x ?', options: ['3 + x', '3 fois x', '3 divisé par x', '3 puissance x'], correctAnswer: 1),
      Exercise(question: 'Calculer 2x + 1 pour x = 3', options: ['6', '5', '7', '24'], correctAnswer: 2),
      Exercise(question: 'Simplifier : 5b - 2b', options: ['3', '3b', '7b', '3b²'], correctAnswer: 1),
      Exercise(question: 'Développer : 3(x + 2)', options: ['3x + 2', '3x + 6', 'x + 5', '3x + 5'], correctAnswer: 1),
      Exercise(question: 'Quelle égalité est vraie ?', options: ['2(a+b) = 2a+2b', '2(a+b) = 2a+b', '2(a+b) = a+2b', '2(a+b) = 2a+2'], correctAnswer: 0),
      Exercise(question: 'Simplifier : a x a', options: ['2a', 'a²', 'a+a', '0'], correctAnswer: 1),
      Exercise(question: 'Si 4x = 20, alors x = ?', options: ['4', '5', '16', '80'], correctAnswer: 1),
      Exercise(question: 'L\'expression "la différence de y et 5" est...', options: ['y + 5', '5 - y', 'y - 5', 'y / 5'], correctAnswer: 2),
      Exercise(question: 'Simplifier : 4 x y', options: ['4 + y', '4y', 'xy4', 'y4'], correctAnswer: 1),
      Exercise(question: 'Tester l\'égalité 2x = 10 pour x = 4', options: ['Vraie', 'Fausse', 'On ne sait pas', 'Impossible'], correctAnswer: 1),
      Exercise(question: 'Factoriser : 5x + 5y', options: ['5(x+y)', 'x(5+y)', '5xy', '10(x+y)'], correctAnswer: 0),
      Exercise(question: 'Simplifier : 3a + 2b + a', options: ['6ab', '4a + 2b', '3a + 2b', '5ab'], correctAnswer: 1),
      Exercise(question: 'Le périmètre d\'un rectangle (L, l) est...', options: ['L x l', '2L + 2l', 'L + l', '2 x L x l'], correctAnswer: 1),
      Exercise(question: 'Que vaut 0 x a ?', options: ['a', '0', '1', 'Impossible'], correctAnswer: 1),
    ],
    'Puissances': [
      // En 5ème on renforce les carrés et les priorités opératoires (PEMDAS)
      Exercise(question: 'Dans 3 + 4 x 2, on commence par...', options: ['L\'addition', 'La multiplication', 'De gauche à droite', 'Au choix'], correctAnswer: 1),
      Exercise(question: 'Calculer : 10 - 3 x 2', options: ['14', '4', '7', '2'], correctAnswer: 1),
      Exercise(question: 'Calculer : (2 + 3) x 4', options: ['14', '20', '9', '24'], correctAnswer: 1),
      Exercise(question: 'Le carré de 6 est...', options: ['12', '36', '3', '18'], correctAnswer: 1),
      Exercise(question: '9 est le carré de...', options: ['3', '4', '2', '81'], correctAnswer: 0),
      Exercise(question: 'Calculer : 5² - 10', options: ['0', '15', '-5', '5'], correctAnswer: 1),
      Exercise(question: '20 / (2 + 3) = ?', options: ['13', '4', '7', '10'], correctAnswer: 1),
      Exercise(question: 'Quelle opération est prioritaire ?', options: ['Addition', 'Soustraction', 'Parenthèses', 'Multiplication'], correctAnswer: 2),
      Exercise(question: '8² = ?', options: ['16', '64', '18', '88'], correctAnswer: 1),
      Exercise(question: 'Calculer : 2 + 2 x 2', options: ['8', '6', '4', '2'], correctAnswer: 1),
      Exercise(question: '10³ signifie...', options: ['10 x 3', '10 + 10 + 10', '10 x 10 x 10', '30'], correctAnswer: 2),
      Exercise(question: 'Le cube de 2 est...', options: ['6', '8', '4', '2'], correctAnswer: 1),
      Exercise(question: '100 est le carré de...', options: ['50', '10', '20', '5'], correctAnswer: 1),
      Exercise(question: '5 x (10 - 2) = ?', options: ['48', '40', '50', '8'], correctAnswer: 1),
      Exercise(question: '11² = ?', options: ['22', '121', '111', '112'], correctAnswer: 1),
    ],
    'Théorèmes': [
      // Géométrie 5ème : Angles, Triangles, Symétrie centrale
      Exercise(question: 'La somme des angles d\'un triangle vaut...', options: ['90°', '180°', '360°', '100°'], correctAnswer: 1),
      Exercise(question: 'Dans un triangle, si deux angles font 60° et 40°, le troisième fait...', options: ['100°', '80°', '90°', '20°'], correctAnswer: 1),
      Exercise(question: 'La symétrie centrale conserve...', options: ['Seulement les longueurs', 'Seulement les angles', 'Tout (longueurs, angles, aires)', 'Rien'], correctAnswer: 2),
      Exercise(question: 'Le symétrique d\'un segment par rapport à un point est...', options: ['Un segment parallèle et de même longueur', 'Un segment perpendiculaire', 'Une droite', 'Un point'], correctAnswer: 0),
      Exercise(question: 'Inégalité triangulaire : Pour tracer un triangle ABC, il faut que...', options: ['AB + BC = AC', 'AB + BC > AC', 'AB + BC < AC', 'AB = AC'], correctAnswer: 1),
      Exercise(question: 'Un triangle avec un angle de 90° est...', options: ['Rectangle', 'Équilatéral', 'Isocèle', 'Aigu'], correctAnswer: 0),
      Exercise(question: 'Un triangle avec deux angles égaux est...', options: ['Rectangle', 'Quelconque', 'Isocèle', 'Équilatéral'], correctAnswer: 2),
      Exercise(question: 'Peut-on tracer un triangle de côtés 2cm, 3cm, 6cm ?', options: ['Oui', 'Non', 'Seulement en rouge', 'Je ne sais pas'], correctAnswer: 1),
      Exercise(question: 'Le centre de symétrie d\'un parallélogramme est...', options: ['Un sommet', 'Le milieu des diagonales', 'N\'importe où', 'Sur un côté'], correctAnswer: 1),
      Exercise(question: 'Deux angles alternes-internes formés par des droites parallèles sont...', options: ['Complémentaires', 'Supplémentaires', 'Égaux', 'Opposés'], correctAnswer: 2),
      Exercise(question: 'Le symétrique d\'un cercle par rapport à un point est...', options: ['Un cercle de même rayon', 'Un carré', 'Un point', 'Une droite'], correctAnswer: 0),
      Exercise(question: 'Un quadrilatère dont les diagonales se coupent en leur milieu est un...', options: ['Trapèze', 'Cerf-volant', 'Parallélogramme', 'Triangle'], correctAnswer: 2),
      Exercise(question: 'La hauteur d\'un triangle passe par un sommet et est...', options: ['Parallèle au côté opposé', 'Perpendiculaire au côté opposé', 'Au milieu du côté', 'Égale au côté'], correctAnswer: 1),
      Exercise(question: 'Si un triangle est équilatéral, ses angles valent...', options: ['90°', '45°', '60°', '30°'], correctAnswer: 2),
      Exercise(question: 'Dans un triangle isocèle, les angles à la base sont...', options: ['Droits', 'Égaux', 'Différents', 'Nuls'], correctAnswer: 1),
    ],
    'Statistiques': [
      Exercise(question: 'Pour calculer une moyenne, on...', options: ['Additionne tout', 'Multiplie tout', 'Additionne et divise par l\'effectif', 'Prend le plus grand'], correctAnswer: 2),
      Exercise(question: 'La moyenne de 10 et 20 est...', options: ['12', '15', '30', '25'], correctAnswer: 1),
      Exercise(question: 'Dans un diagramme circulaire, la totalité fait...', options: ['180°', '100°', '360°', '90°'], correctAnswer: 2),
      Exercise(question: 'L\'effectif est...', options: ['Le nombre total d\'individus', 'La valeur mesurée', 'La moyenne', 'Le pourcentage'], correctAnswer: 0),
      Exercise(question: 'Si 5 élèves ont 12/20 et 5 élèves ont 14/20, la moyenne est...', options: ['12', '14', '13', '26'], correctAnswer: 2),
      Exercise(question: 'Une fréquence est souvent donnée en...', options: ['Mètres', 'Litres', 'Pourcentage', 'Euros'], correctAnswer: 2),
      Exercise(question: 'La somme des fréquences en pourcentage vaut...', options: ['10', '50', '100', '1000'], correctAnswer: 2),
      Exercise(question: 'Pour représenter l\'évolution d\'une température, on utilise...', options: ['Un diagramme circulaire', 'Une courbe (graphique)', 'Un tableau', 'Un texte'], correctAnswer: 1),
      Exercise(question: 'Dans un tableau, si l\'effectif total est 20 et 5 aiment le rouge, la fréquence est...', options: ['1/4', '1/2', '1/5', '5/200'], correctAnswer: 0),
      Exercise(question: 'Quelle est la moyenne de : 2, 4, 6 ?', options: ['3', '4', '5', '6'], correctAnswer: 1),
      Exercise(question: 'Sur un axe horizontal, on lit souvent...', options: ['Les effectifs', 'Les valeurs', 'Le titre', 'La date'], correctAnswer: 1),
      Exercise(question: 'Sur un axe vertical, on lit souvent...', options: ['Les effectifs', 'Les valeurs', 'Les noms', 'Les questions'], correctAnswer: 0),
      Exercise(question: 'L\'étendue d\'une série est...', options: ['La somme', 'La moyenne', 'Max - Min', 'Min + Max'], correctAnswer: 2),
      Exercise(question: 'Si la moyenne est 10 sur 3 notes, le total des points est...', options: ['13', '30', '20', '10'], correctAnswer: 1),
      Exercise(question: 'Un effectif peut-il être un nombre à virgule ?', options: ['Oui', 'Non (c\'est un nombre d\'individus)', 'Parfois', 'Toujours'], correctAnswer: 1),
    ],
  },

  '4ème': {
    'Nombres Relatifs': [
      // Règle des signes pour la multiplication et division
      Exercise(question: 'Quel est le signe de (-5) x (-2) ?', options: ['Positif (+)', 'Négatif (-)', 'Nul', 'On ne sait pas'], correctAnswer: 0),
      Exercise(question: 'Calculer : -4 x 5 = ?', options: ['20', '-20', '-9', '1'], correctAnswer: 1),
      Exercise(question: 'Quel est le signe de -2 x -2 x -2 ?', options: ['Positif', 'Négatif', 'Nul', 'Inverse'], correctAnswer: 1),
      Exercise(question: 'Calculer : -20 ÷ -5 = ?', options: ['-4', '4', '100', '-25'], correctAnswer: 1),
      Exercise(question: 'Le produit de 135 facteurs négatifs est...', options: ['Positif', 'Négatif', 'Nul', 'Grand'], correctAnswer: 1),
      Exercise(question: '(-1) x (-1) x (-1) x (-1) = ?', options: ['-1', '1', '-4', '4'], correctAnswer: 1),
      Exercise(question: 'Calculer : -6 x 7 = ?', options: ['42', '-42', '-13', '1'], correctAnswer: 1),
      Exercise(question: 'Quel calcul donne -12 ?', options: ['-3 x -4', '3 x 4', '-2 x 6', '-10 - 2'], correctAnswer: 2),
      Exercise(question: 'Le quotient de deux nombres de signes contraires est...', options: ['Positif', 'Négatif', 'Nul', 'Entier'], correctAnswer: 1),
      Exercise(question: 'Calculer : (-3)² = ?', options: ['-9', '9', '-6', '6'], correctAnswer: 1),
      Exercise(question: 'Calculer : -10 ÷ 2 = ?', options: ['5', '-5', '-20', '-12'], correctAnswer: 1),
      Exercise(question: 'Si a = -2 et b = -3, alors a x b = ?', options: ['-6', '6', '5', '-5'], correctAnswer: 1),
      Exercise(question: 'Quel est le signe de (-1) puissance 2024 ?', options: ['Positif', 'Négatif', 'Nul', 'Infini'], correctAnswer: 0),
      Exercise(question: '3 x (-2) x 5 = ?', options: ['30', '-30', '-10', '1'], correctAnswer: 1),
      Exercise(question: '(-8) / (-4) = ?', options: ['-2', '2', '32', '-12'], correctAnswer: 1),
    ],
    'Fractions': [
      // Multiplication, Division, Opérations complexes
      Exercise(question: 'Pour multiplier deux fractions, on multiplie...', options: ['En croix', 'Seulement les hauts', 'Les numérateurs entre eux et les dénominateurs entre eux', 'On met au même dénominateur'], correctAnswer: 2),
      Exercise(question: 'Calculer : 2/3 x 4/5 = ?', options: ['8/15', '6/8', '10/12', '2/5'], correctAnswer: 0),
      Exercise(question: 'Calculer : 3/4 x 5 = ?', options: ['15/20', '15/4', '3/20', '8/4'], correctAnswer: 1),
      Exercise(question: 'Diviser par une fraction revient à...', options: ['Soustraire', 'Multiplier par son inverse', 'Diviser le haut et le bas', 'Rien'], correctAnswer: 1),
      Exercise(question: 'L\'inverse de 2/3 est...', options: ['-2/3', '3/2', '1', '0'], correctAnswer: 1),
      Exercise(question: 'Calculer : 1/2 ÷ 1/3 = ?', options: ['1/6', '3/2', '2/3', '1'], correctAnswer: 1),
      Exercise(question: 'Calculer : 10/3 x 3/5 = ?', options: ['30/15', '13/8', '2', '10/5'], correctAnswer: 2),
      Exercise(question: '1 - 1/3 - 1/3 = ?', options: ['1/3', '0', '-1/3', '3/3'], correctAnswer: 0),
      Exercise(question: 'Quel est le résultat de 5 ÷ (1/2) ?', options: ['2,5', '10', '5/2', '1'], correctAnswer: 1),
      Exercise(question: 'Simplifier 12/16', options: ['6/8', '3/4', '1/2', '4/3'], correctAnswer: 1),
      Exercise(question: 'Calculer : (2/3)² = ?', options: ['4/6', '4/9', '2/9', '4/3'], correctAnswer: 1),
      Exercise(question: '5/7 + 2/21 (Mettre au même dénominateur) = ?', options: ['7/28', '17/21', '7/21', '15/21'], correctAnswer: 1),
      Exercise(question: 'L\'inverse de 5 est...', options: ['-5', '1/5', '5/1', '0,5'], correctAnswer: 1),
      Exercise(question: '3/4 des 20 élèves sont absents. Combien d\'élèves ?', options: ['15', '5', '12', '3'], correctAnswer: 0),
      Exercise(question: 'Quelle opération est prioritaire : 1/2 + 1/2 x 1/3 ?', options: ['L\'addition', 'La multiplication', 'Aucune', 'La division'], correctAnswer: 1),
    ],
    'Algèbre': [
      // Équations, Double distributivité
      Exercise(question: 'Résoudre : x + 5 = 12', options: ['x = 7', 'x = 17', 'x = -7', 'x = 60'], correctAnswer: 0),
      Exercise(question: 'Résoudre : 3x = 15', options: ['x = 12', 'x = 5', 'x = 45', 'x = 3/15'], correctAnswer: 1),
      Exercise(question: 'Résoudre : 2x - 4 = 6', options: ['x = 1', 'x = 2', 'x = 5', 'x = 10'], correctAnswer: 2),
      Exercise(question: 'Développer : (x + 1)(x + 2)', options: ['x² + 3x + 2', 'x² + 2', '2x + 3', 'x² + 1'], correctAnswer: 0),
      Exercise(question: 'Si 4x = 20, alors x = ...', options: ['16', '5', '80', '4'], correctAnswer: 1),
      Exercise(question: 'Supprimer les parenthèses : -(x + 3)', options: ['-x + 3', '-x - 3', 'x - 3', 'x + 3'], correctAnswer: 1),
      Exercise(question: 'Réduire : 3x + 2x - x', options: ['5x', '4x', '6x', '4'], correctAnswer: 1),
      Exercise(question: 'Une solution de 2x = 10 est...', options: ['5', '4', '8', '20'], correctAnswer: 0),
      Exercise(question: 'Développer k(a - b)', options: ['ka + kb', 'ka - kb', 'k - a - b', 'ka - b'], correctAnswer: 1),
      Exercise(question: 'Résoudre : -x = 5', options: ['x = 5', 'x = -5', 'x = 0', 'Impossible'], correctAnswer: 1),
      Exercise(question: 'Le périmètre d\'un carré est 20. Quel est son côté x ?', options: ['4', '5', '10', '2'], correctAnswer: 1),
      Exercise(question: 'Factoriser : 3x + 6', options: ['3(x+2)', '3(x+6)', 'x(3+6)', '3x(1+2)'], correctAnswer: 0),
      Exercise(question: 'Si 2x + 1 = 5, alors...', options: ['2x = 6', '2x = 4', 'x = 6', 'x = 3'], correctAnswer: 1),
      Exercise(question: 'L\'égalité 3x = 2x + x est...', options: ['Toujours vraie', 'Jamais vraie', 'Vraie pour x=0', 'Fausse'], correctAnswer: 0),
      Exercise(question: 'Simplifier : (2x)²', options: ['2x²', '4x²', '4x', '2x'], correctAnswer: 1),
    ],
    'Puissances': [
      // Puissances de 10, Notation scientifique, exposants négatifs
      Exercise(question: '10 puissance 4 (10⁴) est égal à...', options: ['40', '1000', '10 000', '400'], correctAnswer: 2),
      Exercise(question: '10 puissance -1 (10⁻¹) est égal à...', options: ['-10', '0,1', '-1', '0,01'], correctAnswer: 1),
      Exercise(question: 'L\'écriture scientifique de 2500 est...', options: ['2,5 x 10³', '25 x 10²', '0,25 x 10⁴', '2,5 x 10²'], correctAnswer: 0),
      Exercise(question: 'Calculer : 10² x 10³ = ?', options: ['10⁶', '10⁵', '20⁵', '100⁵'], correctAnswer: 1),
      Exercise(question: 'Calculer : 10⁵ / 10² = ?', options: ['10³', '10²', '10⁷', '5'], correctAnswer: 0),
      Exercise(question: 'Un micromètre (µm) c\'est 10 puissance...', options: ['-3', '-6', '-9', '6'], correctAnswer: 1),
      Exercise(question: '0,001 s\'écrit...', options: ['10⁻³', '10⁻²', '10³', '100'], correctAnswer: 0),
      Exercise(question: 'Le signe de (-2)³ est...', options: ['Positif', 'Négatif', 'Nul', 'Indéfini'], correctAnswer: 1),
      Exercise(question: '5⁰ (puissance 0) vaut...', options: ['0', '1', '5', 'Impossible'], correctAnswer: 1),
      Exercise(question: '3⁻² = ?', options: ['-9', '-6', '1/9', '1/6'], correctAnswer: 2),
      Exercise(question: 'Quelle est la notation scientifique de 0,045 ?', options: ['4,5 x 10⁻²', '45 x 10⁻³', '4,5 x 10²', '0,45 x 10⁻¹'], correctAnswer: 0),
      Exercise(question: '10 puissance 1 vaut...', options: ['1', '0', '10', '100'], correctAnswer: 2),
      Exercise(question: 'Calculer (10²)³ = ?', options: ['10⁵', '10⁶', '10⁸', '30²'], correctAnswer: 1),
      Exercise(question: 'Un milliard s\'écrit 10 puissance...', options: ['6', '9', '12', '100'], correctAnswer: 1),
      Exercise(question: 'Le carré de -5 est...', options: ['-25', '25', '-10', '10'], correctAnswer: 1),
    ],
    'Théorèmes': [
      // PYTHAGORE (Calculs hypoténuse et côté), Introduction Cosinus, Thalès (Configuration Triangle)
      Exercise(question: 'Le théorème de Pythagore s\'utilise dans un triangle...', options: ['Isocèle', 'Quelconque', 'Rectangle', 'Équilatéral'], correctAnswer: 2),
      Exercise(question: 'Si ABC est rectangle en A, alors...', options: ['AB² = AC² + BC²', 'BC² = AB² + AC²', 'AC² = AB² + BC²', 'AB + AC = BC'], correctAnswer: 1),
      Exercise(question: 'L\'hypoténuse est toujours...', options: ['Le plus petit côté', 'Le plus grand côté', 'Le côté vertical', 'L\'angle droit'], correctAnswer: 1),
      Exercise(question: 'Si les côtés de l\'angle droit font 3 et 4, l\'hypoténuse vaut...', options: ['5', '7', '25', '12'], correctAnswer: 0), // 3²+4²=9+16=25 -> sqrt(25)=5
      Exercise(question: 'Le théorème de Thalès sert à...', options: ['Calculer des angles', 'Calculer des longueurs', 'Prouver un angle droit', 'Calculer une aire'], correctAnswer: 1),
      Exercise(question: 'La réciproque de Pythagore sert à...', options: ['Calculer une longueur', 'Prouver qu\'un triangle est rectangle', 'Tracer un cercle', 'Calculer une aire'], correctAnswer: 1),
      Exercise(question: 'Dans un triangle rectangle, Cosinus = ...', options: ['Opposé / Hypoténuse', 'Adiacent / Hypoténuse', 'Hypoténuse / Adiacent', 'Opposé / Adiacent'], correctAnswer: 1),
      Exercise(question: 'Si l\'hypoténuse² = 100, alors l\'hypoténuse vaut...', options: ['50', '10', '20', '1000'], correctAnswer: 1),
      Exercise(question: 'Dans une configuration de Thalès, on a besoin de...', options: ['Droites parallèles', 'Un angle droit', 'Trois côtés égaux', 'Un cercle'], correctAnswer: 0),
      Exercise(question: 'Le centre du cercle circonscrit d\'un triangle rectangle est...', options: ['Le sommet de l\'angle droit', 'Au milieu de l\'hypoténuse', 'À l\'intérieur', 'À l\'extérieur'], correctAnswer: 1),
      Exercise(question: 'Quelle relation est fausse pour un triangle rectangle en A ?', options: ['BC > AB', 'BC > AC', 'AB + AC > BC', 'AB² + BC² = AC²'], correctAnswer: 3),
      Exercise(question: 'Le cosinus d\'un angle aigu est toujours...', options: ['Plus grand que 1', 'Plus petit que 1', 'Égal à 1', 'Négatif'], correctAnswer: 1),
      Exercise(question: 'Si AB=6, AC=8 et BC=10, le triangle est...', options: ['Rectangle en A', 'Rectangle en B', 'Isocèle', 'Quelconque'], correctAnswer: 0), // 36+64=100
      Exercise(question: 'La distance d\'un point à une droite est la longueur...', options: ['La plus longue', 'Perpendiculaire', 'Oblique', 'Quelconque'], correctAnswer: 1),
      Exercise(question: 'La médiane relie un sommet au...', options: ['Sommet opposé', 'Milieu du côté opposé', 'Côté opposé (perpendiculaire)', 'Centre'], correctAnswer: 1),
    ],
    'Statistiques': [
      // Moyenne pondérée, Médiane
      Exercise(question: 'La médiane partage la série en...', options: ['Trois parties', 'Deux parties de même effectif', 'Quatre quarts', 'Rien'], correctAnswer: 1),
      Exercise(question: 'Pour calculer une moyenne pondérée, on utilise...', options: ['Les coefficients', 'Les angles', 'Les inverses', 'Les carrés'], correctAnswer: 0),
      Exercise(question: 'Dans la série 1, 3, 5, 7, 9 la médiane est...', options: ['3', '5', '7', '25'], correctAnswer: 1),
      Exercise(question: 'Si j\'ai 10/20 coeff 1 et 20/20 coeff 2, ma moyenne est...', options: ['15/20', '16,6/20', '13/20', '30/40'], correctAnswer: 1), // (10 + 40)/3 = 50/3 = 16.66
      Exercise(question: 'L\'étendue de la série 2, 5, 10, 12 est...', options: ['12', '10', '10 (12-2)', '14'], correctAnswer: 2),
      Exercise(question: 'Pour trouver la médiane, il faut d\'abord...', options: ['Calculer la moyenne', 'Ranger les valeurs dans l\'ordre', 'Faire un graphique', 'Rien'], correctAnswer: 1),
      Exercise(question: 'Une probabilité est un nombre compris entre...', options: ['0 et 100', '0 et 1', '-1 et 1', '1 et 10'], correctAnswer: 1),
      Exercise(question: 'Si je lance une pièce, la probabilité d\'avoir pile est...', options: ['1/2', '1/3', '1/4', '1'], correctAnswer: 0),
      Exercise(question: 'La fréquence totale est toujours égale à...', options: ['100', '1', '10', 'L\'infini'], correctAnswer: 1),
      Exercise(question: 'Dans un diagramme, l\'effectif est proportionnel à...', options: ['La couleur', 'L\'aire ou la hauteur', 'La largeur', 'L\'épaisseur'], correctAnswer: 1),
      Exercise(question: 'Si la moyenne augmente, la médiane...', options: ['Augmente forcément', 'Diminue', 'Reste pareille', 'Peut ne pas changer'], correctAnswer: 3),
      Exercise(question: 'Effectif cumulé signifie...', options: ['On soustrait', 'On additionne au fur et à mesure', 'On multiplie', 'On divise'], correctAnswer: 1),
      Exercise(question: 'Une issue en probabilité est...', options: ['Un problème', 'Un résultat possible', 'Une erreur', 'Une question'], correctAnswer: 1),
      Exercise(question: 'Dans un jeu de 32 cartes, la probabilité de tirer un As est...', options: ['1/32', '4/32', '2/32', '1/4'], correctAnswer: 1),
      Exercise(question: 'La moyenne de 10, 10 et 10 est...', options: ['30', '10', '20', '0'], correctAnswer: 1),
    ],
  },

  '3ème': {
    'Nombres Relatifs': [
      // Arithmétique (PGCD, Nombres premiers) et Racines Carrées
      Exercise(question: 'Quel est le PGCD de 12 et 18 ?', options: ['6', '3', '2', '12'], correctAnswer: 0),
      Exercise(question: 'Un nombre premier est divisible par...', options: ['1 et lui-même', '1 et 2', 'Tout nombre', 'Rien'], correctAnswer: 0),
      Exercise(question: 'Lequel est un nombre premier ?', options: ['13', '15', '9', '21'], correctAnswer: 0),
      Exercise(question: 'La racine carrée de 81 (√81) est...', options: ['9', '8', '40,5', '18'], correctAnswer: 0),
      Exercise(question: 'Simplifier √50', options: ['5√2', '2√5', '25', '10'], correctAnswer: 0), // √25*2 = 5√2
      Exercise(question: 'Quel nombre n\'est PAS premier ?', options: ['2', '3', '9', '11'], correctAnswer: 2),
      Exercise(question: 'Décomposer 20 en facteurs premiers :', options: ['2² x 5', '4 x 5', '2 x 10', '2 x 2 x 4'], correctAnswer: 0),
      Exercise(question: '√16 + √9 = ?', options: ['7', '5', '25', '√25'], correctAnswer: 0), // 4+3=7
      Exercise(question: 'Les diviseurs de 10 sont...', options: ['1, 2, 5, 10', '1, 2, 10', '2, 5', '10, 20, 30'], correctAnswer: 0),
      Exercise(question: 'Deux nombres sont premiers entre eux si leur PGCD vaut...', options: ['1', '0', 'Leur produit', '2'], correctAnswer: 0),
      Exercise(question: 'Calculer : (√3)² = ?', options: ['3', '9', '√9', '1,732'], correctAnswer: 0),
      Exercise(question: 'Quel est le carré de √7 ?', options: ['7', '49', '14', '3,5'], correctAnswer: 0),
      Exercise(question: 'Si a² = 25 et a > 0, alors a = ?', options: ['5', '-5', '25', '625'], correctAnswer: 0),
      Exercise(question: 'Le produit de deux racines carrées √a x √b est...', options: ['√(a x b)', '√a + √b', 'Impossible', 'a x b'], correctAnswer: 0),
      Exercise(question: 'Lequel est un carré parfait ?', options: ['144', '140', '150', '10'], correctAnswer: 0),
    ],
    'Fractions': [
      // Fractions irréductibles et opérations complexes
      Exercise(question: 'Rendre irréductible : 15/25', options: ['3/5', '15/25', '5/3', '1/5'], correctAnswer: 0),
      Exercise(question: 'Calculer : 1/2 - 1/3 = ?', options: ['1/6', '0', '-1', '1'], correctAnswer: 0),
      Exercise(question: 'Quel est l\'inverse de -3/4 ?', options: ['-4/3', '3/4', '4/3', '0,75'], correctAnswer: 0),
      Exercise(question: 'Calculer : (2/3) ÷ (5/7) = ?', options: ['14/15', '10/21', '7/15', '3/2'], correctAnswer: 0),
      Exercise(question: 'Pour additionner 1/x + 1/y, on met au dénominateur...', options: ['xy', 'x+y', 'x', 'y'], correctAnswer: 0),
      Exercise(question: 'Calculer A = 1 - (1/3 + 1/3)', options: ['1/3', '0', '2/3', '1'], correctAnswer: 0),
      Exercise(question: 'Le tiers du quart est...', options: ['1/12', '1/7', '1/3', '3/4'], correctAnswer: 0),
      Exercise(question: 'Simplifier la fraction 84/126', options: ['2/3', '4/6', '1/2', '42/63'], correctAnswer: 0),
      Exercise(question: 'Calculer : 5/2 x 4/15', options: ['2/3', '20/30', '9/17', '1/3'], correctAnswer: 0),
      Exercise(question: '10/3 - 1 = ?', options: ['7/3', '9/3', '3/3', '10/2'], correctAnswer: 0),
      Exercise(question: 'Quel nombre est rationnel ?', options: ['1/3', '√2', 'π', '√3'], correctAnswer: 0),
      Exercise(question: 'La fraction 450/700 peut se simplifier par...', options: ['50', '100', '7', '9'], correctAnswer: 0),
      Exercise(question: 'Calculer : (3/2)² - 1', options: ['5/4', '1/4', '2', '8/4'], correctAnswer: 0), // 9/4 - 4/4 = 5/4
      Exercise(question: 'L\'écriture décimale de 3/2 est...', options: ['1,5', '1,33', '0,66', '3,2'], correctAnswer: 0),
      Exercise(question: 'Si A = 2/3 et B = -1/3, alors A + B = ?', options: ['1/3', '-1/3', '1', '0'], correctAnswer: 0),
    ],
    'Algèbre': [
      // Identités remarquables, Fonctions, Inéquations
      Exercise(question: 'Développer (x + 3)² (Identité remarquable)', options: ['x² + 6x + 9', 'x² + 9', 'x² + 3x + 9', '2x + 6'], correctAnswer: 0),
      Exercise(question: 'Développer (a - b)²', options: ['a² - 2ab + b²', 'a² - b²', 'a² + b²', 'a² - 2ab - b²'], correctAnswer: 0),
      Exercise(question: 'Développer (x - 5)(x + 5)', options: ['x² - 25', 'x² + 25', 'x² - 10x + 25', 'x² - 5'], correctAnswer: 0),
      Exercise(question: 'Si f(x) = 2x + 3, quelle est l\'image de 4 ?', options: ['11', '5', '8', '12'], correctAnswer: 0), // 2*4+3 = 11
      Exercise(question: 'Si g(x) = x², l\'antécédent de 9 est...', options: ['3 ou -3', '3 uniquement', '81', '4,5'], correctAnswer: 0),
      Exercise(question: 'Résoudre l\'équation produit : (x-2)(x+3) = 0', options: ['2 et -3', '-2 et 3', '2 et 3', '0'], correctAnswer: 0),
      Exercise(question: 'Résoudre l\'inéquation : 2x < 10', options: ['x < 5', 'x > 5', 'x = 5', 'x < 20'], correctAnswer: 0),
      Exercise(question: 'Factoriser x² - 16', options: ['(x-4)(x+4)', '(x-4)²', '(x+4)²', 'x(x-16)'], correctAnswer: 0),
      Exercise(question: 'Une fonction linéaire est de la forme...', options: ['f(x) = ax', 'f(x) = ax + b', 'f(x) = x²', 'f(x) = a'], correctAnswer: 0),
      Exercise(question: 'Une fonction affine est représentée par...', options: ['Une droite', 'Une courbe', 'Un cercle', 'Un point'], correctAnswer: 0),
      Exercise(question: 'Si h(x) = -x, alors h(-5) = ?', options: ['5', '-5', '0', 'Impossible'], correctAnswer: 0),
      Exercise(question: 'Résoudre x² = 49', options: ['7 et -7', '7', '-7', '49'], correctAnswer: 0),
      Exercise(question: 'Développer 2x(x - 4)', options: ['2x² - 8x', '2x - 8', 'x² - 4', '2x² - 4'], correctAnswer: 0),
      Exercise(question: 'Si -3x > 12, alors...', options: ['x < -4', 'x > -4', 'x < 4', 'x > 4'], correctAnswer: 0), // On divise par un négatif, on change le sens
      Exercise(question: 'L\'ordonnée à l\'origine de f(x)=3x-2 est...', options: ['-2', '3', '2', '-3'], correctAnswer: 0),
    ],
    'Puissances': [
      // Notation scientifique complexe, calculs puissances
      Exercise(question: 'L\'écriture scientifique de 0,00056 est...', options: ['5,6 x 10⁻⁴', '56 x 10⁻⁵', '0,56 x 10⁻³', '5,6 x 10⁴'], correctAnswer: 0),
      Exercise(question: 'Calculer : (10³)²', options: ['10⁶', '10⁵', '10⁹', '20³'], correctAnswer: 0),
      Exercise(question: 'Calculer : 2⁻³', options: ['1/8', '-8', '-6', '0,8'], correctAnswer: 0),
      Exercise(question: 'Quel nombre est égal à 10⁰ ?', options: ['1', '0', '10', 'Impossible'], correctAnswer: 0),
      Exercise(question: 'Calculer : 3² x 3⁴', options: ['3⁶', '3⁸', '9⁶', '9⁸'], correctAnswer: 0),
      Exercise(question: 'L\'inverse de 10² est...', options: ['10⁻²', '100', '-10²', '0,2'], correctAnswer: 0),
      Exercise(question: 'La vitesse de la lumière est environ 3 x 10⁵ km/s. C\'est...', options: ['300 000 km/s', '3 000 km/s', '30 000 000 km/s', '300 km/s'], correctAnswer: 0),
      Exercise(question: '5 x 10² + 3 x 10⁰ = ?', options: ['503', '530', '5003', '53'], correctAnswer: 0),
      Exercise(question: 'Calculer 2⁵', options: ['32', '10', '25', '64'], correctAnswer: 0),
      Exercise(question: 'Le signe de (-2)⁴ est...', options: ['Positif', 'Négatif', 'Nul', 'Indéfini'], correctAnswer: 0),
      Exercise(question: 'Simplifier a⁵ / a² (a non nul)', options: ['a³', 'a²', 'a⁷', 'a²°⁵'], correctAnswer: 0),
      Exercise(question: 'Un nanomètre correspond à...', options: ['10⁻⁹ m', '10⁻⁶ m', '10⁻³ m', '10⁹ m'], correctAnswer: 0),
      Exercise(question: 'L\'ordre de grandeur de 8 950 est...', options: ['10⁴', '10³', '10⁵', '10²'], correctAnswer: 0),
      Exercise(question: '4 x 10⁻² = ?', options: ['0,04', '400', '0,4', '-400'], correctAnswer: 0),
      Exercise(question: 'Le carré de 10³ est...', options: ['10⁶', '10⁵', '10⁹', '100³'], correctAnswer: 0),
    ],
    'Théorèmes': [
      // Trigonométrie, Thalès Papillon, Géométrie espace
      Exercise(question: 'Dans un triangle rectangle, Cosinus = ?', options: ['Adj / Hyp', 'Opp / Hyp', 'Opp / Adj', 'Hyp / Adj'], correctAnswer: 0),
      Exercise(question: 'La tangente d\'un angle est...', options: ['Opposé / Adjacent', 'Adjacent / Hypoténuse', 'Opposé / Hypoténuse', 'Hypoténuse / Opposé'], correctAnswer: 0),
      Exercise(question: 'Théorème de Thalès (Papillon) : Si (AB)//(CD)...', options: ['OA/OC = OB/OD = AB/CD', 'OA/OB = OC/OD', 'AB = CD', 'OA+OB = OC+OD'], correctAnswer: 0),
      Exercise(question: 'Pour calculer un angle, on utilise...', options: ['ArcCos, ArcSin ou ArcTan', 'Le théorème de Pythagore', 'La règle', 'Le compas'], correctAnswer: 0),
      Exercise(question: 'Le volume d\'une boule de rayon R est...', options: ['4/3 x π x R³', '4πR²', 'πR²', 'R x R x R'], correctAnswer: 0),
      Exercise(question: 'Une section de sphère par un plan est...', options: ['Un cercle', 'Un carré', 'Un point', 'Un triangle'], correctAnswer: 0),
      Exercise(question: 'Si Cos(x) = 0,5, alors l\'angle x vaut...', options: ['60°', '30°', '45°', '90°'], correctAnswer: 0),
      Exercise(question: 'Dans un triangle rectangle, Sinus = ?', options: ['Opp / Hyp', 'Adj / Hyp', 'Opp / Adj', 'Hyp / Opp'], correctAnswer: 0),
      Exercise(question: 'La somme des carrés des côtés de l\'angle droit est...', options: ['Le carré de l\'hypoténuse', 'Le double de l\'hypoténuse', 'L\'aire du triangle', 'Nulle'], correctAnswer: 0),
      Exercise(question: 'Un agrandissement de rapport k multiplie les aires par...', options: ['k²', 'k', '2k', 'k³'], correctAnswer: 0),
      Exercise(question: 'Tan(45°) = ?', options: ['1', '0', '0,5', 'Infini'], correctAnswer: 0),
      Exercise(question: 'Pour utiliser la trigonométrie, le triangle doit être...', options: ['Rectangle', 'Isocèle', 'Équilatéral', 'Quelconque'], correctAnswer: 0),
      Exercise(question: 'Le côté opposé à l\'angle droit s\'appelle...', options: ['L\'hypoténuse', 'Le rayon', 'La hauteur', 'La tangente'], correctAnswer: 0),
      Exercise(question: 'Si je réduis un cube de rapport 1/2, son volume est divisé par...', options: ['8', '2', '4', '6'], correctAnswer: 0), // (1/2)³ = 1/8
      Exercise(question: 'SOH CAH TOA permet de retenir...', options: ['Les formules de trigo', 'Le nom du prof', 'Un théorème', 'Une capitale'], correctAnswer: 0),
    ],
    'Statistiques': [
      // Probabilités, Médiane, Étendue
      Exercise(question: 'La probabilité de tirer un As dans un jeu de 32 cartes est...', options: ['4/32 (soit 1/8)', '1/32', '2/32', '4/52'], correctAnswer: 0),
      Exercise(question: 'La médiane de la série 1; 5; 9; 12; 20 est...', options: ['9', '5', '12', '9,4'], correctAnswer: 0),
      Exercise(question: 'L\'étendue de la série 2; 10; 15; 22 est...', options: ['20', '22', '2', '10'], correctAnswer: 0), // 22 - 2 = 20
      Exercise(question: 'La probabilité d\'un événement impossible est...', options: ['0', '1', '0,5', '-1'], correctAnswer: 0),
      Exercise(question: 'La somme des probabilités de toutes les issues est...', options: ['1', '100', '0', 'Infinie'], correctAnswer: 0),
      Exercise(question: 'On lance deux pièces. Quelle probabilité d\'avoir 2 piles ?', options: ['1/4', '1/2', '1/3', '1/8'], correctAnswer: 0), // PP, PF, FP, FF
      Exercise(question: 'Si la moyenne est 10 et l\'effectif 30, la somme est...', options: ['300', '30', '3', '10'], correctAnswer: 0),
      Exercise(question: 'Un événement certain a une probabilité de...', options: ['1', '100', '0', '0,99'], correctAnswer: 0),
      Exercise(question: 'Si je tire une boule dans une urne (3 rouges, 2 bleues), proba d\'avoir bleu ?', options: ['2/5', '3/5', '1/2', '2/3'], correctAnswer: 0),
      Exercise(question: 'La médiane partage la série en...', options: ['Deux groupes de même effectif', 'Trois tiers', 'Quatre quarts', 'Rien'], correctAnswer: 0),
      Exercise(question: 'Si on ajoute 2 à toutes les notes, la moyenne...', options: ['Augmente de 2', 'Ne change pas', 'Double', 'Diminue'], correctAnswer: 0),
      Exercise(question: 'L\'événement contraire de "Obtenir 6" avec un dé est...', options: ['Obtenir 1, 2, 3, 4 ou 5', 'Obtenir 1', 'Ne pas jouer', 'Obtenir 0'], correctAnswer: 0),
      Exercise(question: 'Dans une série paire (2; 4; 6; 8), la médiane est...', options: ['5', '4', '6', '10'], correctAnswer: 0), // Entre 4 et 6
      Exercise(question: 'Une fréquence peut s\'écrire...', options: ['En fraction, décimal ou %', 'Seulement en %', 'En degrés', 'En kg'], correctAnswer: 0),
      Exercise(question: 'Dans un arbre de probabilité, la somme des branches d\'un nœud vaut...', options: ['1', '10', '0,5', '100'], correctAnswer: 0),
    ],
  },


};