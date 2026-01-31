// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MathsCool';

  @override
  String get helloChampion => '¡Hola campeón! 👋';

  @override
  String helloUser(Object name) {
    return '¡Hola $name!';
  }

  @override
  String goodMorning(Object name) {
    return '¡Buenos días $name!';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get iAmMathKid => '¡Soy MathKid, tu asistente personal de matemáticas!';

  @override
  String get askMeQuestion => 'Hazme una pregunta';

  @override
  String get aboutAnyMathTopic => '¡Sobre cualquier tema de matemáticas!';

  @override
  String get simpleExplanations => 'Explicaciones simples';

  @override
  String get iExplainComplex => 'Explico conceptos complejos de manera sencilla';

  @override
  String get usernameAlreadyUsed => 'Este nombre ya está en uso';

  @override
  String get usernameUpdated => '¡Tu nombre ha sido actualizado! 🎉';

  @override
  String get usernameTitle => 'Tu nombre de usuario';

  @override
  String get chooseAppearance => 'Elige cómo quieres aparecer';

  @override
  String get usernameExample => 'Ej: SuperMath123';

  @override
  String get usernameInfo => '3-20 caracteres • Visible por todos';

  @override
  String get suggestions => '💡 Sugerencias :';

  @override
  String get generateSuggestions => 'Generar sugerencias';

  @override
  String get chooseMode => 'Elige tu modo';

  @override
  String get howToTrain => '¿Cómo quieres entrenar?';

  @override
  String get normalMode => 'Modo Normal';

  @override
  String get progressiveExercises => '20 ejercicios progresivos';

  @override
  String get infiniteMode => 'Modo Infinito';

  @override
  String get unlimitedTraining => 'Entrenamiento ilimitado';

  @override
  String get selectTheme => 'Selecciona un tema';

  @override
  String themesAvailable(Object count) {
    return '$count temas disponibles';
  }

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get noData => 'No hay datos por el momento';

  @override
  String get retry => 'Reintentar';

  @override
  String get profileUpdated => '¡Perfil actualizado con éxito!';

  @override
  String get choosePhoto => 'Elige tu foto';

  @override
  String get gallery => 'Galería';

  @override
  String get timeBonus => '⏰ ¡+5 segundos añadidos! (-5 💎)';

  @override
  String get themeRelativeNumbers => 'Números Relativos';

  @override
  String get themeFractions => 'Fracciones';

  @override
  String get themeAlgebra => 'Álgebra';

  @override
  String get themePowers => 'Potencias';

  @override
  String get themeTheorems => 'Teoremas';

  @override
  String get themeStatistics => 'Estadística';

  @override
  String get themeAddition => 'Suma';

  @override
  String get themeSubtraction => 'Resta';

  @override
  String get themeMultiplication => 'Multiplicación';

  @override
  String get themeDivision => 'División';

  @override
  String get themeGeometry => 'Geometría';

  @override
  String get welcomeTitle => 'Bienvenido a MathsCool';

  @override
  String get connectToContinue => 'Inicia sesión para continuar';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get min6Chars => 'Mínimo 6 caracteres';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get or => 'O';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get newToMathsCool => '¿Nuevo en MathsCool? ';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get createAccountTitle => 'Crear una cuenta';

  @override
  String get joinMathsCool => 'Únete a MathsCool para comenzar';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get enterUsername => 'Introduce tu nombre de usuario';

  @override
  String get invalidEmail => 'Correo electrónico inválido';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmYourPassword => 'Confirma tu contraseña';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get noLivesTitle => '¡Sin vidas!';

  @override
  String get needRestOrBoost => '¡Necesitas descansar o un impulso! 💖';

  @override
  String get waitForRechargeOrVisitStore => 'Espera a que se recarguen o visita la tienda.';

  @override
  String get later => 'Más tarde';

  @override
  String get recharge => 'Recargar';

  @override
  String get startPlaying => 'Comenzar a jugar';

  @override
  String get emailSent => '¡Correo enviado!';

  @override
  String get checkEmailReset => 'Revisa tu correo para restablecer tu contraseña.';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get enterEmailReset => 'Introduce tu correo para recibir un enlace de restablecimiento';

  @override
  String get sendLink => 'Enviar enlace';

  @override
  String get verificationEmailSent => 'Correo de verificación enviado. Revisa tu bandeja de entrada y carpeta de spam.';

  @override
  String get errorSendingEmail => 'Error al enviar el correo: ';

  @override
  String get verifyYourEmail => 'Verifica tu correo electrónico';

  @override
  String verificationLinkSent(Object email) {
    return 'Se ha enviado un enlace de verificación a $email.';
  }

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String resendIn(Object seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get useAnotherAccount => 'Usar otra cuenta';

  @override
  String get requestLimitReached => 'Límite de solicitudes alcanzado';

  @override
  String get sorryCantRespond => 'Lo siento, no puedo responder ahora. 🤖\n¡Intenta reformular tu pregunta!';

  @override
  String get pauseNeeded => '¡Pausa necesaria! ⏸️';

  @override
  String get usedFreeQuestions => 'Has usado tus 3 preguntas gratuitas de hoy.';

  @override
  String get seeUnlimitedOffers => 'Ver ofertas ilimitadas 🚀';

  @override
  String get comeBackTomorrow => 'Vuelve mañana';

  @override
  String get mathKidAssistant => 'Asistente MathKid';

  @override
  String get alwaysReadyToHelp => '¡Siempre listo para ayudarte!';

  @override
  String get concreteExamples => 'Ejemplos concretos';

  @override
  String get withRealLifeExamples => 'Con ejemplos de la vida real';

  @override
  String get mathKidThinking => 'MathKid está pensando...';

  @override
  String get askMathQuestion => 'Haz tu pregunta de matemáticas...';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String minutesAgo(Object minutes) {
    return 'hace $minutes min';
  }

  @override
  String hoursAgo(Object hours) {
    return 'hace $hours h';
  }

  @override
  String get error => 'Error: ';

  @override
  String get rewardClaimed => '¡Recompensa reclamada! 🎉';

  @override
  String get gemsEarned => 'Ganadas';

  @override
  String get awesome => '¡Increíble! 🎉';

  @override
  String get achievements => 'Logros';

  @override
  String get collectRewards => '¡Reclama tus recompensas! 🏆';

  @override
  String get completed => 'Completado';

  @override
  String get toClaim => 'Por reclamar';

  @override
  String get gemsAvailable => 'Gemas disp.';

  @override
  String get overallProgress => 'Progreso general';

  @override
  String get all => 'Todos';

  @override
  String get noAchievementsToClaim => 'No hay logros por reclamar';

  @override
  String get noCompletedAchievements => 'No hay logros completados';

  @override
  String get startPlayingToUnlock => '¡Comienza a jugar para desbloquear!';

  @override
  String get keepPlayingToEarn => '¡Sigue jugando para ganar más!';

  @override
  String get achievementsWillAppearHere => 'Los logros aparecerán aquí';

  @override
  String get secretAchievement => '???';

  @override
  String get secretAchievementDescription => 'Logro secreto por descubrir...';

  @override
  String get claim => 'Reclamar';

  @override
  String get resultTitle => 'RESULTADO';

  @override
  String get fantastic => '🎉 ¡FANTÁSTICO ! 🎉';

  @override
  String get yourScore => 'TU PUNTUACIÓN';

  @override
  String get pts => 'PTS';

  @override
  String get performance => 'RENDIMIENTO';

  @override
  String starsOutOfThree(Object stars) {
    return '$stars/3 estrellas';
  }

  @override
  String get time => 'Tiempo';

  @override
  String get score => 'Puntuación';

  @override
  String get viewLeaderboard => 'VER CLASIFICACIÓN';

  @override
  String get back => 'ATRÁS';

  @override
  String get wellPlayed => '💪 ¡BIEN JUGADO ! 💪';

  @override
  String get notEnoughGems => '¡No hay suficientes gemas!';

  @override
  String get dailyChallengeTitle => 'Desafío Diario 🎯';

  @override
  String get dailyChallengeSubtitle => '¡Completa tu desafío diario!';

  @override
  String get dailyChallengeSelectLevel => 'Elige tu nivel';

  @override
  String get dailyChallengeForBeginners => 'Para principiantes';

  @override
  String get dailyChallengeFirstCalculations => 'Primeros cálculos';

  @override
  String get dailyChallengeMathBasics => 'Básicos de matemáticas';

  @override
  String get dailyChallengeIntermediateLevel => 'Nivel intermedio';

  @override
  String get dailyChallengeAdvancedLevel => 'Nivel avanzado';

  @override
  String get dailyChallengeExpert => 'Experto';

  @override
  String get dailyChallengeCollegeEntry => 'Entrada al instituto';

  @override
  String get dailyChallengeCentralLevel => 'Nivel central';

  @override
  String get dailyChallengeDeepening => 'Profundización';

  @override
  String get dailyChallengeBrevetPrep => 'Preparación para el diploma';

  @override
  String get dailyChallengeCollege => 'Instituto';

  @override
  String get dailyChallengeNotEnoughGems => '¡No hay suficientes gemas! 💎';

  @override
  String get dailyChallengeNeedGems => 'Necesitas 5 gemas para añadir 5 segundos.';

  @override
  String get dailyChallengeCancel => 'Cancelar';

  @override
  String get dailyChallengeStore => 'Tienda 💎';

  @override
  String get dailyChallengeAddTime => 'Añadir tiempo ⏰';

  @override
  String get dailyChallengeConfirmAddTime => '¿Quieres usar 5 gemas para añadir 5 segundos?';

  @override
  String get dailyChallengeCurrentGems => 'Gemas actuales:';

  @override
  String get dailyChallengeNo => 'No';

  @override
  String get dailyChallengeYes => 'Sí';

  @override
  String get dailyChallengeTimeAdded => '⏰ ¡+5 segundos añadidos! (-5 💎)';

  @override
  String get dailyChallengeTimeUp => '¡Se acabó el tiempo! ⏰';

  @override
  String get dailyChallengeTimeUpMessage => '¡Los 5 minutos han terminado!';

  @override
  String dailyChallengeTimeUpScore(Object score) {
    return 'Puntuación obtenida: $score puntos';
  }

  @override
  String get dailyChallengeFinish => 'Terminar';

  @override
  String get dailyChallengeQuit => 'Salir';

  @override
  String get dailyChallengeQuitConfirm => '¿Realmente quieres salir?';

  @override
  String get dailyChallengeQuitWarning => 'Perderás tu progreso actual.';

  @override
  String get dailyChallengeStay => 'Quedarse';

  @override
  String get dailyChallengeLeave => 'Salir';

  @override
  String get dailyChallengeLostLife => '¡Ups! 💔';

  @override
  String get dailyChallengeLostLifeMessage => '¡Perdiste una vida!';

  @override
  String dailyChallengeLivesRemaining(Object lives) {
    return 'Vidas restantes: $lives';
  }

  @override
  String get dailyChallengeGameOver => '¡Fin del juego! 💔';

  @override
  String get dailyChallengeNoMoreLives => '¡No te quedan vidas!';

  @override
  String get dailyChallengeWaitForLives => 'Espera a que se recarguen tus vidas o consigue algunas en la tienda.';

  @override
  String get dailyChallengeRetry => 'Reintentar';

  @override
  String get dailyChallengeOk => 'OK';

  @override
  String get dailyChallengeCompleted => '¡Desafío ya completado hoy! 🎉';

  @override
  String get dailyChallengeCompletedMessage => '¡Ya has completado el desafío de hoy!';

  @override
  String dailyChallengeCompletedScore(Object score) {
    return 'Puntuación obtenida: $score puntos';
  }

  @override
  String dailyChallengeCompletedTime(Object time) {
    return 'Tiempo: $time';
  }

  @override
  String get dailyChallengeComeBackTomorrow => '¡Vuelve mañana para un nuevo desafío!';

  @override
  String get dailyChallengeBackToHome => 'Volver al inicio';

  @override
  String dailyChallengeScore(Object score) {
    return 'Puntuación: $score';
  }

  @override
  String dailyChallengeQuestion(Object current, Object total) {
    return 'Pregunta $current/$total';
  }

  @override
  String get dailyChallengeNoExercises => 'No hay ejercicios disponibles para este nivel';

  @override
  String get dailyChallengeLoading => 'Cargando desafío...';

  @override
  String get dailyChallengeReportBug => 'Reportar un error 🐛';

  @override
  String get dailyChallengeReportSuccess => '¡Gracias! El error ha sido reportado. 🙏';

  @override
  String get dailyChallengeCheckAnswer => 'Comprobar';

  @override
  String get dailyChallengeNext => 'Siguiente';

  @override
  String get dailyChallengeSaving => 'Guardando...';

  @override
  String get dailyChallengeGoodAnswer => '¡Respuesta correcta! 🎉';

  @override
  String get dailyChallengeWrongAnswer => 'Respuesta incorrecta';

  @override
  String dailyChallengeCorrectAnswer(Object answer) {
    return 'Respuesta: $answer';
  }

  @override
  String get dailyChallengeButtonTitle => 'Desafío Diario';

  @override
  String get dailyChallengeButtonSubtitle => '10 ejercicios • ¡Gana estrellas!';

  @override
  String get dailyChallengeButtonNew => 'NUEVO';

  @override
  String get levelSelectionTitle => 'Elige tu nivel';

  @override
  String get levelSelectionHint => 'Elige el nivel que coincide con tu clase';

  @override
  String get levelForBeginners => 'Para principiantes';

  @override
  String get levelFirstCalculations => 'Primeros cálculos';

  @override
  String get levelMathBasics => 'Básicos de matemáticas';

  @override
  String get levelIntermediate => 'Nivel intermedio';

  @override
  String get levelAdvanced => 'Nivel avanzado';

  @override
  String get levelExpert => 'Experto';

  @override
  String get levelCollegeEntry => 'Entrada al instituto';

  @override
  String get levelCentral => 'Nivel central';

  @override
  String get levelDeepening => 'Profundización';

  @override
  String get levelBrevetPrep => 'Preparación para el diploma';

  @override
  String get levelCollegeBadge => 'Instituto';

  @override
  String get levelCI => 'CI';

  @override
  String get levelCP => 'CP';

  @override
  String get levelCE1 => 'CE1';

  @override
  String get levelCE2 => 'CE2';

  @override
  String get levelCM1 => 'CM1';

  @override
  String get levelCM2 => 'CM2';

  @override
  String get level6eme => '6º ESO';

  @override
  String get level5eme => '5º ESO';

  @override
  String get level4eme => '4º ESO';

  @override
  String get level3eme => '3º ESO';

  @override
  String get generatingInfinite => 'Generando infinito...';

  @override
  String get preparingExercises => 'Preparando ejercicios...';

  @override
  String get exercisesInPreparation => '¡Ejercicios en preparación! 🚧';

  @override
  String teacherPreparing(Object theme) {
    return 'El profesor está preparando temas de $theme';
  }

  @override
  String get indice => 'Pista 💡';

  @override
  String correctAnswerIs(Object answer) {
    return 'La respuesta correcta es: $answer';
  }

  @override
  String get understood => '¡Entendido!';

  @override
  String get notEnoughGemsTitle => 'No hay suficientes Gemas 💎';

  @override
  String missingGemsNeed(Object missing) {
    return 'Te faltan $missing gemas.\n¡Visita la tienda para conseguir algunas!';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get store => 'Tienda 🛒';

  @override
  String get offlineMode => 'Modo sin conexión';

  @override
  String get loadingError => '⚠️ Error de carga';

  @override
  String get goodAnswerColl => '¡Excelente! Respuesta correcta ✅';

  @override
  String get goodAnswerPrim => '¡Bravo! 🥳 Eso es correcto 🎉';

  @override
  String get wrongAnswer => '¡Ups! Perdiste una vida 💔';

  @override
  String get achievementUnlocked => '¡🎉 Logro desbloqueado!';

  @override
  String get noMoreLives => '¡Ay! Sin vidas 💔';

  @override
  String get usedAllLives => 'Has usado todas tus vidas por ahora.';

  @override
  String get waitOrRecover => '¡Puedes esperar a que se recarguen o recuperar algunas ahora!';

  @override
  String get quit => 'Salir';

  @override
  String hintCost(Object gems) {
    return 'Pista ($gems💎)';
  }

  @override
  String skipCost(Object gems) {
    return 'Saltar ($gems💎)';
  }

  @override
  String get expertTitle => '¡🎉 Eres un Experto! 🎉';

  @override
  String get goodJobTitle => '🌟 ¡Buen trabajo! 🌟';

  @override
  String get courageTitle => '🙂 ¡Ánimo!';

  @override
  String get mathkidTitle => '¡🎉 Eres un Mathkid! 🎉';

  @override
  String get onRightTrackTitle => '🌟 ¡Vas por buen camino! 🌟';

  @override
  String get almostMathkidTitle => '🙂 ¡Casi un Mathkid!';

  @override
  String get perfectMastery => '¡Perfecto! Dominas perfectamente. 🎯';

  @override
  String get excellentWork => '¡Excelente trabajo! ¡Sigue así! 💪';

  @override
  String get askForHelp => '¡No dudes en pedir ayuda para mejorar! 📚';

  @override
  String get seeMyProgress => 'Ver mi progreso';

  @override
  String get consultManual => 'Consultar el Manual';

  @override
  String get returnn => 'Volver';

  @override
  String get replay => 'Reintentar';

  @override
  String question(Object number) {
    return 'Pregunta $number';
  }

  @override
  String get dailyChallengeConfirm => 'Confirmar ✨';

  @override
  String get dailyChallengeSeeResult => 'Ver el resultado';

  @override
  String get dailyChallengeQuitText => 'Salir';

  @override
  String dailyChallengeYourGems(Object gems) {
    return 'Tus gemas: $gems';
  }

  @override
  String get dailyChallengeErrorLoading => 'Error al cargar el desafío';

  @override
  String get dailyChallengeNoData => 'No hay datos del desafío disponibles';

  @override
  String get dailyChallengeAlreadyCompleted => '¡Desafío ya completado hoy! 🎉';

  @override
  String get dailyChallengeAlreadyCompletedMessage => '¡Vuelve mañana para un nuevo desafío!';

  @override
  String get dailyChallengeBack => 'Atrás';

  @override
  String get dailyChallengeBrilliantSuccess => '¡Has superado este desafío brillantemente!';

  @override
  String get dailyChallengeKeepProgressing => '¡Sigue así, progresas cada día!';

  @override
  String get dailyChallengePoints => 'puntos';

  @override
  String get dailyChallengeSeconds => 'segundos';

  @override
  String get dailyChallengeViewLeaderboard => 'VER CLASIFICACIÓN';

  @override
  String get dailyChallengeResultBack => 'ATRÁS';

  @override
  String get leaderboardTitle => 'CLASIFICACIÓN';

  @override
  String get leaderboardWelcomeChampion => '¡Bienvenido Campeón!';

  @override
  String get leaderboardToAppearInRanking => 'Para aparecer en la clasificación';

  @override
  String get leaderboardChooseUsername => '¡Elige tu nombre de usuario!';

  @override
  String get leaderboardNameVisibleToAll => 'Tu nombre será visible para todos';

  @override
  String get leaderboardLater => 'Más tarde';

  @override
  String get leaderboardChooseMyName => 'Elegir mi nombre';

  @override
  String get leaderboardLoading => '🏆 Cargando clasificación...';

  @override
  String get leaderboardTabTop => '🏅 TOP 20';

  @override
  String get leaderboardTabMe => '👤 YO';

  @override
  String get leaderboardTabStats => '📊 ESTADÍSTICAS';

  @override
  String get leaderboardNoChampions => '🎯 Aún no hay campeones';

  @override
  String get leaderboardBeTheFirst => '¡Sé el primero en aceptar el desafío!';

  @override
  String get leaderboardYourHistory => '📜 Tu Historial';

  @override
  String get leaderboardYourLegendsWillAppear => '¡Tus hazañas legendarias aparecerán aquí!';

  @override
  String get leaderboardNoStatsYet => '📊 Aún no hay estadísticas';

  @override
  String get leaderboardUnlockStats => '¡Completa tu primer desafío para desbloquear tus estadísticas!';

  @override
  String get leaderboardCurrentStreak => '🔥 Racha Actual';

  @override
  String get leaderboardConsecutiveDays => 'días consecutivos';

  @override
  String get leaderboardTotalStars => '⭐ Estrellas Totales';

  @override
  String get leaderboardStarsCollected => 'estrellas recolectadas';

  @override
  String get leaderboardPersonalRecord => '🏆 Récord Personal';

  @override
  String get leaderboardDaysYourBest => 'días - tu mejor';

  @override
  String get leaderboardPoints => 'puntos';

  @override
  String get leaderboardStars => 'estrellas';

  @override
  String get leaderboardYou => 'TÚ';

  @override
  String get leaderboardEmptyStateTitle => 'No hay datos disponibles';

  @override
  String get leaderboardEmptyStateMessage => '¡Desafíate para aparecer aquí!';

  @override
  String get progressScreen_title => 'Mi Progreso';

  @override
  String get progressScreen_subtitle => '¡Sigue tu evolución! 📊';

  @override
  String get progressScreen_loadingError => 'Error al cargar';

  @override
  String get progressChart_byCategory => 'Progreso por categoría';

  @override
  String get progressChart_byGrade => 'Progreso por nivel escolar';

  @override
  String get progressScreen_byCategory => 'Por categoría';

  @override
  String get progressScreen_byGrade => 'Por nivel escolar';

  @override
  String get mathKidBadge_title => '🎯 MATHKID 🎯';

  @override
  String get mathKidBadge_champion => '¡Súper Campeón!';

  @override
  String get badgesSection_title => 'Mis Insignias';

  @override
  String badgesSection_count(Object earned, Object total) {
    return '$earned/$total insignias obtenidas';
  }

  @override
  String get badgesSection_allUnlocked => '🎉 ¡Todas las insignias desbloqueadas! ¡Campeón!';

  @override
  String badgesSection_continueToUnlock(Object plural, Object remaining) {
    return '¡Continúa para desbloquear $remaining insignia$plural!';
  }

  @override
  String get badgesSection_startPlaying => '¡Comienza a resolver ejercicios para ganar tus primeras insignias!';

  @override
  String get badgesSection_awesome => '¡Increíble! ¡Sigue así para desbloquear todas las insignias!';

  @override
  String get badgesSection_champion => '¡Bravo! Eres un verdadero campeón. 🌟';

  @override
  String get badgesSection_tipStart => '¡Comienza a resolver ejercicios para ganar tus primeras insignias!';

  @override
  String get badgesSection_tipKeepGoing => '¡Increíble! ¡Sigue así para desbloquear todas las insignias!';

  @override
  String get badgesSection_tipChampion => '¡Bravo! Eres un verdadero campeón. 🌟';

  @override
  String get badge => 'insignia';

  @override
  String get badges => 'insignias';

  @override
  String get earned => 'obtenida(s)';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get profileManageInfo => 'Gestiona tu información y accede a tus estadísticas';

  @override
  String get profileMenu => 'Menú Principal';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileFirstnamePseudo => 'Nombre / Usuario';

  @override
  String get profileClass => 'Clase';

  @override
  String get profileSchool => 'Colegio';

  @override
  String get profileMottoHobby => 'Lema o Afición';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileSave => 'Guardar';

  @override
  String get profileUpdateSuccess => '¡Perfil actualizado con éxito!';

  @override
  String get profileError => 'Error: ';

  @override
  String get profileChoosePhoto => 'Elige tu foto';

  @override
  String get profileGallery => 'Galería';

  @override
  String get profileSchoolInfo => 'Información del Colegio';

  @override
  String get profileInstitution => 'Institución';

  @override
  String get profileStudentNumber => 'N° de Estudiante';

  @override
  String get profileSchoolYear => 'Año Escolar';

  @override
  String get profileMotto => 'Lema';

  @override
  String get profileLevelNotDefined => 'Nivel no definido';

  @override
  String get profileFieldRequired => 'Este campo es obligatorio';

  @override
  String get profileLeaderboards => 'Clasificaciones';

  @override
  String get profileMyProgress => 'Mi Progreso';

  @override
  String get profileStore => 'Tienda';

  @override
  String get profileHelpCenter => 'Centro de Ayuda';

  @override
  String get profileSoundMusic => 'Sonido y Música';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileBackHome => 'Volver al Inicio';

  @override
  String get notificationSettingsTitle => 'Mis Notificaciones';

  @override
  String get notificationConfigureReminders => '¡Configura tus recordatorios para no perderte nunca tus sesiones de matemáticas!';

  @override
  String get notificationScheduleReminder => 'Programar un recordatorio';

  @override
  String get notificationReminderTime => 'Hora del recordatorio';

  @override
  String get notificationHour => 'Hora';

  @override
  String get notificationMinute => 'Minuto';

  @override
  String get notificationRepeatDaily => 'Repetir diariamente';

  @override
  String get notificationSchedule => 'Programar';

  @override
  String notificationScheduledAt(Object hour, Object minute) {
    return '¡Notificación programada a las ${hour}h$minute ! ⏰';
  }

  @override
  String get notificationDeleted => 'Notificación eliminada';

  @override
  String get notificationsEnabled => 'Notificaciones activadas';

  @override
  String get notificationsDisabled => 'Notificaciones desactivadas';

  @override
  String get iWillReceiveReminders => 'Recibiré recordatorios';

  @override
  String get noRemindersWillBeSent => 'No se enviarán recordatorios';

  @override
  String get notificationsActivated => '¡Notificaciones activadas ! 📱';

  @override
  String get notificationsDeactivated => 'Notificaciones desactivadas';

  @override
  String get pleaseAllowExactAlarms => 'Por favor, permite alarmas exactas en tus ajustes.';

  @override
  String get scheduledReminders => 'Recordatorios programados';

  @override
  String get daily => 'Diario';

  @override
  String get once => 'Una vez';

  @override
  String get activeReminders => 'Recordatorios activos';

  @override
  String get dailyReminders => 'Diarios';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get tipsForUsingReminders => 'Consejos para usar tus recordatorios';

  @override
  String get tip1 => '🕐 Programa tus sesiones cuando estés más concentrado';

  @override
  String get tip2 => '🔄 Activa recordatorios diarios para crear una rutina';

  @override
  String get newReminder => 'Nuevo recordatorio';

  @override
  String get fieldRequired => 'Obligatorio';

  @override
  String get fieldInvalid => 'Inválido';

  @override
  String get programNotification => 'Programar una notificación';

  @override
  String get soundSettingsTitle => 'Ajustes de Sonido 🎵';

  @override
  String get soundSettingsSubtitle => 'Personaliza tus sonidos';

  @override
  String get soundEffects => 'Efectos de sonido';

  @override
  String get soundEffectsActive => 'Activos';

  @override
  String get soundEffectsDisabled => 'Desactivados';

  @override
  String get backgroundMusic => 'Música de fondo';

  @override
  String get backgroundMusicActive => 'Activa';

  @override
  String get backgroundMusicDisabled => 'Desactivada';

  @override
  String get sfxVolume => 'Volumen efectos';

  @override
  String get musicVolume => 'Volumen música';

  @override
  String get storeTitle => '🏪 TIENDA';

  @override
  String get storeTabLives => 'Vidas';

  @override
  String get storeTabGems => 'Gemas';

  @override
  String get unlimitedLivesWeek => '¡Semana Ilimitada ! ♾️';

  @override
  String get unlimitedLivesDescription => '¡Disfruta 7 días sin perder vidas!';

  @override
  String get chatbotActivated => '¡Asistente Activado! 🤖';

  @override
  String get chatbotReadyToHelp => '¡MathKid está listo para ayudarte!';

  @override
  String gemsReceived(Object icon) {
    return '¡Gemas Recibidas! $icon';
  }

  @override
  String gemsReceivedCount(Object count) {
    return '¡Recibiste $count gemas!';
  }

  @override
  String get livesRefilled => '¡Vidas rellenadas! 🎉';

  @override
  String get readyToContinue => '¡Estás listo para continuar la aventura!';

  @override
  String storeError(Object error) {
    return 'Ups: $error';
  }

  @override
  String get storeSuccess => '¡Genial!';

  @override
  String get storeUnlimitedLives => '¡Vidas Ilimitadas!';

  @override
  String get storeMyLives => 'Mis Vidas';

  @override
  String get storeUnlimitedDescription => '¡Eres invencible esta semana! 🦸';

  @override
  String storeNextLife(Object time) {
    return 'Próxima vida: $time';
  }

  @override
  String get storeSectionLivesBoosts => '💖 Vidas y Potenciadores';

  @override
  String get storeSectionGemPacks => '💎 Paquetes de Gemas';

  @override
  String get storeNoProducts => 'No hay productos disponibles...';

  @override
  String get storeTryAgain => 'Intentar de nuevo';

  @override
  String get storeInfoTitle => 'Para saber';

  @override
  String storeMaxLives(Object count) {
    return 'Máx. $count vidas almacenadas';
  }

  @override
  String storeLifeRegeneration(Object minutes) {
    return '1 vida regenerada cada $minutes minutos';
  }

  @override
  String get storeUnlimitedMode => '¡Modo infinito = Sin pérdida de vidas!';

  @override
  String get storeGemsInfoTitle => '¿Para qué sirven las Gemas?';

  @override
  String storeHintCost(Object gems) {
    return 'Pista: $gems gemas';
  }

  @override
  String storeSkipQuestionCost(Object gems) {
    return 'Saltar una pregunta: $gems gemas';
  }

  @override
  String storeFastRechargeCost(Object gems) {
    return 'Recarga rápida de vida: $gems gemas';
  }

  @override
  String storeUnlockThemesCost(Object gems) {
    return 'Desbloquear temas: $gems gemas';
  }

  @override
  String get storeBadgePopular => 'Popular 🔥';

  @override
  String get storeBadgeBestOffer => 'Mejor Oferta 🌟';

  @override
  String get storeBadgeNew => 'Nuevo 🤖';

  @override
  String get storeBadgeBestValue => 'Mejor Valor 💎';

  @override
  String get updateRequiredTitle => '¡Actualización requerida! 🚀';

  @override
  String get updateNewVersionAvailable => 'Nueva versión disponible';

  @override
  String get updateAppImproving => '¡MathsCool está mejorando!';

  @override
  String get updateDescription => 'Para disfrutar de las últimas funciones y continuar tu aventura matemática, ¡actualiza la app ahora!';

  @override
  String get updateWhatsNew => 'Novedades:';

  @override
  String get updateFeatureInfiniteMode => '♾️ Modo Infinito';

  @override
  String get updateFeatureAchievements => '🏆 60+ Logros';

  @override
  String get updateFeatureModernDesign => '🎨 Diseño moderno';

  @override
  String get updateFeatureAIAssistant => '🤖 Asistente de IA';

  @override
  String get updateButton => 'Actualizar ahora';

  @override
  String updateVersionRequired(Object version) {
    return 'Versión $version requerida';
  }

  @override
  String get updateDontMissFeatures => '✨ ¡No te pierdas las nuevas funciones! ✨';

  @override
  String get chatbotLimitReached => '¡Límite alcanzado! 🚀';

  @override
  String get chatbotFreeQuestionsUsed => '¡Has usado tus 3 preguntas gratuitas de hoy!';

  @override
  String get chatbotSubscribePrompt => '¡Suscríbete para hacer todas las preguntas que quieras a MathKid! 🚀';

  @override
  String get chatbotLater => 'Más tarde';

  @override
  String get chatbotDiscover => 'Descubrir ✨';

  @override
  String get gemsMyGems => 'Mis Gemas';

  @override
  String get gemsCurrent => 'Actuales';

  @override
  String get gemsSpent => 'Gastadas';

  @override
  String get progressChartTitle => 'Mi progreso';

  @override
  String get progressNoData => 'No hay datos por el momento';

  @override
  String themeBadgeLevel(Object level) {
    return 'Niv.$level';
  }

  @override
  String get themeBadgeLocked => 'Bloqueado';

  @override
  String get chooseYourLanguage => 'Elige tu idioma 🌍';

  @override
  String get questionSkipped => '¡Pregunta saltada! ⏭️';

  @override
  String get storeHintLabel => 'Pista 💡';

  @override
  String get achievementFirstSteps => 'Primeros pasos';

  @override
  String get achievementFirstStepsDesc => 'Resuelve tu primer ejercicio';

  @override
  String get achievementGettingStarted => '¡En camino!';

  @override
  String get achievementGettingStartedDesc => 'Resuelve 5 ejercicios';

  @override
  String get achievementOnTrack => 'En el buen camino';

  @override
  String get achievementOnTrackDesc => 'Resuelve 15 ejercicios';

  @override
  String get achievementBeginner => 'Principiante';

  @override
  String get achievementBeginnerDesc => 'Resuelve 25 ejercicios';

  @override
  String get achievementLearner => 'Aprendiz';

  @override
  String get achievementLearnerDesc => 'Resuelve 50 ejercicios';

  @override
  String get achievementStudent => 'Estudiante aplicado';

  @override
  String get achievementStudentDesc => 'Resuelve 75 ejercicios';

  @override
  String get achievementSkilled => 'Competente';

  @override
  String get achievementSkilledDesc => 'Resuelve 100 ejercicios';

  @override
  String get achievementExpert => 'Experto';

  @override
  String get achievementExpertDesc => 'Resuelve 150 ejercicios';

  @override
  String get achievementMaster => 'Maestro';

  @override
  String get achievementMasterDesc => 'Resuelve 200 ejercicios';

  @override
  String get achievementChampion => 'Campeón';

  @override
  String get achievementChampionDesc => 'Resuelve 300 ejercicios';

  @override
  String get achievementLegend => 'Leyenda';

  @override
  String get achievementLegendDesc => 'Resuelve 500 ejercicios';

  @override
  String get achievementPerfectionist => 'Perfeccionista';

  @override
  String get achievementPerfectionistDesc => 'Obtén una puntuación perfecta';

  @override
  String get achievementFlawlessTrio => 'Trío perfecto';

  @override
  String get achievementFlawlessTrioDesc => 'Obtén 3 puntuaciones perfectas';

  @override
  String get achievementPerfectFive => 'Mano perfecta';

  @override
  String get achievementPerfectFiveDesc => 'Obtén 5 puntuaciones perfectas';

  @override
  String get achievementPerfectTen => 'Perfección absoluta';

  @override
  String get achievementPerfectTenDesc => 'Obtén 10 puntuaciones perfectas';

  @override
  String get achievementPerfectMaster => 'Maestro perfecto';

  @override
  String get achievementPerfectMasterDesc => 'Obtén 20 puntuaciones perfectas';

  @override
  String get achievementDailyPlayer => 'Jugador diario';

  @override
  String get achievementDailyPlayerDesc => 'Juega 3 días seguidos';

  @override
  String get achievementCommitted => 'Comprometido';

  @override
  String get achievementCommittedDesc => 'Juega 5 días seguidos';

  @override
  String get achievementWeeklyWarrior => 'Guerrero semanal';

  @override
  String get achievementWeeklyWarriorDesc => 'Juega 7 días seguidos';

  @override
  String get achievementTwoWeeks => 'Luchador quincenal';

  @override
  String get achievementTwoWeeksDesc => 'Juega 14 días seguidos';

  @override
  String get achievementMonthlyMaster => 'Maestro mensual';

  @override
  String get achievementMonthlyMasterDesc => 'Juega 30 días seguidos';

  @override
  String get achievementInfiniteBeginner => 'Infinito principiante';

  @override
  String get achievementInfiniteBeginnerDesc => 'Resuelve 25 ejercicios en modo infinito';

  @override
  String get achievementInfiniteExplorer => 'Explorador infinito';

  @override
  String get achievementInfiniteExplorerDesc => 'Resuelve 50 ejercicios en modo infinito';

  @override
  String get achievementInfiniteWarrior => 'Guerrero infinito';

  @override
  String get achievementInfiniteWarriorDesc => 'Resuelve 100 ejercicios en modo infinito';

  @override
  String get achievementInfiniteMaster => 'Maestro del infinito';

  @override
  String get achievementInfiniteMasterDesc => 'Resuelve 200 ejercicios en modo infinito';

  @override
  String get achievementNightOwl => 'Búho nocturno';

  @override
  String get achievementNightOwlDesc => 'Juega entre medianoche y las 6 AM';

  @override
  String get achievementEarlyBird => 'Madrugador';

  @override
  String get achievementEarlyBirdDesc => 'Juega entre las 5 AM y las 7 AM';

  @override
  String get achievementWeekendWarrior => 'Guerrero de fin de semana';

  @override
  String get achievementWeekendWarriorDesc => 'Juega todos los fines de semana durante un mes';

  @override
  String get achievementLuckySeven => 'Siete afortunado';

  @override
  String get achievementLuckySevenDesc => 'Resuelve 777 ejercicios';

  @override
  String get notifMotivational1 => '¡Es hora de hacer matemáticas mágicas! ✨';

  @override
  String get notifMotivational2 => '¡Tus amigos los números te esperan! 🔢';

  @override
  String get notifMotivational3 => '¡Ven a descubrir nuevos desafíos matemáticos! 🎯';

  @override
  String get notifMotivational4 => '¡Es hora de convertirse en un superhéroe de las matemáticas! 🦸‍♂️';

  @override
  String get notifMotivational5 => '¡Las ecuaciones te llaman! ¿Listo para jugar? 🎮';

  @override
  String get notifMotivational6 => '¡Transfórmate en un genio de las matemáticas! 🧠';

  @override
  String get notifMotivational7 => '¡Una nueva aventura matemática te espera! 🌟';

  @override
  String get notifMotivational8 => '¡Ven a mostrar tus talentos matemáticos! 💪';

  @override
  String get notifMotivational9 => '¡Vamos a una sesión de matemáticas divertida! 🎉';

  @override
  String get notifMotivational10 => '¡Tus neuronas quieren calcular! 🧮';

  @override
  String get notifMotivational11 => '¡Los números han preparado sorpresas para ti! 🎁';

  @override
  String get notifMotivational12 => '¿Listo para resolver misterios matemáticos? 🔍';

  @override
  String get notifMotivational13 => '¡Es hora de hacer brillar tu cerebro! ✨';

  @override
  String get notifMotivational14 => '¡Ven a coleccionar nuevos logros! 🏆';

  @override
  String get notifMotivational15 => '¡Una dosis de matemáticas para empezar bien! ☀️';

  @override
  String get notifMotivational16 => '¡Una nueva lección te espera! 🌟';

  @override
  String get notifMotivational17 => '¿Listo para tu sesión de aprendizaje? 💫';

  @override
  String get notifAchievement1 => '🏆 Psst... ¡Puede que te espere un nuevo trofeo!';

  @override
  String get notifAchievement2 => '🥇 ¡Ven a desbloquear tu próxima insignia Experto!';

  @override
  String get notifAchievement3 => '🚀 ¡Estás cerca de la meta! Ven a progresar en tus logros.';

  @override
  String get notifAchievement4 => '🔥 ¡Mantén el ritmo! Nuevas recompensas están disponibles.';

  @override
  String get notifAchievement5 => '👑 ¡Conviértete en el Rey de la categoría hoy!';

  @override
  String get notifAchievement6 => '🎯 Objetivo a la vista: ¡Ven a completar tus misiones!';

  @override
  String get notifAchievement7 => '🌟 Tus insignias se sienten solas... ¡Ven a ganar más!';

  @override
  String get notifAchievement8 => '💪 ¡Muéstranos tus talentos y gana vidas!';

  @override
  String get notifDailyChallenge1 => '⏰ ¡El desafío del día expira pronto! ¡No te lo pierdas!';

  @override
  String get notifDailyChallenge2 => '🎯 ¡Un desafío crujiente te espera hoy!';

  @override
  String get notifDailyChallenge3 => '🔥 ¡Tu desafío diario está listo! ¡Ven a conquistarlo!';

  @override
  String get notifDailyChallenge4 => '⭐ ¡Gana estrellas con el desafío de hoy!';

  @override
  String get notifDailyChallenge5 => '🚀 ¡El desafío del día impulsará tu clasificación!';

  @override
  String get notifDailyChallenge6 => '💎 ¡Un desafío único para ti hoy! ¡Vamos!';

  @override
  String get notifDailyChallenge7 => '🎪 ¡El desafío del día ha llegado! ¡Tu turno de jugar!';

  @override
  String get notifDailyChallenge8 => '⚡ Desafío relámpago: ¡Muestra lo que vales hoy!';

  @override
  String get notifDailyChallenge9 => '🎁 Regalo del día: ¡Un súper desafío solo para ti!';

  @override
  String get notifDailyChallenge10 => '🌟 ¡Completa el desafío e ilumina la clasificación!';

  @override
  String notifLeaderboard1(Object name) {
    return '🏆 ¡No dejes que $name bata tu récord!';
  }

  @override
  String notifLeaderboard2(Object name) {
    return '👑 ¡$name te adelanta en la clasificación! ¡Alcánzalo!';
  }

  @override
  String notifLeaderboard3(Object name) {
    return '⚔️ ¡Duelo en la cima con $name! ¿Quién será el n°1?';
  }

  @override
  String notifLeaderboard4(Object name) {
    return '🥇 ¡$name obtuvo una puntuación perfecta! ¡Tu turno de hacerlo mejor!';
  }

  @override
  String notifLeaderboard5(Object name) {
    return '📈 ¡$name sube rápido! ¡Defiende tu posición!';
  }

  @override
  String notifLeaderboard6(Object name) {
    return '💪 ¡$name está justo delante de ti! ¡Supéralo!';
  }

  @override
  String notifLeaderboard7(Object name) {
    return '🎯 $name apunta al podio, ¿y tú?';
  }

  @override
  String notifLeaderboard8(Object name) {
    return '🔥 ¡$name ganó 3 estrellas! ¡Iguala su puntuación!';
  }

  @override
  String notifLeaderboard9(Object name) {
    return '⭐ ¡$name brilla en la clasificación! ¡Muestra tu talento!';
  }

  @override
  String notifLeaderboard10(Object name) {
    return '🚀 ¡$name está lanzado! ¡No te quedes atrás!';
  }

  @override
  String get notifChannelAchievements => 'Recordatorios de Trofeos';

  @override
  String get notifChannelAchievementsDesc => 'Recordatorios para desbloquear logros e insignias';

  @override
  String get notifChannelDailyChallenge => 'Desafío Diario';

  @override
  String get notifChannelDailyChallengeDesc => 'Recordatorios para el desafío del día';

  @override
  String get notifChannelLeaderboard => 'Clasificación';

  @override
  String get notifChannelLeaderboardDesc => 'Recordatorios para subir en la clasificación';

  @override
  String get notifChannelLives => 'Vidas Recargadas';

  @override
  String get notifChannelLivesDesc => 'Notificaciones cuando las vidas están completas';

  @override
  String get notifChannelImmediate => 'Notificaciones inmediatas';

  @override
  String get notifTitleAchievements => '¡Nuevos logros disponibles! 🏆';

  @override
  String get notifTitleDailyChallenge => '¡Desafío Diario disponible! 🎯';

  @override
  String get notifTitleLeaderboard => '¡Sube en la clasificación! 🏅';

  @override
  String get notifTitleLivesRefilled => '¡Vidas al máximo! ❤️';

  @override
  String notifBodyLivesRefilled(Object name) {
    return '¡Hola $name, tus vidas están recargadas! ¡Ven a jugar! 🎮';
  }
}
