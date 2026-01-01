# ============================================================
# Pond Defender - ProGuard Rules
# ============================================================
# These rules are required for R8 code shrinking in release builds.
# ============================================================

# ============================================
# FLUTTER RULES
# ============================================
# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ============================================
# GOOGLE PLAY CORE - DEFERRED COMPONENTS
# ============================================
# Flutter may reference Play Core classes for deferred components.
# Since we don't use this feature, we tell R8 to ignore these.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Additional Play Core classes that may be referenced
-dontwarn com.google.android.play.core.appupdate.**
-dontwarn com.google.android.play.core.install.**
-dontwarn com.google.android.play.core.review.**
-dontwarn com.google.android.play.core.assetpacks.**

# ============================================
# AUDIOPLAYERS / FLAME AUDIO
# ============================================
# Keep audioplayers classes
-keep class xyz.luan.audioplayers.** { *; }

# ============================================
# SHARED PREFERENCES
# ============================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ============================================
# PATH PROVIDER
# ============================================
-keep class io.flutter.plugins.pathprovider.** { *; }

# ============================================
# GENERAL ANDROID RULES
# ============================================
# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelables
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ============================================
# OBFUSCATION SETTINGS
# ============================================
# Keep source file names and line numbers for crash reports
-keepattributes SourceFile,LineNumberTable

# If you want to hide the original source file name
-renamesourcefileattribute SourceFile

# ============================================
# OPTIMIZATION
# ============================================
# Don't optimize too aggressively
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose
