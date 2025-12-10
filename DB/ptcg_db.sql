DROP DATABASE IF EXISTS ptcg_db;
CREATE DATABASE ptcg_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ptcg_db;

-- collection_type
CREATE TABLE collection_type (
  id_collection_type INT NOT NULL AUTO_INCREMENT,
  collection_type_name VARCHAR(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (id_collection_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO collection_type VALUES
(1,'高級擴充包'),
(2,'擴充包'),
(3,'挑戰牌組'),
(4,'全部');

-- energy_attributes
CREATE TABLE energy_attributes (
  energy_id INT NOT NULL AUTO_INCREMENT,
  energy_en VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  energy_ch VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (energy_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO energy_attributes VALUES
(1,'Grass','草'),
(2,'Fire','火'),
(3,'Water','水'),
(4,'Lightning','雷'),
(5,'Fighting','鬥'),
(6,'Psychic','超'),
(7,'Colorless','無色'),
(8,'Darkness','惡'),
(9,'Metal','鋼'),
(10,'Dragon','龍'),
(11,'Fairy','妖');

-- ptcg_collections
CREATE TABLE ptcg_collections (
  collections_id INT NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  name_ch VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  release_date DATE NOT NULL,
  symbol_url VARCHAR(255) COLLATE utf8mb4_unicode_ci,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  collection_type INT NOT NULL,
  PRIMARY KEY (collections_id),
  KEY collection_type_idx (collection_type),
  CONSTRAINT collection_type FOREIGN KEY (collection_type) REFERENCES collection_type (id_collection_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO ptcg_collections VALUES
(1,'M2a','超級進化夢想ex','2025-12-05','/assets/collection_images/M2a.png','2025-12-08 09:06:34',1),
(2,'M2','烈獄狂火X','2025-10-09','/assets/collection_images/M2.png','2025-12-08 09:06:34',2),
(3,'MBG','超級耿鬼ex','2025-09-19','/assets/collection_images/MBG.png','2025-12-08 09:06:34',3),
(4,'MBD','超級蒂安希ex','2025-09-19','/assets/collection_images/MBD.png','2025-12-08 09:06:34',3),
(5,'M1L','超級勇氣','2025-08-15','/assets/collection_images/M1L.png','2025-12-08 09:06:34',2),
(6,'M1S','超級交響樂','2025-08-15','/assets/collection_images/M1S.png','2025-12-08 09:06:34',2);

-- user
CREATE TABLE user (
  user_id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  password VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  role INT NOT NULL,
  email VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY username (username),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO user VALUES
(1,'manager1','abc123',1,'manager1@gmail.com','2025-11-11 23:00:13','2025-12-07 22:33:30'),
(2,'manager2','abc123',1,'manager2@gmail.com','2025-11-11 23:00:13','2025-12-07 22:33:30'),
(3,'user1','abc123',0,'user1@gmail.com','2025-11-11 23:00:13','2025-12-07 22:33:30'),
(4,'test123','abc123',0,'test123@mail.com','2025-12-07 23:09:12','2025-12-07 23:09:12'),
(5,'123','abc123',0,'123@gg.com','2025-12-07 23:13:26','2025-12-07 23:13:26');

-- rarity
CREATE TABLE rarity (
  rarity_id INT NOT NULL AUTO_INCREMENT,
  rarity_en VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  rarity_ch VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (rarity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO rarity VALUES
(1,'C','常見'),
(2,'U','不常見'),
(3,'R','稀有'),
(4,'RR','雙重稀有'),
(5,'RRR','三重稀有'),
(6,'SR','非常稀有'),
(7,'HR','超級稀有'),
(8,'UR','極其稀有'),
(9,'PR','稜鏡之星稀有'),
(10,'TR','訓練家稀有'),
(11,'Amazing Rare','奇幻稀有(小色違)'),
(12,'K','光輝'),
(13,'CHR','角色稀有'),
(14,'CSR','角色非常稀有'),
(15,'S','異色'),
(16,'SSR','異色非常稀有'),
(17,'AR','藝術稀有'),
(18,'SAR','特殊藝術稀有'),
(19,'ACE','ACE SPEC'),
(20,'MUR','超級進化額外稀有'),
(21,'MA','超級進化藝術稀有');

-- specal_card_type
CREATE TABLE specal_card_type (
  specal_id INT NOT NULL AUTO_INCREMENT,
  speca_type_en VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  speca_type_ch VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (specal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO specal_card_type VALUES
(1,'EX','寶可夢EX'),
(2,'EX-Mega Evolution Pokémon','寶可夢EX-M进化寶可夢'),
(3,'BREAK','BREAK進化寶可夢'),
(4,'GX','寶可夢GX'),
(5,'GX-TAG TEAM','寶可夢GX-TAG TEAM'),
(6,'Prism Star','稜鏡之星'),
(7,'V','寶可夢V'),
(8,'VMAX','寶可夢VMAX'),
(9,'V-UNION','寶可夢V-UNION'),
(10,'VSTAR','寶可夢VSTAR'),
(11,'Radiant','光輝寶可夢'),
(12,'EX-Tera','寶可夢EX-太晶'),
(13,'EX-Mega Evolution','寶可夢EX-超級進化'),
(14,'normal','普卡');

-- ptcg_deck（修正：加入 deck_name 版本）
CREATE TABLE ptcg_deck (
  deck_id INT NOT NULL AUTO_INCREMENT,
  deck_name VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  user_id INT NOT NULL,
  number VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (deck_id),
  KEY user_id (user_id),
  CONSTRAINT ptcg_deck_ibfk_1 FOREIGN KEY (user_id) REFERENCES user (user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ptcg_pokemon_cards（INSERT 保留）
CREATE TABLE `ptcg_pokemon_cards` (
  `card_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hp` int NOT NULL,
  `stage` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci,
  `energy_type` int NOT NULL,
  `collection_id` int NOT NULL,
  `specal_card_type` int NOT NULL,
  `rarity_id` int NOT NULL,
  PRIMARY KEY (`card_id`),
  KEY `energy_type` (`energy_type`),
  KEY `collection_id` (`collection_id`),
  KEY `specal_card_type` (`specal_card_type`),
  KEY `rarity_id` (`rarity_id`),
  CONSTRAINT `ptcg_pokemon_cards_ibfk_1` FOREIGN KEY (`energy_type`) REFERENCES `energy_attributes` (`energy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_2` FOREIGN KEY (`collection_id`) REFERENCES `ptcg_collections` (`collections_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_3` FOREIGN KEY (`specal_card_type`) REFERENCES `specal_card_type` (`specal_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_4` FOREIGN KEY (`rarity_id`) REFERENCES `rarity` (`rarity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO ptcg_pokemon_cards (
    card_id, name, hp, stage, image_url, info, 
    energy_type, collection_id, specal_card_type, rarity_id
) VALUES
('M2_001', '走路草', '50', '基礎', '/assets/cards/M2 001.png', '別名謎行草。\n據說每到夜裡，牠會用２條根\n走上長達３００公尺的距離。', '1', '2', '14', '1'),
('M2_002', '臭臭花', '70', '1階進化', '/assets/cards/M2 002.png', '從口中緩緩滲出的不是口水，\n而是類似花蜜的汁液，\n被牠用來引誘獵物接近。', '1', '2', '14', '1'),
('M2_003', '霸王花', '150', '2階進化', '/assets/cards/M2 003.png', '當花苞隨著「砰！」的聲響\n綻放後，就會開始散播\n能引起過敏反應的毒花粉。', '1', '2', '14', '2'),
('M2_004', '超級赫拉克羅斯ex', '280', '基礎', '/assets/cards/M2 004.png', NULL, '1', '2', '1', '4'),
('M2_005', '蓮葉童子', '70', '基礎', '/assets/cards/M2 005.png', '頭上的葉子具有防污的性質。\n即使載了滿身是泥的寶可夢，\n葉子也能常保乾淨。', '1', '2', '14', '1'),
('M2_006', '蓮帽小童', '90', '1階進化', '/assets/cards/M2 006.png', '喜歡待在食物豐富的水邊。\n為了避免和鳥寶可夢互搶食物，\n於是變成了夜行性的寶可夢。', '1', '2', '14', '1'),
('M2_007', '樂天河童', '160', '2階進化', '/assets/cards/M2 007.png', '全身都有著獨特的結構，\n讓牠一接收歡樂節奏的\n音波就會製造出能量。', '1', '2', '14', '2'),
('M2_008', '蓋諾賽克特', '120', '基礎', '/assets/cards/M2 008.png', '存在於３億年前的寶可夢。\n被等離子隊改造，\n在背部裝了砲台。', '1', '2', '14', '3'),
('M2_009', '豆蟋蟀', '50', '基礎', '/assets/cards/M2 009.png', '總是將第３對腳折起來。\n擁有在遇到危機時能夠\n跳超過１０公尺的跳躍力。', '1', '2', '14', '1'),
('M2_010', '烈腿蝗', '120', '1階進化', '/assets/cards/M2 010.png', '認真起來時會用折起的腳\n站起來，進入決戰模式。\n會在短時間內鎮壓住敵人。', '1', '2', '14', '2'),
('M2_011', '小火龍', '80', '基礎', '/assets/cards/M2 011.png', '尾巴上燃燒的火焰\n是小火龍生命力的象徵。\n在牠沒有活力時，火勢會變弱。', '2', '2', '14', '1'),
('M2_012', '火恐龍', '110', '1階進化', '/assets/cards/M2 012.png', '當揮動燃燒著的尾巴時，\n周圍的溫度會不斷上升，\n讓對手陷入痛苦。', '2', '2', '14', '1'),
('M2_013', '超級噴火龍Xex', '360', '2階進化', '/assets/cards/M2 013.png', NULL, '2', '2', '1', '4'),
('M2_014', '火焰鳥', '120', '基礎', '/assets/cards/M2 014.png', '相傳牠會以美麗燃燒的\n翅膀照亮山路，救助在\n山中遇險的人。', '2', '2', '14', '2'),
('M2_015', '火紅不倒翁', '80', '基礎', '/assets/cards/M2 015.png', '在牠睡覺的時候，\n無論是推是拉，牠都不會倒下。\n因為象徵著吉利而大受歡迎。', '2', '2', '14', '1'),
('M2_016', '達摩狒狒', '150', '1階進化', '/assets/cards/M2 016.png', '體內的火焰燃得越旺，\n力量就越大。火焰的溫度\n有時甚至能超過１４００度。', '2', '2', '14', '2'),
('M2_017', '萊希拉姆', '130', '基礎', '/assets/cards/M2 017.png', '在神話的敘述裡，如果人類\n蔑視真實、放縱欲望，牠就會\n用火焰燒盡他們的王國。', '2', '2', '14', '3'),
('M2_018', '花舞鳥ex', '190', '基礎', '/assets/cards/M2 018.png', NULL, '2', '2', '1', '4'),
('M2_019', '炭小侍', '70', '基礎', '/assets/cards/M2 019.png', '生命寄宿在燃燒的木炭上\n變成了寶可夢。即使敵人再強，\n也會以燃燒的鬥志迎面而戰。', '2', '2', '14', '1'),
('M2_020', '蒼炎刃鬼', '140', '1階進化', '/assets/cards/M2 020.png', '雙臂的火焰之劍靠著\n在得志前就亡命的\n劍士怨念而燃燒。', '2', '2', '14', '2'),
('M2_021', '小海獅', '80', '基礎', '/assets/cards/M2 021.png', '頭上有著非常堅硬的\n突起部分。能夠用頭錘\n撞破冰山來開路前進。', '3', '2', '14', '1'),
('M2_022', '白海獅', '130', '1階進化', '/assets/cards/M2 022.png', '會在水溫變低的夜晚\n為了尋找食物而四處游動。\n白天會在淺海的海底睡覺。', '3', '2', '14', '1'),
('M2_023', '小山豬', '70', '基礎', '/assets/cards/M2 023.png', '會用鼻子先端在地面挖洞\n找出食物。即使地面結了冰\n也絲毫不會受阻礙。', '3', '2', '14', '1'),
('M2_024', '長毛豬', '100', '1階進化', '/assets/cards/M2 024.png', '全身被長長的體毛覆蓋，\n非常耐寒。冰的獠牙在\n下雪時會變得更粗。', '3', '2', '14', '1'),
('M2_025', '象牙豬', '180', '2階進化', '/assets/cards/M2 025.png', '很久以前就存在的寶可夢。\n甚至連１萬年前的冰層裡\n都能發現牠的存在。', '3', '2', '14', '2'),
('M2_026', '水君', '130', '基礎', '/assets/cards/M2 026.png', '擁有瞬間淨化骯髒濁水的力量。\n據說是北風的化身。', '3', '2', '14', '3'),
('M2_027', '波加曼', '70', '基礎', '/assets/cards/M2 027.png', '不擅長走路，有時還會跌倒，\n但波加曼強烈的自尊心會讓牠\n威風地挺起胸膛，不當一回事。', '3', '2', '14', '1'),
('M2_028', '波皇子', '100', '1階進化', '/assets/cards/M2 028.png', '從不結交夥伴，獨自生活。\n用翅膀發出的強烈一擊\n能把大樹劈成兩半。', '3', '2', '14', '1'),
('M2_029', '洛托姆ex', '190', '基礎', '/assets/cards/M2 029.png', NULL, '4', '2', '1', '4'),
('M2_030', '來電汪', '70', '基礎', '/assets/cards/M2 030.png', '因為想要得到零食而\n幫助人類工作的貪吃鬼。\n總是帶著電火花跑來跑去。', '4', '2', '14', '1'),
('M2_031', '逐電犬', '130', '1階進化', '/assets/cards/M2 031.png', '電力增強了牠的腳力。\n當以最高速度奔跑時，\n時速可以輕易超過９０公里。', '4', '2', '14', '1'),
('M2_032', '布撥', '60', '基礎', '/assets/cards/M2 032.png', '臉頰上的電囊尚未發達。\n必須拼命摩擦前腳的肉球，\n才終於能製造出電力。', '4', '2', '14', '1'),
('M2_033', '布土撥', '90', '1階進化', '/assets/cards/M2 033.png', '當群體受到襲擊的時候，\n會率先挑起戰鬥，以結合了\n電擊的格鬥技撂倒敵人。', '4', '2', '14', '1'),
('M2_034', '巴布土撥', '140', '2階進化', '/assets/cards/M2 034.png', '雖然平時動作慢吞吞的，但在\n逼不得已要面對戰鬥時，會用\n迅雷不及掩耳的身手擊潰敵人。', '4', '2', '14', '2'),
('M2_035', '夢妖', '70', '基礎', '/assets/cards/M2 035.png', '會在半夜嚇唬人類，\n然後把收集到的恐懼之心\n轉化成自身能量的寶可夢。', '6', '2', '14', '1'),
('M2_036', '夢妖魔ex', '260', '1階進化', '/assets/cards/M2 036.png', NULL, '6', '2', '1', '4'),
('M2_037', '木棉球', '60', '基礎', '/assets/cards/M2 037.png', '使用木棉球吐出的棉花\n製作而成的枕頭和被褥\n是又輕又透氣的高級商品。', '6', '2', '14', '1'),
('M2_038', '風妖精', '90', '1階進化', '/assets/cards/M2 038.png', '無論是多麼窄小的縫隙，\n都能像風兒般地穿過。\n會留下白色的毛球。', '6', '2', '14', '2'),
('M2_039', '蒼響', '130', '基礎', '/assets/cards/M2 039.png', '能斬斷世間萬物，\n因此被稱為妖精王之劍，\n讓敵友都對牠敬畏不已。', '6', '2', '14', '3'),
('M2_040', '納噬草', '50', '基礎', '/assets/cards/M2 040.png', '無法升天的靈魂在風的\n吹拂下被捲進枯草裡，\n變成了寶可夢。', '6', '2', '14', '1'),
('M2_041', '怖納噬草', '100', '1階進化', '/assets/cards/M2 041.png', '會張開頭的樹枝吞沒獵物。\n把精氣吸得淋漓盡致後，\n就會吐出來丟掉。', '6', '2', '14', '2'),
('M2_042', '帕底亞 肯泰羅', '130', '基礎', '/assets/cards/M2 042.png', '擅長以肌肉發達的身體\n打格鬥戰。會用短短的角\n瞄準對手的要害。', '5', '2', '14', '2'),
('M2_043', '天蠍', '70', '基礎', '/assets/cards/M2 043.png', '會在陡峭的崖壁上築巢。\n每次滑翔之後，\n都會跳著回到巢裡。', '5', '2', '14', '1'),
('M2_044', '天蠍王', '120', '1階進化', '/assets/cards/M2 044.png', '即使是微風，只要順利乘風滑翔，\n就能一次也不拍動翅膀地\n環繞這個星球一周。', '5', '2', '14', '2'),
('M2_045', '大顎蟻', '70', '基礎', '/assets/cards/M2 045.png', '棲息在乾燥的沙漠裡。\n會待在缽狀的巢穴中，\n動也不動地不斷等候獵物出現。', '5', '2', '14', '1'),
('M2_046', '超音波幼蟲', '90', '1階進化', '/assets/cards/M2 046.png', '還未發達的翅膀比起用於飛行，\n更常用來摩擦發出超音波，\n從而攻擊敵人。', '5', '2', '14', '1'),
('M2_047', '沙漠蜻蜓', '150', '2階進化', '/assets/cards/M2 047.png', '被稱為沙漠精靈。\n會躲在拍動翅膀掀起的沙暴中。', '5', '2', '14', '3'),
('M2_048', '狃拉', '70', '基礎', '/assets/cards/M2 048.png', '會潛藏在黑暗中使自己變得\n不起眼，然後伺機襲擊獵物，\n是非常狡詐的寶可夢。', '8', '2', '14', '1'),
('M2_049', '瑪狃拉', '90', '1階進化', '/assets/cards/M2 049.png', '進化後變得更加狡詐，\n會用爪子在石頭上\n留下記號和夥伴交流。', '8', '2', '14', '2'),
('M2_050', '利牙魚', '70', '基礎', '/assets/cards/M2 050.png', '擁有銳利的牙齒和結實的\n下巴。船員們絕對不會去\n靠近利牙魚棲息的地方。', '8', '2', '14', '1'),
('M2_051', '超級巨牙鯊ex', '330', '1階進化', '/assets/cards/M2 051.png', NULL, '8', '2', '1', '4'),
('M2_052', '飯匙蛇', '120', '基礎', '/assets/cards/M2 052.png', '平時都用堅硬的岩石來打磨\n刀刃般的尾巴。會躲在樹叢裡，\n然後趁獵物靠近時用毒牙襲擊。', '8', '2', '14', '2'),
('M2_053', '黑眼鱷', '70', '基礎', '/assets/cards/M2 053.png', '潛藏在沙中像游泳一樣移動。\n這是種兼具不被敵人發現和\n保持體溫效果的生存智慧。', '8', '2', '14', '1'),
('M2_054', '混混鱷', '100', '1階進化', '/assets/cards/M2 054.png', '由於雙眼覆蓋著薄膜，\n在半夜中也能看見四周。\n會和多隻同類組成群體生活。', '8', '2', '14', '1'),
('M2_055', '流氓鱷', '170', '2階進化', '/assets/cards/M2 055.png', '用強力的顎咬住後，\n狠狠地扭動身體，\n將獵物切斷。', '8', '2', '14', '2'),
('M2_056', '毒電嬰', '70', '基礎', '/assets/cards/M2 056.png', '就算喝下污水也能安然無恙。\n那是因為牠會靠著體內的器官\n把污水過濾成對自己無害的毒液。', '8', '2', '14', '1'),
('M2_057', '顫弦蠑螈', '140', '1階進化', '/assets/cards/M2 057.png', '當牠一邊排出毒汗一邊\n放電的時候，周圍會響起\n如同吉他般的旋律。', '8', '2', '14', '3'),
('M2_058', '帝王拿波ex', '320', '2階進化', '/assets/cards/M2 058.png', NULL, '9', '2', '1', '4'),
('M2_059', '銅鏡怪', '80', '基礎', '/assets/cards/M2 059.png', '過去的人們相信，\n銅鏡怪背上的花紋裡\n蘊藏著神秘的力量。', '9', '2', '14', '1'),
('M2_060', '青銅鐘', '140', '1階進化', '/assets/cards/M2 060.png', '從遙遠的過去開始就被人\n當成能召喚雨雲的寶可夢而供奉著。\n有時候會被埋進地下。', '9', '2', '14', '2'),
('M2_061', '托戈德瑪爾', '80', '基礎', '/assets/cards/M2 061.png', '在危急時刻會把身體捲成一團、\n倒豎起背上的尖刺，\n不分青紅皂白地發出電擊。', '9', '2', '14', '1'),
('M2_062', '鋁鋼龍', '130', '基礎', '/assets/cards/M2 062.png', '由特殊金屬構成的身體\n如經過鏡面加工般光滑，\n不易受損且重量輕。', '9', '2', '14', '1'),
('M2_063', '鋁鋼橋龍', '180', '1階進化', '/assets/cards/M2 063.png', '會收集周圍的靜電。\n以四肢著地的姿勢發射的\n光束威力驚人無比。', '9', '2', '14', '2'),
('M2_064', '胖丁', '70', '基礎', '/assets/cards/M2 064.png', '當牠圓圓的大眼睛轉動時，\n就會唱起奇妙的歌曲，\n讓人舒服地昏昏欲睡。', '7', '2', '14', '1'),
('M2_065', '胖可丁', '120', '1階進化', '/assets/cards/M2 065.png', '擁有細緻的毛皮。\n小心別惹牠生氣，否則牠會\n不斷膨脹並朝著你壓過來。', '7', '2', '14', '2'),
('M2_066', '長尾怪手', '70', '基礎', '/assets/cards/M2 066.png', '生活在高高的樹上。\n在樹枝間跳躍移動時，\n會用尾巴巧妙地保持平衡。', '7', '2', '14', '1'),
('M2_067', '雙尾怪手', '110', '1階進化', '/assets/cards/M2 067.png', '生活在巨大的樹木上。\n據說會透過與夥伴連起\n尾巴來互相傳達心情。', '7', '2', '14', '3'),
('M2_068', '圖圖犬', '80', '基礎', '/assets/cards/M2 068.png', '有著成年後讓夥伴在自己\n背上印下腳印標記的習性。', '7', '2', '14', '1'),
('M2_069', '蛇紋熊', '70', '基礎', '/assets/cards/M2 069.png', '好奇心旺盛的寶可夢。\n不論對什麼都很感興趣，\n所以總是呈鋸齒形行走。', '7', '2', '14', '1'),
('M2_070', '直衝熊', '100', '1階進化', '/assets/cards/M2 070.png', '用自己超群的爆發力\n和銳利的爪子來制服獵物。\n不擅長在彎曲的道路上奔跑。', '7', '2', '14', '2'),
('M2_071', '捲捲耳', '70', '基礎', '/assets/cards/M2 071.png', '會利用把捲成團的耳朵伸直\n時的威力來使出攻擊招式。\n越訓練，招式威力就會越大。', '7', '2', '14', '1'),
('M2_072', '超級長耳兔ex', '330', '1階進化', '/assets/cards/M2 072.png', NULL, '7', '2', '1', '4'),
('M2a_001','阿響的凱羅斯','120','基礎','/assets/cards/M2a 001.png','會用角緊緊夾住獵物， 就這樣把對方剪成兩半 或是把牠硬扔到天邊去。','1','1','14','1'),
('MBG_001','鬼斯','70','基礎','/assets/cards/MBG 001.png','會用氣體狀的身體纏住獵物， 再從皮膚緩緩地注入毒素， 使對手變得虛弱。','8','3','14','1');
