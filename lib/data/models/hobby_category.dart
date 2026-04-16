import 'package:flutter/material.dart';

/// 爱好分类模型
class HobbyCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> popularItems;

  HobbyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.popularItems = const [],
  });
}

/// 20个爱好分类数据
class HobbyCategories {
  static final List<HobbyCategory> all = [
    HobbyCategory(
      id: 'books',
      name: '书籍',
      icon: Icons.book_outlined,
      color: const Color(0xFF8B6F47),
      popularItems: ['三体', '百年孤独', '活着', '挪威的森林', '小王子'],
    ),
    HobbyCategory(
      id: 'music',
      name: '音乐',
      icon: Icons.music_note_outlined,
      color: const Color(0xFFE85D75),
      popularItems: ['周杰伦', 'Taylor Swift', '陈奕迅', '邓紫棋', '五月天'],
    ),
    HobbyCategory(
      id: 'games',
      name: '游戏',
      icon: Icons.sports_esports_outlined,
      color: const Color(0xFF7B68EE),
      popularItems: ['原神', '王者荣耀', '塞尔达', '动物森友会', '英雄联盟'],
    ),
    HobbyCategory(
      id: 'movies',
      name: '电影',
      icon: Icons.movie_outlined,
      color: const Color(0xFFFF6B4A),
      popularItems: ['诺兰', '宫崎骏', '漫威', '星际穿越', '肖申克的救赎'],
    ),
    HobbyCategory(
      id: 'tv',
      name: '剧集',
      icon: Icons.tv_outlined,
      color: const Color(0xFF4ECDC4),
      popularItems: ['狂飙', '黑暗荣耀', '怪奇物语', '甄嬛传', '老友记'],
    ),
    HobbyCategory(
      id: 'variety',
      name: '综艺',
      icon: Icons.live_tv_outlined,
      color: const Color(0xFFFFD93D),
      popularItems: ['明星大侦探', '脱口秀大会', '向往的生活', '乐队的夏天', '奇葩说'],
    ),
    HobbyCategory(
      id: 'food',
      name: '美食',
      icon: Icons.restaurant_outlined,
      color: const Color(0xFFFF8C42),
      popularItems: ['火锅', '日料', '咖啡', '烘焙', '探店'],
    ),
    HobbyCategory(
      id: 'drinks',
      name: '饮品',
      icon: Icons.local_cafe_outlined,
      color: const Color(0xFF795548),
      popularItems: ['奶茶', '咖啡', '精酿', '威士忌', '气泡水'],
    ),
    HobbyCategory(
      id: 'art',
      name: '艺术',
      icon: Icons.palette_outlined,
      color: const Color(0xFFEC4899),
      popularItems: ['水彩', '油画', 'Procreate', '素描', '插画'],
    ),
    HobbyCategory(
      id: 'sports',
      name: '运动',
      icon: Icons.sports_basketball_outlined,
      color: const Color(0xFF10B981),
      popularItems: ['跑步', '瑜伽', '游泳', '健身', '羽毛球'],
    ),
    HobbyCategory(
      id: 'pets',
      name: '宠物',
      icon: Icons.pets_outlined,
      color: const Color(0xFF9CA3AF),
      popularItems: ['猫咪', '狗狗', '柯基', '布偶猫', '金毛'],
    ),
    HobbyCategory(
      id: 'anime',
      name: '动画',
      icon: Icons.animation_outlined,
      color: const Color(0xFFFF69B4),
      popularItems: ['进击的巨人', '鬼灭之刃', '间谍过家家', '咒术回战', '你的名字'],
    ),
    HobbyCategory(
      id: 'comics',
      name: '漫画',
      icon: Icons.menu_book_outlined,
      color: const Color(0xFFAB47BC),
      popularItems: ['海贼王', '火影忍者', '名侦探柯南', '银魂', '灌篮高手'],
    ),
    HobbyCategory(
      id: 'podcast',
      name: '播客',
      icon: Icons.mic_outlined,
      color: const Color(0xFF26A69A),
      popularItems: ['忽左忽右', '声东击西', '随机波动', '文化有限', '谐星聊天会'],
    ),
    HobbyCategory(
      id: 'learning',
      name: '学习',
      icon: Icons.school_outlined,
      color: const Color(0xFFF59E0B),
      popularItems: ['英语', '心理学', '理财', '考证', '阅读'],
    ),
    HobbyCategory(
      id: 'singers',
      name: '歌手',
      icon: Icons.mic_external_on_outlined,
      color: const Color(0xFFEF4444),
      popularItems: ['林俊杰', '薛之谦', '毛不易', '李荣浩', '周深'],
    ),
    HobbyCategory(
      id: 'actors',
      name: '演员',
      icon: Icons.theaters_outlined,
      color: const Color(0xFF3B82F6),
      popularItems: ['张译', '朱一龙', '周迅', '巩俐', '梁朝伟'],
    ),
    HobbyCategory(
      id: 'celebrities',
      name: '艺人',
      icon: Icons.emoji_people_outlined,
      color: const Color(0xFFE91E63),
      popularItems: ['王嘉尔', '蔡徐坤', '刘雨昕', '王一博', '张艺兴'],
    ),
    HobbyCategory(
      id: 'travel',
      name: '旅游',
      icon: Icons.flight_outlined,
      color: const Color(0xFF0EA5E9),
      popularItems: ['日本', '西藏', '新疆', '海岛', ' backpacking'],
    ),
    HobbyCategory(
      id: 'blogger',
      name: '博主',
      icon: Icons.person_outlined,
      color: const Color(0xFF84CC16),
      popularItems: ['B站', '小红书', 'YouTube', '微博', '自媒体'],
    ),
  ];

  static HobbyCategory? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
