const avatarMB = 5;
const mb = 1024 * 1024;

// For uploading a new profile avatar
const maxAvatarSize = avatarMB * mb; 

// Storage name in supabase
const avatarStorageName = 'avatars';

// Corresponding variable: scheduledAt
// All notifications scheduled before this period will not be accepted and will be cleaned up
const cleanupNotificationThreshold = Duration(days: 90);

// All notifications scheduled to release before this period (relative to null) will be rescheduled and shown 
const latencyGracePeriod = Duration(seconds: 30);