import 'dart:math';

class NotificationMessages {
  static const List<String> motivationalMessages = [
    "Hey MathKid! 🌟 Prêt(e) pour une nouvelle aventure mathématique aujourd'hui?",
    "Hello petit génie! 🧠 Les chiffres t'attendent pour jouer ensemble!",
    "Salut champion! 🏆 Viens résoudre des énigmes mathématiques amusantes!",
    "Hey MathKid! 🚀 Ton cerveau est comme une fusée, lance-toi dans les maths!",
    "Coucou super calculateur! 🤖 Il est temps de faire briller tes talents!",
    "Hello MathKid! ⭐ Chaque problème résolu te rend plus fort(e)!",
    "Salut petit Einstein! 🧪 Découvre la magie des nombres aujourd'hui!",
    "Hey champion des maths! 🎯 Vise haut et calcule juste!",
    "Bonjour MathKid! 🌈 Les mathématiques sont un arc-en-ciel de possibilités!",
    "Hello petit explorateur! 🗺️ Pars à la découverte du monde des chiffres!",
    "Salut MathKid! 🎨 Peins ton avenir avec les couleurs des mathématiques!",
    "Hey super cerveau! 💡 Allume ta créativité mathématique!",
    "Coucou MathKid! 🎪 Bienvenue au cirque fantastique des nombres!",
    "Hello petit magicien! 🎩 Fais apparaître les bonnes réponses!",
    "Salut MathKid! 🏰 Construis ton château de connaissances mathématiques!",
    "Hey champion! 🥇 Aujourd'hui est parfait pour battre tes records!",
    "Bonjour MathKid! 🌻 Fais grandir ton jardin de savoirs mathématiques!",
    "Hello petit aventurier! ⚔️ Équipe-toi de tes compétences et à l'attaque!",
    "Salut MathKid! 🎵 Les maths sont une belle mélodie, viens la jouer!",
    "Hey super élève! 📚 Ouvre le livre magique des mathématiques!",
    "Coucou MathKid! 🦸 Tu es le super-héros des calculs!",
    "Hello petit scientifique! 🔬 Expérimente avec les formules amusantes!",
    "Salut MathKid! 🎮 Level up tes compétences mathématiques!",
    "Hey champion! 🌟 Brille comme une étoile dans l'univers des maths!",
    "Bonjour MathKid! 🚗 Démarre ton moteur à calculs et roule vers le succès!"
  ];

  static const List<String> eveningMessages = [
    "Bonsoir MathKid! 🌙 Un petit défi avant de dormir?",
    "Hello petit rêveur! ✨ Rêve de nombres magiques cette nuit!",
    "Salut MathKid! 🌃 Même le soir, ton cerveau peut s'amuser avec les maths!",
    "Hey champion! 🛌 Un dernier calcul avant de fermer les yeux?",
    "Bonsoir petit génie! 🌠 Les étoiles comptent sur toi pour les mathématiques!"
  ];

  static const List<String> weekendMessages = [
    "Weekend MathKid! 🎉 Même en s'amusant, on peut faire des maths!",
    "Salut champion du weekend! 🏖️ Les maths sont partout, même en vacances!",
    "Hey MathKid! 🎈 Le weekend est parfait pour jouer avec les nombres!",
    "Hello petit explorateur! 🌍 Découvre les maths dans tes activités du weekend!"
  ];

  // Générateur de nombres aléatoires
  static final Random _random = Random();

  static String getRandomMessage() {
    final now = DateTime.now();
    final hour = now.hour;
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    List<String> messagesToUse;

    if (isWeekend) {
      messagesToUse = weekendMessages;
    } else if (hour >= 18 || hour <= 6) {
      messagesToUse = eveningMessages;
    } else {
      messagesToUse = motivationalMessages;
    }

    // Sélection aléatoire sans modifier la liste originale
    final randomIndex = _random.nextInt(messagesToUse.length);
    return messagesToUse[randomIndex];
  }

  static String getSpecificMessage(MessageType type) {
    List<String> messagesToUse;

    switch (type) {
      case MessageType.motivational:
        messagesToUse = motivationalMessages;
        break;
      case MessageType.evening:
        messagesToUse = eveningMessages;
        break;
      case MessageType.weekend:
        messagesToUse = weekendMessages;
        break;
    }

    // Sélection aléatoire sans modifier la liste originale
    final randomIndex = _random.nextInt(messagesToUse.length);
    return messagesToUse[randomIndex];
  }

  // Méthode pour obtenir un message contextuel selon l'heure
  static String getContextualMessage() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      // Matin (5h-12h)
      return getSpecificMessage(MessageType.motivational);
    } else if (hour >= 12 && hour < 17) {
      // Après-midi (12h-17h)
      return getSpecificMessage(MessageType.motivational);
    } else {
      // Soirée (17h-5h)
      return getSpecificMessage(MessageType.evening);
    }
  }

  // Méthode pour obtenir un message selon le jour de la semaine
  static String getWeekdayMessage() {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    if (isWeekend) {
      return getSpecificMessage(MessageType.weekend);
    } else {
      return getContextualMessage();
    }
  }



  }


enum MessageType {
  motivational,
  evening,
  weekend,
}