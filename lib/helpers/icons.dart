class SavedIcons {
  static const icons = {
    'apple': 'lib/assets/logos/github.png',
    'discord': 'lib/assets/logos/discord.png',
    'facebook': 'lib/assets/logos/facebook.png',
    'figma': 'lib/assets/logos/figma.png',
    'github': 'lib/assets/logos/github.png',
    'google': 'lib/assets/logos/google.png',
    'instagram': 'lib/assets/logos/instagram.png',
    'microsoft': 'lib/assets/logos/microsoft.png',
    'netflix': 'lib/assets/logos/netflix.png',
    'paypal': 'lib/assets/logos/paypal.png',
    'samsung': 'lib/assets/logos/samsung.png',
    'snapchat': 'lib/assets/logos/snapchat.png',
    'spotify': 'lib/assets/logos/spotify.png',
    'stackoverflow': 'lib/assets/logos/stack-overflow.png',
    'twitter': 'lib/assets/logos/twitter.png',
    'udemy': 'lib/assets/logos/udemy.png',
  };

  static String? getIconPath(String websiteName) {
    final name = websiteName.toLowerCase();
    if (icons.containsKey(name)) {
      return icons[name]!;
    }
    return null;
  }
}
