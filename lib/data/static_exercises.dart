import '../models/exercise_model.dart';

final Map<String, Map<String, List<Exercise>>> staticExercises = {
  'CI': {
    'Addition': [
      Exercise(question: '1 + 1 = ?', options: ['2', '1', '3', '0'], correctAnswer: 0),
      Exercise(question: '2 + 3 = ?', options: ['4', '5', '6', '3'], correctAnswer: 1),
      Exercise(question: '4 + 0 = ?', options: ['5', '3', '4', '2'], correctAnswer: 2),
      Exercise(question: '5 + 1 = ?', options: ['7', '8', '5', '6'], correctAnswer: 3),
      Exercise(question: '3 + 2 = ?', options: ['5', '6', '7', '4'], correctAnswer: 0),
      Exercise(question: '0 + 4 = ?', options: ['1', '6', '5', '4'], correctAnswer: 3),
      Exercise(question: '2 + 2 = ?', options: ['5', '2', '4', '3'], correctAnswer: 2),
      Exercise(question: '1 + 3 = ?', options: ['5', '2', '1', '4'], correctAnswer: 3),
      Exercise(question: '0 + 0 = ?', options: ['0', '1', '2', '3'], correctAnswer: 0),
      Exercise(question: '2 + 1 = ?', options: ['4', '3', '2', '1'], correctAnswer: 1),
    ],
    'Soustraction': [
      Exercise(question: '2 - 1 = ?', options: ['1', '2', '0', '3'], correctAnswer: 0),
      Exercise(question: '5 - 3 = ?', options: ['1', '2', '3', '0'], correctAnswer: 1),
      Exercise(question: '4 - 2 = ?', options: ['3', '1', '2', '0'], correctAnswer: 2),
      Exercise(question: '6 - 1 = ?', options: ['6', '3', '4', '5'], correctAnswer: 3),
      Exercise(question: '3 - 1 = ?', options: ['2', '3', '1', '0'], correctAnswer: 0),
      Exercise(question: '5 - 0 = ?', options: ['4', '5', '0', '3'], correctAnswer: 1),
      Exercise(question: '4 - 3 = ?', options: ['2', '0', '1', '3'], correctAnswer: 2),
      Exercise(question: '3 - 3 = ?', options: ['1', '2', '3', '0'], correctAnswer: 3),
      Exercise(question: '2 - 0 = ?', options: ['2', '0', '1', '3'], correctAnswer: 0),
      Exercise(question: '1 - 1 = ?', options: ['2', '3', '1', '0'], correctAnswer: 3),
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
      Exercise(question: '6 - 1 = ?', options: ['4', '3', '5', '6'], correctAnswer: 1),
      Exercise(question: '13 - 8 = ?', options: ['6', '4', '5', '7'], correctAnswer: 2),
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
    ],
    'Division': [
      Exercise(question: '6 ÷ 2 = ?', options: ['2', '3', '4', '6'], correctAnswer: 1),
      Exercise(question: '8 ÷ 4 = ?', options: ['2', '1', '3', '4'], correctAnswer: 0),
      Exercise(question: '9 ÷ 3 = ?', options: ['2', '3', '4', '5'], correctAnswer: 1),
      Exercise(question: '12 ÷ 6 = ?', options: ['1', '2', '3', '4'], correctAnswer: 0),
      Exercise(question: '10 ÷ 5 = ?', options: ['2', '3', '1', '4'], correctAnswer: 0),
      Exercise(question: '15 ÷ 3 = ?', options: ['5', '4', '6', '3'], correctAnswer: 0),
      Exercise(question: '16 ÷ 4 = ?', options: ['2', '3', '4', '5'], correctAnswer: 2),
      Exercise(question: '18 ÷ 2 = ?', options: ['8', '9', '10', '7'], correctAnswer: 1),
      Exercise(question: '20 ÷ 5 = ?', options: ['4', '5', '3', '2'], correctAnswer: 0),
      Exercise(question: '14 ÷ 7 = ?', options: ['1', '0', '3', '2'], correctAnswer: 3),
      Exercise(question: '8 ÷ 2 = ?', options: ['4', '3', '2', '5'], correctAnswer: 0),
      Exercise(question: '6 ÷ 3 = ?', options: ['3', '2', '1', '0'], correctAnswer: 1),
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
    ],
  },
  'CE1': {
    'Addition': [
      Exercise(question: '15 + 10 = ?', options: ['24', '25', '26', '27'], correctAnswer: 1),
      Exercise(question: '6 + 13 = ?', options: ['17', '18', '19', '20'], correctAnswer: 2),
      Exercise(question: '9 + 7 = ?', options: ['15', '16', '17', '18'], correctAnswer: 1),
      Exercise(question: '14 + 8 = ?', options: ['21', '22', '23', '24'], correctAnswer: 2),
      Exercise(question: '12 + 11 = ?', options: ['21', '22', '23', '24'], correctAnswer: 0),
      Exercise(question: '17 + 5 = ?', options: ['21', '22', '23', '24'], correctAnswer: 1),
      Exercise(question: '18 + 6 = ?', options: ['23', '24', '25', '26'], correctAnswer: 0),
      Exercise(question: '11 + 14 = ?', options: ['23', '26', '25', '24'], correctAnswer: 3),
      Exercise(question: '20 + 9 = ?', options: ['27', '28', '29', '30'], correctAnswer: 2),
      Exercise(question: '8 + 13 = ?', options: ['20', '21', '22', '23'], correctAnswer: 3),
      Exercise(question: '7 + 16 = ?', options: ['21', '22', '23', '24'], correctAnswer: 2),
      Exercise(question: '19 + 4 = ?', options: ['22', '23', '24', '25'], correctAnswer: 1),
    ],
    'Soustraction': [
      Exercise(question: '20 - 9 = ?', options: ['10', '11', '12', '13'], correctAnswer: 1),
      Exercise(question: '18 - 7 = ?', options: ['10', '11', '12', '13'], correctAnswer: 0),
      Exercise(question: '15 - 8 = ?', options: ['7', '8', '9', '10'], correctAnswer: 0),
      Exercise(question: '24 - 12 = ?', options: ['11', '12', '13', '14'], correctAnswer: 1),
      Exercise(question: '17 - 6 = ?', options: ['10', '13', '12', '11'], correctAnswer: 3),
      Exercise(question: '22 - 13 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '30 - 15 = ?', options: ['13', '14', '15', '16'], correctAnswer: 2),
      Exercise(question: '25 - 9 = ?', options: ['14', '15', '16', '17'], correctAnswer: 0),
      Exercise(question: '17 - 8 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '23 - 16 = ?', options: ['7', '6', '8', '9'], correctAnswer: 0),
      Exercise(question: '14 - 5 = ?', options: ['8', '9', '10', '11'], correctAnswer: 2),
      Exercise(question: '26 - 17 = ?', options: ['7', '8', '9', '10'], correctAnswer: 2),
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
    ],
    'Division': [
      Exercise(question: '16 ÷ 4 = ?', options: ['4', '3', '2', '5'], correctAnswer: 0),
      Exercise(question: '18 ÷ 3 = ?', options: ['5', '6', '7', '8'], correctAnswer: 1),
      Exercise(question: '20 ÷ 5 = ?', options: ['3', '5', '4', '6'], correctAnswer: 2),
      Exercise(question: '24 ÷ 6 = ?', options: ['4', '3', '5', '6'], correctAnswer: 0 ),
      Exercise(question: '36 ÷ 4 = ?', options: ['8', '9', '10', '11'], correctAnswer: 0),
      Exercise(question: '21 ÷ 7 = ?', options: ['2', '5', '4', '3'], correctAnswer: 3),
      Exercise(question: '12 ÷ 6 = ?', options: ['1', '2', '3', '4'], correctAnswer: 1),
      Exercise(question: '28 ÷ 7 = ?', options: ['3', '6', '5', '4'], correctAnswer: 3),
      Exercise(question: '32 ÷ 8 = ?', options: ['3', '4', '5', '6'], correctAnswer: 1),
      Exercise(question: '27 ÷ 3 = ?', options: ['8', '9', '10', '11'], correctAnswer: 1),
      Exercise(question: '14 ÷ 2 = ?', options: ['5', '6', '7', '8'], correctAnswer: 2),
      Exercise(question: '18 ÷ 2 = ?', options: ['9', '8', '10', '7'], correctAnswer: 0),
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
    ],
  },
  'CE2': {
    'Addition': [
      Exercise(
          question: 'Sarah a 125 billes et en gagne 87 à la récréation. Combien de billes a-t-elle maintenant ?',
          options: ['213', '210', '212', '211'],
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
      options: ['407', '408', '405', '406'],
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
          options: ['112', '109', '111', '110'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'Maman achète 180 g de farine et 19 g de sucre. Quel est le poids total ?',
          options: ['201', '199', '198', '200'],
          correctAnswer: 1
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
          options: ['135', '137', '136', '134'],
          correctAnswer: 3
      ),
      Exercise(
          question: '178 élèves sont inscrits à la cantine, 99 sont absents. Combien mangent à la cantine ?',
          options: ['81', '80', '79', '78'],
          correctAnswer: 3
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
          correctAnswer: 3
      ),
      Exercise(
          question: '210 stylos, 101 sont utilisés. Combien restent-ils neufs ?',
          options: ['108', '110', '111', '109'],
          correctAnswer: 3
      ),
      Exercise(
          question: '325 élèves étaient prévus, 123 sont absents. Combien d\'élèves sont présents ?',
      options: ['203', '202', '201', '200'],
          correctAnswer: 3
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
          options: ['56', '53', '54', '55'],
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
          options: ['25', '23', '24', '26'],
          correctAnswer: 0
      ),
      Exercise(
          question: '6 enfants font chacun 7 dessins. Combien de dessins ?',
          options: ['41', '44', '43', '42'],
          correctAnswer: 3
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
          options: ['9', '7', '8', '10'],
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
    ],
  },
  'CM1': {
    'Addition': [
      Exercise(
          question: 'Un club sportif compte 1 235 filles et 1 897 garçons. Quel est le nombre total d\'adhérents ?',
      options: ['3134', '3133', '3132', '3135'],
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
          options: ['443', '442', '444', '445'],
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
          options: ['475', '474', '476', '477'],
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
          options: ['900', '899', '901', '902'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Le magasin reçoit 720 produits, en vend 250. Combien restent-ils ?',
          options: ['470', '469', '471', '472'],
          correctAnswer: 0
      ),
      Exercise(
          question: 'Un commerçant a 650 euros, il dépense 321 euros. Combien lui reste-t-il ?',
          options: ['329', '328', '330', '331'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'La bibliothèque a 545 livres, 123 sont empruntés. Combien restent-ils ?',
          options: ['422', '421', '423', '424'],
          correctAnswer: 0
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
          options: ['168', '167', '169', '170'],
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
          options: ['168', '167', '169', '170'],
          correctAnswer: 2
      ),
      Exercise(
          question: '13 boîtes contiennent 11 billes chacune. Combien de billes en tout ?',
          options: ['141', '142', '143', '144'],
          correctAnswer: 1
      ),
      Exercise(
          question: '12 classes travaillent chacune 12 chapitres. Combien de chapitres ?',
          options: ['143', '144', '145', '146'],
          correctAnswer: 1
      ),
      Exercise(
          question: '21 voitures transportent 5 enfants chacune. Combien d\'enfants ?',
          options: ['105', '104', '106', '107'],
          correctAnswer: 2
      ),
      Exercise(
          question: '18 équipes jouent 7 matchs. Combien de matchs au total ?',
          options: ['124', '126', '125', '127'],
          correctAnswer: 1
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
          options: ['30', '29', '31', '32'],
          correctAnswer: 3
      ),
      Exercise(
          question: '225 billes réparties dans 9 sacs. Combien de billes par sac ?',
          options: ['24', '25', '26', '27'],
          correctAnswer: 1
      ),
      Exercise(
          question: '90 bonbons à partager entre 5 enfants. Combien chacun ?',
          options: ['18', '17', '19', '20'],
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
          correctAnswer: 3
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
          correctAnswer: 3
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
          correctAnswer: 3
      ),
      Exercise(
          question: 'Combien de sommets a un octogone ?',
          options: ['9', '10', '8', '11'],
          correctAnswer: 2
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
          options: ['18339', '18337', '18336', '18338'],
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
          options: ['4001', '4002', '4000', '3999'],
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
          options: ['10003', '10001', '10002', '10000'],
          correctAnswer: 3
      ),
      Exercise(
          question: 'Une classe réunit 4 123 cahiers puis 987 de plus. Combien de cahiers en tout ?',
          options: ['5111', '5109', '5110', '5112'],
          correctAnswer: 2
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
          options: ['1412', '1410', '1413', '1411'],
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
          options: ['6768', '6767', '6765', '6766'],
          correctAnswer: 2
      ),
      Exercise(
          question: 'L\'école avait 14 000 élèves, 4 567 changent d\'établissement. Combien restent-ils ?',
          options: ['9435', '9434', '9436', '9433'],
          correctAnswer: 1
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
          correctAnswer: 1
      ),
    ],
  },


};