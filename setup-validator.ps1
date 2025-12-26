# Flutter Android Setup Validator & Fixer
# Este script valida y configura automáticamente las versiones correctas para tu proyecto Flutter

param(
    [switch]$Fix = $false,
    [switch]$Clean = $false
)

$ErrorActionPreference = "Continue"

# Colores para output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }
function Write-Warning { Write-Host $args -ForegroundColor Yellow }
function Write-Info { Write-Host $args -ForegroundColor Cyan }

# Banner
Write-Host "`n================================================" -ForegroundColor Magenta
Write-Host "  Flutter Android Setup Validator & Fixer" -ForegroundColor Magenta
Write-Host "================================================`n" -ForegroundColor Magenta

# Verificar que estamos en un proyecto Flutter
if (-not (Test-Path "pubspec.yaml")) {
    Write-Error "❌ ERROR: No se encontró pubspec.yaml"
    Write-Error "   Ejecuta este script desde la raíz de tu proyecto Flutter"
    exit 1
}

Write-Info "📁 Proyecto detectado: $(Get-Location)"

# Obtener versión de Flutter
$flutterVersion = flutter --version | Select-String "Flutter (\d+\.\d+\.\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
Write-Info "🦋 Flutter version: $flutterVersion"

# Determinar versiones requeridas basadas en Flutter
$REQUIRED_GRADLE = "8.10.2"
$REQUIRED_AGP = "8.7.2"
$REQUIRED_KOTLIN = "2.1.0"
$REQUIRED_COMPILE_SDK = "34"
$REQUIRED_TARGET_SDK = "34"
$REQUIRED_MIN_SDK = "21"

Write-Info "`n📋 Versiones requeridas para Flutter ${flutterVersion}:"
Write-Host "   • Gradle: $REQUIRED_GRADLE"
Write-Host "   • Android Gradle Plugin (AGP): $REQUIRED_AGP"
Write-Host "   • Kotlin: $REQUIRED_KOTLIN"
Write-Host "   • Compile SDK: $REQUIRED_COMPILE_SDK"
Write-Host "   • Target SDK: $REQUIRED_TARGET_SDK"
Write-Host "   • Min SDK: $REQUIRED_MIN_SDK"

# Variables de estado
$issues = @()
$needsFix = $false

# ============================================================
# FUNCIÓN: Verificar archivo
# ============================================================
function Test-FileExists {
    param([string]$path, [string]$name)
    
    if (Test-Path $path) {
        Write-Success "✅ $name encontrado"
        return $true
    } else {
        Write-Error "❌ $name NO encontrado: $path"
        $script:issues += "Falta archivo: $name"
        $script:needsFix = $true
        return $false
    }
}

# ============================================================
# FUNCIÓN: Verificar versión en archivo
# ============================================================
function Test-VersionInFile {
    param(
        [string]$file,
        [string]$pattern,
        [string]$expected,
        [string]$description
    )
    
    if (-not (Test-Path $file)) {
        Write-Error "❌ $description - Archivo no existe: $file"
        $script:issues += "$description - Archivo no existe"
        $script:needsFix = $true
        return $false
    }
    
    $content = Get-Content $file -Raw
    if ($content -match $pattern) {
        $current = $matches[1]
        if ($current -eq $expected) {
            Write-Success "✅ $description correcto: $current"
            return $true
        } else {
            Write-Warning "⚠️  $description incorrecto: $current (esperado: $expected)"
            $script:issues += "$description incorrecto: $current → $expected"
            $script:needsFix = $true
            return $false
        }
    } else {
        Write-Error "❌ $description no encontrado en $file"
        $script:issues += "$description no encontrado"
        $script:needsFix = $true
        return $false
    }
}

# ============================================================
# VALIDACIONES
# ============================================================
Write-Host "`n" -NoNewline
Write-Info "🔍 Validando estructura del proyecto..."
Write-Host ""

# Verificar archivos principales
Test-FileExists "android/build.gradle" "android/build.gradle"
Test-FileExists "android/settings.gradle" "android/settings.gradle"
Test-FileExists "android/app/build.gradle" "android/app/build.gradle"
Test-FileExists "android/gradle/wrapper/gradle-wrapper.properties" "gradle-wrapper.properties"

# Verificar versiones
Write-Host ""
Write-Info "🔍 Validando versiones..."
Write-Host ""

# Gradle version
Test-VersionInFile "android/gradle/wrapper/gradle-wrapper.properties" `
    "gradle-(\d+\.\d+\.?\d*)-all\.zip" `
    $REQUIRED_GRADLE `
    "Gradle version"

# Kotlin version en build.gradle
Test-VersionInFile "android/build.gradle" `
    "ext\.kotlin_version\s*=\s*['\`"](\d+\.\d+\.?\d*)['\`"]" `
    $REQUIRED_KOTLIN `
    "Kotlin version"

# AGP version
Test-VersionInFile "android/build.gradle" `
    "com\.android\.tools\.build:gradle:(\d+\.\d+\.?\d*)" `
    $REQUIRED_AGP `
    "Android Gradle Plugin (AGP)"

# Verificar namespace en app/build.gradle
if (Test-Path "android/app/build.gradle") {
    $appBuildGradle = Get-Content "android/app/build.gradle" -Raw
    if ($appBuildGradle -match 'namespace\s+["'']([^"'']+)["'']') {
        Write-Success "✅ Namespace definido: $($matches[1])"
    } else {
        Write-Error "❌ Namespace NO definido en android/app/build.gradle"
        $script:issues += "Falta namespace en app/build.gradle"
        $script:needsFix = $true
    }
}

# ============================================================
# RESUMEN
# ============================================================
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  RESUMEN DE VALIDACIÓN" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

if ($issues.Count -eq 0) {
    Write-Success "`n✅ ¡TODO CORRECTO! Tu proyecto está configurado correctamente.`n"
    exit 0
} else {
    Write-Warning "`n⚠️  Se encontraron $($issues.Count) problema(s):`n"
    foreach ($issue in $issues) {
        Write-Host "   • $issue" -ForegroundColor Yellow
    }
}

# ============================================================
# OPCIÓN DE FIX
# ============================================================
if (-not $Fix -and -not $Clean) {
    Write-Host "`n" -NoNewline
    Write-Info "💡 Para corregir automáticamente, ejecuta:"
    Write-Host "   .\setup-validator.ps1 -Fix`n"
    Write-Info "💡 Para limpiar caché y corregir:"
    Write-Host "   .\setup-validator.ps1 -Fix -Clean`n"
    exit 1
}

# ============================================================
# APLICAR CORRECCIONES
# ============================================================
if ($Fix) {
    Write-Host ""
    Write-Info "🔧 Aplicando correcciones..."
    Write-Host ""
    
    # Limpiar caché si se solicitó
    if ($Clean) {
        Write-Info "🧹 Limpiando caché de Gradle..."
        
        # Detener daemons
        Set-Location android
        & .\gradlew.bat --stop 2>$null
        Set-Location ..
        
        # Limpiar .gradle
        Remove-Item -Path "$env:USERPROFILE\.gradle\caches" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:USERPROFILE\.gradle\daemon" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "✅ Caché limpiado"
        
        # Limpiar proyecto
        Write-Info "🧹 Limpiando proyecto Flutter..."
        flutter clean
        Write-Success "✅ Proyecto limpio"
    }
    
    # Crear backup
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "android_backup_$timestamp"
    Write-Info "💾 Creando backup en: $backupDir"
    Copy-Item -Path "android" -Destination $backupDir -Recurse
    Write-Success "✅ Backup creado"
    
    # ============================================================
    # CORREGIR gradle-wrapper.properties
    # ============================================================
    Write-Info "📝 Actualizando gradle-wrapper.properties..."
    $gradleWrapperContent = @"
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-$REQUIRED_GRADLE-all.zip
"@
    $gradleWrapperContent | Out-File -FilePath "android/gradle/wrapper/gradle-wrapper.properties" -Encoding UTF8 -NoNewline
    Write-Success "✅ gradle-wrapper.properties actualizado"
    
    # ============================================================
    # CORREGIR build.gradle (raíz)
    # ============================================================
    Write-Info "📝 Actualizando android/build.gradle..."
    $buildGradleContent = @"
buildscript {
    ext.kotlin_version = '$REQUIRED_KOTLIN'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:$REQUIRED_AGP'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:`$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "`${rootProject.buildDir}/`${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
"@
    $buildGradleContent | Out-File -FilePath "android/build.gradle" -Encoding UTF8 -NoNewline
    Write-Success "✅ android/build.gradle actualizado"
    
    # ============================================================
    # CORREGIR settings.gradle
    # ============================================================
    Write-Info "📝 Actualizando android/settings.gradle..."
    $settingsGradleContent = @"
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("`$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

include ":app"
"@
    $settingsGradleContent | Out-File -FilePath "android/settings.gradle" -Encoding UTF8 -NoNewline
    Write-Success "✅ android/settings.gradle actualizado"
    
    # ============================================================
    # CORREGIR app/build.gradle
    # ============================================================
    Write-Info "📝 Actualizando android/app/build.gradle..."
    
    # Obtener applicationId del archivo existente si existe
    $applicationId = "com.example.app"
    if (Test-Path "android/app/build.gradle") {
        $existingContent = Get-Content "android/app/build.gradle" -Raw
        if ($existingContent -match 'applicationId\s+["'']([^"'']+)["'']') {
            $applicationId = $matches[1]
        }
    }
    
    $appBuildGradleContent = @"
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "$applicationId"
    compileSdk $REQUIRED_COMPILE_SDK

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        applicationId "$applicationId"
        minSdk $REQUIRED_MIN_SDK
        targetSdk $REQUIRED_TARGET_SDK
        multiDexEnabled true
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "androidx.multidex:multidex:2.0.1"
}
"@
    $appBuildGradleContent | Out-File -FilePath "android/app/build.gradle" -Encoding UTF8 -NoNewline
    Write-Success "✅ android/app/build.gradle actualizado"
    
    # ============================================================
    # CORREGIR gradle.properties
    # ============================================================
    Write-Info "📝 Actualizando android/gradle.properties..."
    $gradlePropertiesContent = @"
org.gradle.jvmargs=-Xmx4096M -XX:MaxMetaspaceSize=1024m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
org.gradle.daemon=true
org.gradle.parallel=true
android.useAndroidX=true
android.enableJetifier=true
android.ndkVersion=
"@
    $gradlePropertiesContent | Out-File -FilePath "android/gradle.properties" -Encoding UTF8 -NoNewline
    Write-Success "✅ android/gradle.properties actualizado"
    
    # ============================================================
    # FINALIZAR
    # ============================================================
    Write-Host ""
    Write-Success "✅ ¡Correcciones aplicadas exitosamente!"
    Write-Host ""
    Write-Info "📦 Ejecutando flutter pub get..."
    flutter pub get
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  ✅ CONFIGURACIÓN COMPLETADA" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Info "🚀 Siguiente paso: Ejecutar tu aplicación"
    Write-Host ""
    Write-Host "   Para Android:" -ForegroundColor Cyan
    Write-Host "   flutter run" -ForegroundColor White
    Write-Host ""
    Write-Host "   Para Windows (más rápido):" -ForegroundColor Cyan
    Write-Host "   flutter run -d windows" -ForegroundColor White
    Write-Host ""
    Write-Info "💾 Backup guardado en: $backupDir"
    Write-Host ""
}