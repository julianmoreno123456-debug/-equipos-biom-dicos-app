# 🏥 Control de Mantenimiento de Equipos Biomédicos

App móvil (Flutter/Android) para el control de mantenimiento de equipos biomédicos.
Prototipo parcialmente funcional — proyecto académico.

## ✨ Funcionalidades (checklist del enunciado)

- [x] **Base de datos** local (SQLite / `sqflite`): equipos, preventivos, correctivos, manuales, checklist.
- [x] **Pantallas principales**: menú, dashboard, inventario, registro, detalle, manual/IA, QR.
- [x] **Registro del equipo**: nombre, especialidad, referencia y foto.
- [x] **Hoja de vida** del equipo: datos completos + resumen de mantenimientos.
- [x] **Inventario**: listado de todos los equipos registrados.
- [x] **Checklist**: lista de verificación por equipo (ítems predefinidos + se pueden agregar más), con casillas marcables.
- [x] **Historial**: historial de mantenimientos preventivos y correctivos por equipo.
- [x] **Código QR funcionando**: cada equipo genera un QR con sus datos, visible y escaneable desde la pestaña "QR".
- [x] **Dashboard inicial**: estadísticas generales (equipos, preventivos, correctivos, manuales, checklist pendientes).
- [x] **Evidencias fotográficas**: foto del equipo al registrarlo + foto de evidencia en cada mantenimiento correctivo.
- [x] **Carga de manuales**: subir manual en PDF o TXT por equipo.
- [x] **Primer módulo del asistente IA**: búsqueda de información dentro del manual cargado (palabras clave / frases), en la pestaña "Manual / IA". Es una primera versión basada en búsqueda de texto local (sin costo, sin internet); en una siguiente entrega se puede conectar a un modelo de lenguaje real (API de Claude) para responder en lenguaje natural.

Todo funciona **sin conexión a internet** y sin servidor, usando almacenamiento local en el dispositivo.

## 🛠️ Tecnologías

- Flutter / Dart
- sqflite (base de datos local)
- image_picker (fotos del equipo y evidencias)
- file_picker + syncfusion_flutter_pdf (carga de manuales y extracción de texto)
- qr_flutter (generación de código QR)

## 🚀 Cómo correr el proyecto en Visual Studio Code

1. Instala [Flutter SDK](https://docs.flutter.dev/get-started/install) y agrégalo al PATH.
2. Instala la extensión **Flutter** (y **Dart**) en VS Code.
3. Abre esta carpeta (`equipos_biomedicos`) en VS Code.
4. Si es la primera vez, ejecuta en la terminal: `flutter create .` (sin sobrescribir `pubspec.yaml`).
5. Ejecuta:
   ```bash
   flutter pub get
   ```
6. Conecta un celular Android (con depuración USB activada) o abre un emulador.
7. Presiona `F5` o ejecuta:
   ```bash
   flutter run
   ```

## 📦 Cómo generar el APK

```bash
flutter build apk --release
```

El APK queda en:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 📂 Estructura del proyecto

```
lib/
 ├── main.dart
 ├── models/
 │   ├── equipo.dart
 │   ├── mantenimiento_preventivo.dart
 │   ├── mantenimiento_correctivo.dart
 │   ├── manual.dart
 │   └── checklist_item.dart
 ├── db/
 │   └── database_helper.dart
 └── screens/
     ├── home_screen.dart
     ├── dashboard_screen.dart
     ├── inventario_screen.dart
     ├── agregar_equipo_screen.dart
     ├── detalle_equipo_screen.dart
     ├── checklist_screen.dart
     ├── manual_screen.dart
     └── qr_screen.dart
```

## 🔜 Posibles mejoras futuras

- Editar/eliminar equipos.
- Notificaciones de mantenimientos próximos.
- Exportar historial e informes a PDF/Excel.
- Login de usuarios (técnico responsable).
- Asistente IA real (API de Claude) con respuestas en lenguaje natural sobre el manual.
- Escaneo de QR desde la cámara para buscar un equipo directamente (actualmente el QR se genera y puede leerse con cualquier lector de QR).
