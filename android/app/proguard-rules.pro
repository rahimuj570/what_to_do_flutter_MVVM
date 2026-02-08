# Keep ML Kit text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }

# Keep OkHttp classes
-keep class okhttp3.** { *; }

# Keep OkHttp internal platform classes
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
