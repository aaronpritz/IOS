/**
 * Higgsfield-generated brand graphics, referenced by URL.
 *
 * These load in the user's browser/device at runtime (full internet access);
 * the build sandbox can't fetch them, so they aren't bundled. Surfaces that use
 * them have a styled in-app fallback (SVG mascot + wordmark) if the CDN is
 * unreachable.
 *
 * To bundle them later (offline-proof), download into ./assets and switch the
 * <Image source> from { uri } to require('../../assets/...').
 */

// Illustrated Spark mascot with the background removed (transparent PNG), so it
// sits cleanly on any surface. Falls back to the SVG Mascot via SparkAvatar.
export const MASCOT_IMAGE_URL =
  'https://d8j0ntlcm91z4.cloudfront.net/user_37GLwKjrjpEszcw5O6GtA2PPSHq/hf_20260614_203927_175b1e8f-5b7e-4bdf-8333-bacf93333771.png';
