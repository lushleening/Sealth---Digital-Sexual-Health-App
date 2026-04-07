const avatarMB = 5;
const mb = 1024 * 1024;

const maxAvatarSize = avatarMB * mb; // 2MB

const avatarStorageName = 'avatars';

const cleanupNotificationThreshold = Duration(days: 90); // Days