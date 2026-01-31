// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '数学酷';

  @override
  String get helloChampion => '你好，冠军！👋';

  @override
  String helloUser(Object name) {
    return '你好 $name！';
  }

  @override
  String goodMorning(Object name) {
    return '你好 $name！';
  }

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get french => '法语';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get iAmMathKid => '我是数学小子，你的个人数学助手！';

  @override
  String get askMeQuestion => '问我问题';

  @override
  String get aboutAnyMathTopic => '关于任何数学主题！';

  @override
  String get simpleExplanations => '简单解释';

  @override
  String get iExplainComplex => '我用简单的方式解释复杂的概念';

  @override
  String get usernameAlreadyUsed => '此名称已被使用';

  @override
  String get usernameUpdated => '你的名字已更新！🎉';

  @override
  String get usernameTitle => '你的用户名';

  @override
  String get chooseAppearance => '选择你想要的显示方式';

  @override
  String get usernameExample => '例如：超级数学123';

  @override
  String get usernameInfo => '3-20个字符 • 所有人可见';

  @override
  String get suggestions => '💡 建议：';

  @override
  String get generateSuggestions => '生成建议';

  @override
  String get chooseMode => '选择你的模式';

  @override
  String get howToTrain => '你想如何训练？';

  @override
  String get normalMode => '普通模式';

  @override
  String get progressiveExercises => '20道渐进式练习';

  @override
  String get infiniteMode => '无限模式';

  @override
  String get unlimitedTraining => '无限训练';

  @override
  String get selectTheme => '选择主题';

  @override
  String themesAvailable(Object count) {
    return '$count个主题可用';
  }

  @override
  String get comingSoon => '即将推出';

  @override
  String get noData => '暂无数据';

  @override
  String get retry => '重试';

  @override
  String get profileUpdated => '个人资料更新成功！';

  @override
  String get choosePhoto => '选择你的照片';

  @override
  String get gallery => '相册';

  @override
  String get timeBonus => '⏰ +5秒已添加！（-5 💎）';

  @override
  String get themeRelativeNumbers => '相对数';

  @override
  String get themeFractions => '分数';

  @override
  String get themeAlgebra => '代数';

  @override
  String get themePowers => '幂次';

  @override
  String get themeTheorems => '定理';

  @override
  String get themeStatistics => '统计';

  @override
  String get themeAddition => '加法';

  @override
  String get themeSubtraction => '减法';

  @override
  String get themeMultiplication => '乘法';

  @override
  String get themeDivision => '除法';

  @override
  String get themeGeometry => '几何';

  @override
  String get welcomeTitle => '欢迎来到数学酷';

  @override
  String get connectToContinue => '登录以继续';

  @override
  String get emailAddress => '电子邮件地址';

  @override
  String get password => '密码';

  @override
  String get min6Chars => '最少6个字符';

  @override
  String get login => '登录';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get or => '或';

  @override
  String get continueWithGoogle => '使用Google继续';

  @override
  String get newToMathsCool => '初次使用数学酷？';

  @override
  String get createAccount => '创建账户';

  @override
  String get createAccountTitle => '创建账户';

  @override
  String get joinMathsCool => '加入数学酷开始学习';

  @override
  String get username => '用户名';

  @override
  String get enterUsername => '输入你的用户名';

  @override
  String get invalidEmail => '无效的电子邮件';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get confirmYourPassword => '确认你的密码';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get noLivesTitle => '没有生命值了！';

  @override
  String get needRestOrBoost => '你需要休息或增强！💖';

  @override
  String get waitForRechargeOrVisitStore => '等待充电或访问商店。';

  @override
  String get later => '稍后';

  @override
  String get recharge => '充电';

  @override
  String get startPlaying => '开始游戏';

  @override
  String get emailSent => '邮件已发送！';

  @override
  String get checkEmailReset => '查看你的邮箱以重置密码。';

  @override
  String get backToLogin => '返回登录';

  @override
  String get forgotPasswordTitle => '忘记密码？';

  @override
  String get enterEmailReset => '输入你的电子邮件以接收重置链接';

  @override
  String get sendLink => '发送链接';

  @override
  String get verificationEmailSent => '验证邮件已发送。请检查收件箱和垃圾邮件文件夹。';

  @override
  String get errorSendingEmail => '发送邮件时出错：';

  @override
  String get verifyYourEmail => '验证你的电子邮件';

  @override
  String verificationLinkSent(Object email) {
    return '验证链接已发送至 $email。';
  }

  @override
  String get resendEmail => '重新发送邮件';

  @override
  String resendIn(Object seconds) {
    return '$seconds秒后重新发送';
  }

  @override
  String get useAnotherAccount => '使用其他账户';

  @override
  String get requestLimitReached => '已达到请求限制';

  @override
  String get sorryCantRespond => '抱歉，我现在无法回复。🤖\n试着重新表述你的问题！';

  @override
  String get pauseNeeded => '需要暂停！⏸️';

  @override
  String get usedFreeQuestions => '你已使用今天的3个免费问题。';

  @override
  String get seeUnlimitedOffers => '查看无限优惠 🚀';

  @override
  String get comeBackTomorrow => '明天再来';

  @override
  String get mathKidAssistant => '数学小子助手';

  @override
  String get alwaysReadyToHelp => '随时准备帮助你！';

  @override
  String get concreteExamples => '具体例子';

  @override
  String get withRealLifeExamples => '带有现实生活例子';

  @override
  String get mathKidThinking => '数学小子正在思考...';

  @override
  String get askMathQuestion => '问你的数学问题...';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分钟前';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours小时前';
  }

  @override
  String get error => '错误：';

  @override
  String get rewardClaimed => '奖励已领取！🎉';

  @override
  String get gemsEarned => '已获得';

  @override
  String get awesome => '太棒了！🎉';

  @override
  String get achievements => '成就';

  @override
  String get collectRewards => '收集你的奖励！🏆';

  @override
  String get completed => '已完成';

  @override
  String get toClaim => '待领取';

  @override
  String get gemsAvailable => '可用宝石';

  @override
  String get overallProgress => '总体进度';

  @override
  String get all => '全部';

  @override
  String get noAchievementsToClaim => '没有可领取的成就';

  @override
  String get noCompletedAchievements => '没有已完成的成就';

  @override
  String get startPlayingToUnlock => '开始游戏以解锁！';

  @override
  String get keepPlayingToEarn => '继续游戏以获得更多！';

  @override
  String get achievementsWillAppearHere => '成就将在这里显示';

  @override
  String get secretAchievement => '？？？';

  @override
  String get secretAchievementDescription => '待发现的秘密成就...';

  @override
  String get claim => '领取';

  @override
  String get resultTitle => '结果';

  @override
  String get fantastic => '🎉 太棒了！🎉';

  @override
  String get yourScore => '你的分数';

  @override
  String get pts => '分';

  @override
  String get performance => '表现';

  @override
  String starsOutOfThree(Object stars) {
    return '$stars/3星';
  }

  @override
  String get time => '时间';

  @override
  String get score => '分数';

  @override
  String get viewLeaderboard => '查看排行榜';

  @override
  String get back => '返回';

  @override
  String get wellPlayed => '💪 玩得好！💪';

  @override
  String get notEnoughGems => '宝石不足！';

  @override
  String get dailyChallengeTitle => '每日挑战 🎯';

  @override
  String get dailyChallengeSubtitle => '完成你的每日挑战！';

  @override
  String get dailyChallengeSelectLevel => '选择你的级别';

  @override
  String get dailyChallengeForBeginners => '适合初学者';

  @override
  String get dailyChallengeFirstCalculations => '第一次计算';

  @override
  String get dailyChallengeMathBasics => '数学基础';

  @override
  String get dailyChallengeIntermediateLevel => '中级水平';

  @override
  String get dailyChallengeAdvancedLevel => '高级水平';

  @override
  String get dailyChallengeExpert => '专家';

  @override
  String get dailyChallengeCollegeEntry => '初中入门';

  @override
  String get dailyChallengeCentralLevel => '中级水平';

  @override
  String get dailyChallengeDeepening => '深化';

  @override
  String get dailyChallengeBrevetPrep => '文凭准备';

  @override
  String get dailyChallengeCollege => '初中';

  @override
  String get dailyChallengeNotEnoughGems => '宝石不足！💎';

  @override
  String get dailyChallengeNeedGems => '你需要5颗宝石来增加5秒。';

  @override
  String get dailyChallengeCancel => '取消';

  @override
  String get dailyChallengeStore => '商店 💎';

  @override
  String get dailyChallengeAddTime => '增加时间 ⏰';

  @override
  String get dailyChallengeConfirmAddTime => '你想使用5颗宝石增加5秒吗？';

  @override
  String get dailyChallengeCurrentGems => '当前宝石：';

  @override
  String get dailyChallengeNo => '否';

  @override
  String get dailyChallengeYes => '是';

  @override
  String get dailyChallengeTimeAdded => '⏰ +5秒已添加！（-5 💎）';

  @override
  String get dailyChallengeTimeUp => '时间到！⏰';

  @override
  String get dailyChallengeTimeUpMessage => '5分钟已结束！';

  @override
  String dailyChallengeTimeUpScore(Object score) {
    return '获得分数：$score分';
  }

  @override
  String get dailyChallengeFinish => '完成';

  @override
  String get dailyChallengeQuit => '退出';

  @override
  String get dailyChallengeQuitConfirm => '你真的想退出吗？';

  @override
  String get dailyChallengeQuitWarning => '你将失去当前进度。';

  @override
  String get dailyChallengeStay => '留下';

  @override
  String get dailyChallengeLeave => '离开';

  @override
  String get dailyChallengeLostLife => '哎呀！💔';

  @override
  String get dailyChallengeLostLifeMessage => '你失去了一条生命！';

  @override
  String dailyChallengeLivesRemaining(Object lives) {
    return '剩余生命：$lives';
  }

  @override
  String get dailyChallengeGameOver => '游戏结束！💔';

  @override
  String get dailyChallengeNoMoreLives => '你没有生命值了！';

  @override
  String get dailyChallengeWaitForLives => '等待生命值充电或从商店获取。';

  @override
  String get dailyChallengeRetry => '重试';

  @override
  String get dailyChallengeOk => '确定';

  @override
  String get dailyChallengeCompleted => '今天的挑战已完成！🎉';

  @override
  String get dailyChallengeCompletedMessage => '你已经完成了今天的挑战！';

  @override
  String dailyChallengeCompletedScore(Object score) {
    return '获得分数：$score分';
  }

  @override
  String dailyChallengeCompletedTime(Object time) {
    return '时间：$time';
  }

  @override
  String get dailyChallengeComeBackTomorrow => '明天再来接受新挑战！';

  @override
  String get dailyChallengeBackToHome => '返回主页';

  @override
  String dailyChallengeScore(Object score) {
    return '分数：$score';
  }

  @override
  String dailyChallengeQuestion(Object current, Object total) {
    return '问题 $current/$total';
  }

  @override
  String get dailyChallengeNoExercises => '此级别没有可用练习';

  @override
  String get dailyChallengeLoading => '加载挑战中...';

  @override
  String get dailyChallengeReportBug => '报告错误 🐛';

  @override
  String get dailyChallengeReportSuccess => '谢谢！错误已报告。🙏';

  @override
  String get dailyChallengeCheckAnswer => '检查';

  @override
  String get dailyChallengeNext => '下一个';

  @override
  String get dailyChallengeSaving => '保存中...';

  @override
  String get dailyChallengeGoodAnswer => '正确答案！🎉';

  @override
  String get dailyChallengeWrongAnswer => '错误答案';

  @override
  String dailyChallengeCorrectAnswer(Object answer) {
    return '答案：$answer';
  }

  @override
  String get dailyChallengeButtonTitle => '每日挑战';

  @override
  String get dailyChallengeButtonSubtitle => '10道练习 • 赢取星星！';

  @override
  String get dailyChallengeButtonNew => '新';

  @override
  String get levelSelectionTitle => '选择你的级别';

  @override
  String get levelSelectionHint => '选择符合你年级的级别';

  @override
  String get levelForBeginners => '适合初学者';

  @override
  String get levelFirstCalculations => '第一次计算';

  @override
  String get levelMathBasics => '数学基础';

  @override
  String get levelIntermediate => '中级水平';

  @override
  String get levelAdvanced => '高级水平';

  @override
  String get levelExpert => '专家';

  @override
  String get levelCollegeEntry => '初中入门';

  @override
  String get levelCentral => '中级水平';

  @override
  String get levelDeepening => '深化';

  @override
  String get levelBrevetPrep => '文凭准备';

  @override
  String get levelCollegeBadge => '初中';

  @override
  String get generatingInfinite => '生成无限练习中...';

  @override
  String get preparingExercises => '准备练习中...';

  @override
  String get exercisesInPreparation => '练习准备中！🚧';

  @override
  String teacherPreparing(Object theme) {
    return '老师正在准备$theme题目';
  }

  @override
  String get indice => '提示 💡';

  @override
  String correctAnswerIs(Object answer) {
    return '正确答案是：$answer';
  }

  @override
  String get understood => '明白了！';

  @override
  String get notEnoughGemsTitle => '宝石不足 💎';

  @override
  String missingGemsNeed(Object missing) {
    return '你缺少$missing颗宝石。\n访问商店获取！';
  }

  @override
  String get close => '关闭';

  @override
  String get store => '商店 🛒';

  @override
  String get offlineMode => '离线模式';

  @override
  String get loadingError => '⚠️ 加载错误';

  @override
  String get goodAnswerColl => '优秀！正确答案 ✅';

  @override
  String get goodAnswerPrim => '太棒了！🥳 正确 🎉';

  @override
  String get wrongAnswer => '哎呀！你失去了一条生命 💔';

  @override
  String get achievementUnlocked => '🎉 成就解锁！';

  @override
  String get noMoreLives => '哎呀！没有生命值了 💔';

  @override
  String get usedAllLives => '你已用完所有生命值。';

  @override
  String get waitOrRecover => '你可以等待充电或立即恢复！';

  @override
  String get quit => '退出';

  @override
  String hintCost(Object gems) {
    return '提示（$gems💎）';
  }

  @override
  String skipCost(Object gems) {
    return '跳过（$gems💎）';
  }

  @override
  String get expertTitle => '🎉 你是专家！🎉';

  @override
  String get goodJobTitle => '🌟 做得好！🌟';

  @override
  String get courageTitle => '🙂 加油！';

  @override
  String get mathkidTitle => '🎉 你是数学小子！🎉';

  @override
  String get onRightTrackTitle => '🌟 你在正确的轨道上！🌟';

  @override
  String get almostMathkidTitle => '🙂 快成为数学小子了！';

  @override
  String get perfectMastery => '完美！你掌握得很好！🎯';

  @override
  String get excellentWork => '出色的工作！继续保持！💪';

  @override
  String get askForHelp => '不要犹豫寻求帮助以提高！📚';

  @override
  String get seeMyProgress => '查看我的进度';

  @override
  String get consultManual => '查看手册';

  @override
  String get returnn => '返回';

  @override
  String get replay => '重玩';

  @override
  String question(Object number) {
    return '问题 $number';
  }

  @override
  String get dailyChallengeConfirm => '确认 ✨';

  @override
  String get dailyChallengeSeeResult => '查看结果';

  @override
  String get dailyChallengeQuitText => '退出';

  @override
  String dailyChallengeYourGems(Object gems) {
    return '你的宝石：$gems';
  }

  @override
  String get dailyChallengeErrorLoading => '加载挑战时出错';

  @override
  String get dailyChallengeNoData => '没有可用的挑战数据';

  @override
  String get dailyChallengeAlreadyCompleted => '今天的挑战已完成！🎉';

  @override
  String get dailyChallengeAlreadyCompletedMessage => '明天再来接受新挑战！';

  @override
  String get dailyChallengeBack => '返回';

  @override
  String get dailyChallengeBrilliantSuccess => '你出色地完成了这个挑战！';

  @override
  String get dailyChallengeKeepProgressing => '继续努力，你每天都在进步！';

  @override
  String get dailyChallengePoints => '分';

  @override
  String get dailyChallengeSeconds => '秒';

  @override
  String get dailyChallengeViewLeaderboard => '查看排行榜';

  @override
  String get dailyChallengeResultBack => '返回';

  @override
  String get leaderboardTitle => '排行榜';

  @override
  String get leaderboardWelcomeChampion => '欢迎冠军！';

  @override
  String get leaderboardToAppearInRanking => '要出现在排名中';

  @override
  String get leaderboardChooseUsername => '选择你的用户名！';

  @override
  String get leaderboardNameVisibleToAll => '你的名字将对所有人可见';

  @override
  String get leaderboardLater => '稍后';

  @override
  String get leaderboardChooseMyName => '选择我的名字';

  @override
  String get leaderboardLoading => '🏆 加载排行榜中...';

  @override
  String get leaderboardTabTop => '🏅 前20名';

  @override
  String get leaderboardTabMe => '👤 我';

  @override
  String get leaderboardTabStats => '📊 统计';

  @override
  String get leaderboardNoChampions => '🎯 暂无冠军';

  @override
  String get leaderboardBeTheFirst => '成为第一个接受挑战的人！';

  @override
  String get leaderboardYourHistory => '📜 你的历史';

  @override
  String get leaderboardYourLegendsWillAppear => '你的传奇成就将在这里显示！';

  @override
  String get leaderboardNoStatsYet => '📊 暂无统计';

  @override
  String get leaderboardUnlockStats => '完成你的第一个挑战以解锁统计！';

  @override
  String get leaderboardCurrentStreak => '🔥 当前连胜';

  @override
  String get leaderboardConsecutiveDays => '连续天数';

  @override
  String get leaderboardTotalStars => '⭐ 总星数';

  @override
  String get leaderboardStarsCollected => '收集的星星';

  @override
  String get leaderboardPersonalRecord => '🏆 个人记录';

  @override
  String get leaderboardDaysYourBest => '天 - 你的最佳';

  @override
  String get leaderboardPoints => '分';

  @override
  String get leaderboardStars => '星';

  @override
  String get leaderboardYou => '你';

  @override
  String get leaderboardEmptyStateTitle => '没有可用数据';

  @override
  String get leaderboardEmptyStateMessage => '挑战自己以出现在这里！';

  @override
  String get progressScreen_title => '我的进度';

  @override
  String get progressScreen_subtitle => '跟踪你的进化！📊';

  @override
  String get progressScreen_loadingError => '加载时出错';

  @override
  String get progressChart_byCategory => '按类别进度';

  @override
  String get progressChart_byGrade => '按年级进度';

  @override
  String get progressScreen_byCategory => '按类别';

  @override
  String get progressScreen_byGrade => '按年级';

  @override
  String get mathKidBadge_title => '🎯 数学小子 🎯';

  @override
  String get mathKidBadge_champion => '超级冠军！';

  @override
  String get badgesSection_title => '我的徽章';

  @override
  String badgesSection_count(Object earned, Object total) {
    return '$earned/$total徽章已获得';
  }

  @override
  String get badgesSection_allUnlocked => '🎉 所有徽章已解锁！冠军！';

  @override
  String badgesSection_continueToUnlock(Object plural, Object remaining) {
    return '继续解锁$remaining个徽章$plural！';
  }

  @override
  String get badgesSection_startPlaying => '开始解题以获得你的第一个徽章！';

  @override
  String get badgesSection_awesome => '太棒了！继续解锁所有徽章！';

  @override
  String get badgesSection_champion => '太棒了！你是真正的冠军！🌟';

  @override
  String get badgesSection_tipStart => '开始解题以获得你的第一个徽章！';

  @override
  String get badgesSection_tipKeepGoing => '太棒了！继续解锁所有徽章！';

  @override
  String get badgesSection_tipChampion => '太棒了！你是真正的冠军！🌟';

  @override
  String get badge => '徽章';

  @override
  String get badges => '徽章';

  @override
  String get earned => '已获得';

  @override
  String get profileTitle => '我的个人资料';

  @override
  String get profileManageInfo => '管理你的信息并访问统计';

  @override
  String get profileMenu => '主菜单';

  @override
  String get profileEdit => '编辑个人资料';

  @override
  String get profileFirstnamePseudo => '名字/用户名';

  @override
  String get profileClass => '班级';

  @override
  String get profileSchool => '学校';

  @override
  String get profileMottoHobby => '座右铭或爱好';

  @override
  String get profileCancel => '取消';

  @override
  String get profileSave => '保存';

  @override
  String get profileUpdateSuccess => '个人资料更新成功！';

  @override
  String get profileError => '错误：';

  @override
  String get profileChoosePhoto => '选择你的照片';

  @override
  String get profileGallery => '相册';

  @override
  String get profileSchoolInfo => '学校信息';

  @override
  String get profileInstitution => '机构';

  @override
  String get profileStudentNumber => '学号';

  @override
  String get profileSchoolYear => '学年';

  @override
  String get profileMotto => '座右铭';

  @override
  String get profileLevelNotDefined => '未定义级别';

  @override
  String get profileFieldRequired => '此字段为必填项';

  @override
  String get profileLeaderboards => '排行榜';

  @override
  String get profileMyProgress => '我的进度';

  @override
  String get profileStore => '商店';

  @override
  String get profileHelpCenter => '帮助中心';

  @override
  String get profileSoundMusic => '声音和音乐';

  @override
  String get profileLanguage => '语言';

  @override
  String get profileBackHome => '返回主页';

  @override
  String get notificationSettingsTitle => '我的通知';

  @override
  String get notificationConfigureReminders => '配置你的提醒，永不错过数学课程！';

  @override
  String get notificationScheduleReminder => '安排提醒';

  @override
  String get notificationReminderTime => '提醒时间';

  @override
  String get notificationHour => '小时';

  @override
  String get notificationMinute => '分钟';

  @override
  String get notificationRepeatDaily => '每天重复';

  @override
  String get notificationSchedule => '安排';

  @override
  String notificationScheduledAt(Object hour, Object minute) {
    return '通知已安排在$hour点$minute分！⏰';
  }

  @override
  String get notificationDeleted => '通知已删除';

  @override
  String get notificationsEnabled => '通知已启用';

  @override
  String get notificationsDisabled => '通知已禁用';

  @override
  String get iWillReceiveReminders => '我将收到提醒';

  @override
  String get noRemindersWillBeSent => '不会发送提醒';

  @override
  String get notificationsActivated => '通知已激活！📱';

  @override
  String get notificationsDeactivated => '通知已停用';

  @override
  String get pleaseAllowExactAlarms => '请在设置中允许精确闹钟。';

  @override
  String get scheduledReminders => '已安排的提醒';

  @override
  String get daily => '每天';

  @override
  String get once => '一次';

  @override
  String get activeReminders => '活动提醒';

  @override
  String get dailyReminders => '每天';

  @override
  String get statistics => '统计';

  @override
  String get tipsForUsingReminders => '使用提醒的技巧';

  @override
  String get tip1 => '🕐 在你最专注的时候安排课程';

  @override
  String get tip2 => '🔄 激活每日提醒以建立例行程序';

  @override
  String get newReminder => '新提醒';

  @override
  String get fieldRequired => '必填';

  @override
  String get fieldInvalid => '无效';

  @override
  String get programNotification => '安排通知';

  @override
  String get soundSettingsTitle => '声音设置 🎵';

  @override
  String get soundSettingsSubtitle => '自定义你的声音';

  @override
  String get soundEffects => '音效';

  @override
  String get soundEffectsActive => '活动';

  @override
  String get soundEffectsDisabled => '禁用';

  @override
  String get backgroundMusic => '背景音乐';

  @override
  String get backgroundMusicActive => '活动';

  @override
  String get backgroundMusicDisabled => '禁用';

  @override
  String get sfxVolume => '音效音量';

  @override
  String get musicVolume => '音乐音量';

  @override
  String get storeTitle => '🏪 商店';

  @override
  String get storeTabLives => '生命';

  @override
  String get storeTabGems => '宝石';

  @override
  String get unlimitedLivesWeek => '无限周！♾️';

  @override
  String get unlimitedLivesDescription => '享受7天不失去生命！';

  @override
  String get chatbotActivated => '助手已激活！🤖';

  @override
  String get chatbotReadyToHelp => '数学小子准备帮助你！';

  @override
  String gemsReceived(Object icon) {
    return '宝石已收到！$icon';
  }

  @override
  String gemsReceivedCount(Object count) {
    return '你收到了$count颗宝石！';
  }

  @override
  String get livesRefilled => '生命已补充！🎉';

  @override
  String get readyToContinue => '你准备好继续冒险了！';

  @override
  String storeError(Object error) {
    return '哎呀：$error';
  }

  @override
  String get storeSuccess => '太好了！';

  @override
  String get storeUnlimitedLives => '无限生命！';

  @override
  String get storeMyLives => '我的生命';

  @override
  String get storeUnlimitedDescription => '这周你无敌了！🦸';

  @override
  String storeNextLife(Object time) {
    return '下一条生命：$time';
  }

  @override
  String get storeSectionLivesBoosts => '💖 生命和增强';

  @override
  String get storeSectionGemPacks => '💎 宝石包';

  @override
  String get storeNoProducts => '没有可用产品...';

  @override
  String get storeTryAgain => '重试';

  @override
  String get storeInfoTitle => '须知';

  @override
  String storeMaxLives(Object count) {
    return '最多储存$count条生命';
  }

  @override
  String storeLifeRegeneration(Object minutes) {
    return '每$minutes分钟恢复1条生命';
  }

  @override
  String get storeUnlimitedMode => '无限模式 = 不失去生命！';

  @override
  String get storeGemsInfoTitle => '宝石有什么用？';

  @override
  String storeHintCost(Object gems) {
    return '提示：$gems宝石';
  }

  @override
  String storeSkipQuestionCost(Object gems) {
    return '跳过问题：$gems宝石';
  }

  @override
  String storeFastRechargeCost(Object gems) {
    return '快速充电生命：$gems宝石';
  }

  @override
  String storeUnlockThemesCost(Object gems) {
    return '解锁主题：$gems宝石';
  }

  @override
  String get storeBadgePopular => '热门 🔥';

  @override
  String get storeBadgeBestOffer => '最佳优惠 🌟';

  @override
  String get storeBadgeNew => '新 🤖';

  @override
  String get storeBadgeBestValue => '最佳价值 💎';

  @override
  String get updateRequiredTitle => '需要更新！🚀';

  @override
  String get updateNewVersionAvailable => '新版本可用';

  @override
  String get updateAppImproving => '数学酷正在改进！';

  @override
  String get updateDescription => '要享受最新功能并继续你的数学冒险，请立即更新应用！';

  @override
  String get updateWhatsNew => '新功能：';

  @override
  String get updateFeatureInfiniteMode => '♾️ 无限模式';

  @override
  String get updateFeatureAchievements => '🏆 60+成就';

  @override
  String get updateFeatureModernDesign => '🎨 现代设计';

  @override
  String get updateFeatureAIAssistant => '🤖 AI助手';

  @override
  String get updateButton => '立即更新';

  @override
  String updateVersionRequired(Object version) {
    return '需要版本$version';
  }

  @override
  String get updateDontMissFeatures => '✨ 不要错过新功能！✨';

  @override
  String get chatbotLimitReached => '已达到限制！🚀';

  @override
  String get chatbotFreeQuestionsUsed => '你已使用今天的3个免费问题！';

  @override
  String get chatbotSubscribePrompt => '订阅以向数学小子提出无限问题！🚀';

  @override
  String get chatbotLater => '稍后';

  @override
  String get chatbotDiscover => '发现 ✨';

  @override
  String get gemsMyGems => '我的宝石';

  @override
  String get gemsCurrent => '当前';

  @override
  String get gemsSpent => '已花费';

  @override
  String get progressChartTitle => '我的进度';

  @override
  String get progressNoData => '暂无数据';

  @override
  String themeBadgeLevel(Object level) {
    return '级别$level';
  }

  @override
  String get themeBadgeLocked => '已锁定';

  @override
  String get chooseYourLanguage => '选择你的语言 🌍';

  @override
  String get questionSkipped => '问题已跳过！⏭️';

  @override
  String get storeHintLabel => '提示 💡';

  @override
  String get achievementFirstSteps => '第一步';

  @override
  String get achievementFirstStepsDesc => '解决你的第一个练习';

  @override
  String get achievementGettingStarted => '开始！';

  @override
  String get achievementGettingStartedDesc => '解决5个练习';

  @override
  String get achievementOnTrack => '在正确的轨道上';

  @override
  String get achievementOnTrackDesc => '解决15个练习';

  @override
  String get achievementBeginner => '初学者';

  @override
  String get achievementBeginnerDesc => '解决25个练习';

  @override
  String get achievementLearner => '学习者';

  @override
  String get achievementLearnerDesc => '解决50个练习';

  @override
  String get achievementStudent => '勤奋的学生';

  @override
  String get achievementStudentDesc => '解决75个练习';

  @override
  String get achievementSkilled => '熟练';

  @override
  String get achievementSkilledDesc => '解决100个练习';

  @override
  String get achievementExpert => '专家';

  @override
  String get achievementExpertDesc => '解决150个练习';

  @override
  String get achievementMaster => '大师';

  @override
  String get achievementMasterDesc => '解决200个练习';

  @override
  String get achievementChampion => '冠军';

  @override
  String get achievementChampionDesc => '解决300个练习';

  @override
  String get achievementLegend => '传奇';

  @override
  String get achievementLegendDesc => '解决500个练习';

  @override
  String get achievementPerfectionist => '完美主义者';

  @override
  String get achievementPerfectionistDesc => '获得满分';

  @override
  String get achievementFlawlessTrio => '完美三重奏';

  @override
  String get achievementFlawlessTrioDesc => '获得3个满分';

  @override
  String get achievementPerfectFive => '完美手牌';

  @override
  String get achievementPerfectFiveDesc => '获得5个满分';

  @override
  String get achievementPerfectTen => '绝对完美';

  @override
  String get achievementPerfectTenDesc => '获得10个满分';

  @override
  String get achievementPerfectMaster => '完美大师';

  @override
  String get achievementPerfectMasterDesc => '获得20个满分';

  @override
  String get achievementDailyPlayer => '每日玩家';

  @override
  String get achievementDailyPlayerDesc => '连续玩3天';

  @override
  String get achievementCommitted => '专注';

  @override
  String get achievementCommittedDesc => '连续玩5天';

  @override
  String get achievementWeeklyWarrior => '每周战士';

  @override
  String get achievementWeeklyWarriorDesc => '连续玩7天';

  @override
  String get achievementTwoWeeks => '两周战士';

  @override
  String get achievementTwoWeeksDesc => '连续玩14天';

  @override
  String get achievementMonthlyMaster => '月度大师';

  @override
  String get achievementMonthlyMasterDesc => '连续玩30天';

  @override
  String get achievementInfiniteBeginner => '无限初学者';

  @override
  String get achievementInfiniteBeginnerDesc => '在无限模式中解决25个练习';

  @override
  String get achievementInfiniteExplorer => '无限探索者';

  @override
  String get achievementInfiniteExplorerDesc => '在无限模式中解决50个练习';

  @override
  String get achievementInfiniteWarrior => '无限战士';

  @override
  String get achievementInfiniteWarriorDesc => '在无限模式中解决100个练习';

  @override
  String get achievementInfiniteMaster => '无限大师';

  @override
  String get achievementInfiniteMasterDesc => '在无限模式中解决200个练习';

  @override
  String get achievementNightOwl => '夜猫子';

  @override
  String get achievementNightOwlDesc => '在午夜至早上6点之间玩';

  @override
  String get achievementEarlyBird => '早起鸟';

  @override
  String get achievementEarlyBirdDesc => '在早上5点至7点之间玩';

  @override
  String get achievementWeekendWarrior => '周末战士';

  @override
  String get achievementWeekendWarriorDesc => '连续一个月每个周末都玩';

  @override
  String get achievementLuckySeven => '幸运七';

  @override
  String get achievementLuckySevenDesc => '解决777个练习';

  @override
  String get notifMotivational1 => '该做神奇的数学了！✨';

  @override
  String get notifMotivational2 => '你的数字朋友在等你！🔢';

  @override
  String get notifMotivational3 => '来发现新的数学挑战！🎯';

  @override
  String get notifMotivational4 => '是时候成为数学超级英雄了！🦸‍♂️';

  @override
  String get notifMotivational5 => '方程在呼唤你！准备好玩了吗？🎮';

  @override
  String get notifMotivational6 => '变身数学天才！🧠';

  @override
  String get notifMotivational7 => '新的数学冒险等着你！🌟';

  @override
  String get notifMotivational8 => '来展示你的数学才能！💪';

  @override
  String get notifMotivational9 => '开始有趣的数学课程！🎉';

  @override
  String get notifMotivational10 => '你的神经元想要计算！🧮';

  @override
  String get notifMotivational11 => '数字为你准备了惊喜！🎁';

  @override
  String get notifMotivational12 => '准备好解开数学谜题了吗？🔍';

  @override
  String get notifMotivational13 => '让你的大脑发光的时候到了！✨';

  @override
  String get notifMotivational14 => '来收集新的成就！🏆';

  @override
  String get notifMotivational15 => '一剂数学开始美好一天！☀️';

  @override
  String get notifMotivational16 => '新课程等着你！🌟';

  @override
  String get notifMotivational17 => '准备好上你的学习课了吗？💫';

  @override
  String get notifAchievement1 => '🏆 嘘...可能有新奖杯等着你！';

  @override
  String get notifAchievement2 => '🥇 来解锁你的下一个专家徽章！';

  @override
  String get notifAchievement3 => '🚀 你快到目标了！来提高你的成就。';

  @override
  String get notifAchievement4 => '🔥 保持节奏！新奖励已经可用。';

  @override
  String get notifAchievement5 => '👑 今天成为类别之王！';

  @override
  String get notifAchievement6 => '🎯 目标在望：来完成你的任务！';

  @override
  String get notifAchievement7 => '🌟 你的徽章感到孤单...来获得更多！';

  @override
  String get notifAchievement8 => '💪 向我们展示你的才能并赢得生命！';

  @override
  String get notifDailyChallenge1 => '⏰ 今天的挑战即将到期！不要错过！';

  @override
  String get notifDailyChallenge2 => '🎯 今天有一个脆脆的挑战等着你！';

  @override
  String get notifDailyChallenge3 => '🔥 你的每日挑战准备好了！来征服它！';

  @override
  String get notifDailyChallenge4 => '⭐ 通过今天的挑战赢得星星！';

  @override
  String get notifDailyChallenge5 => '🚀 今天的挑战将提升你的排名！';

  @override
  String get notifDailyChallenge6 => '💎 今天为你准备的独特挑战！开始！';

  @override
  String get notifDailyChallenge7 => '🎪 今天的挑战来了！轮到你玩了！';

  @override
  String get notifDailyChallenge8 => '⚡ 快速挑战：今天展示你的价值！';

  @override
  String get notifDailyChallenge9 => '🎁 今日礼物：只为你准备的超级挑战！';

  @override
  String get notifDailyChallenge10 => '🌟 完成挑战并在排行榜上闪耀！';

  @override
  String notifLeaderboard1(Object name) {
    return '🏆 别让$name打破你的记录！';
  }

  @override
  String notifLeaderboard2(Object name) {
    return '👑 $name在排行榜上领先你！追上他！';
  }

  @override
  String notifLeaderboard3(Object name) {
    return '⚔️ 与$name的巅峰对决！谁将成为第一？';
  }

  @override
  String notifLeaderboard4(Object name) {
    return '🥇 $name得了满分！轮到你做得更好了！';
  }

  @override
  String notifLeaderboard5(Object name) {
    return '📈 $name快速攀升！保卫你的位置！';
  }

  @override
  String notifLeaderboard6(Object name) {
    return '💪 $name就在你前面！超越他！';
  }

  @override
  String notifLeaderboard7(Object name) {
    return '🎯 $name瞄准领奖台，你呢？';
  }

  @override
  String notifLeaderboard8(Object name) {
    return '🔥 $name赢得了3颗星！追平他的分数！';
  }

  @override
  String notifLeaderboard9(Object name) {
    return '⭐ $name在排行榜上闪耀！展示你的才能！';
  }

  @override
  String notifLeaderboard10(Object name) {
    return '🚀 $name已经起飞！不要落后！';
  }

  @override
  String get notifChannelAchievements => '奖杯提醒';

  @override
  String get notifChannelAchievementsDesc => '解锁成就和徽章的提醒';

  @override
  String get notifChannelDailyChallenge => '每日挑战';

  @override
  String get notifChannelDailyChallengeDesc => '每日挑战的提醒';

  @override
  String get notifChannelLeaderboard => '排行榜';

  @override
  String get notifChannelLeaderboardDesc => '攀登排行榜的提醒';

  @override
  String get notifChannelLives => '生命已满';

  @override
  String get notifChannelLivesDesc => '生命满时的通知';

  @override
  String get notifChannelImmediate => '即时通知';

  @override
  String get notifTitleAchievements => '新成就可用！🏆';

  @override
  String get notifTitleDailyChallenge => '每日挑战可用！🎯';

  @override
  String get notifTitleLeaderboard => '攀登排行榜！🏅';

  @override
  String get notifTitleLivesRefilled => '生命已满！❤️';

  @override
  String notifBodyLivesRefilled(Object name) {
    return '嘿$name，你的生命已补充！来玩吧！🎮';
  }
}
