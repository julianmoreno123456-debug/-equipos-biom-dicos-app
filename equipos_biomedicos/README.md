# 🏥 Control de Mantenimiento de Equipos Biomédicos

App móvil (Flutter/Android) para el control de mantenimiento de equipos biomédicos.
Proyecto académico.

## ✨ Funcionalidades

- **Menú principal** con acceso a Inventario y registro de nuevos equipos.
- **Inventario de equipos**: nombre, especialidad, referencia y foto.
- **Mantenimientos preventivos**: registro con fecha y observación por equipo.
- **Historial de mantenimiento correctivo**: fecha, falla reportada y solución aplicada.
- **Manual del equipo**: subir el manual (PDF o TXT) y buscar palabras/frases dentro
  de su contenido (por ejemplo: "voltaje", "batería", "error E01") sin necesidad de
  conexión a internet ni servicios de pago.

Toda la información se guarda de forma local en el dispositivo usando SQLite (`sqflite`),
por lo que no necesita servidor ni conexión a internet.

## 🛠️ Tecnologías

- Flutter / Dart
- sqflite (base de datos local)
- image_picker (fotos del equipo)
- file_picker + syncfusion_flutter_pdf (subir manual y extraer texto de PDF)

## 🚀 Cómo correr el proyecto en Visual Studio Code

1. Instala [Flutter SDK](https://docs.flutter.dev/get-started/install) y agrégalo al PATH.
2. Instala la extensión **Flutter** (y **Dart**) en VS Code.
3. Abre esta carpeta (`equipos_biomedicos`) en VS Code.
4. Abre una terminal en VS Code y ejecuta:
   ```bash
   flutter pub get
   ```
5. Conecta un celular Android (con depuración USB activada) o abre un emulador.
6. Presiona `F5` o ejecuta:
   ```bash
   flutter run
   ```

## 📦 Cómo generar el APK

En la terminal, dentro de la carpeta del proyecto:

```bash
flutter build apk --release
```

El archivo APK quedará en:

```
build/app/outputs/flutter-apk/app-release.apk
```

Ese es el archivo que puedes instalar en un celular Android o entregar al profesor.

## 📤 Cómo subir el proyecto a GitHub

1. Crea un repositorio nuevo en GitHub (sin README, para evitar conflictos).
2. En la terminal, dentro de la carpeta del proyecto:
   ```bash
   git init
   git add .
   git commit -m "Primera versión: app de control de mantenimiento de equipos biomédicos"
   git branch -M main
   git remote add origin https://github.com/TU_USUARIO/NOMBRE_DEL_REPO.git
   git push -u origin main
   ```
3. Comparte el enlace del repositorio con el profesor.

> 💡 El `.gitignore` ya está configurado para no subir carpetas pesadas o generadas
> automáticamente (`build/`, `.dart_tool/`, etc.), así que el repositorio queda liviano.

## 📂 Estructura del proyecto

```
lib/
 ├── main.dart
 ├── models/
 │   ├── equipo.dart
 │   ├── mantenimiento_preventivo.dart
 │   ├── mantenimiento_correctivo.dart
 │   └── manual.dart
 ├── db/
 │   └── database_helper.dart
 └── screens/
     ├── home_screen.dart
     ├── inventario_screen.dart
     ├── agregar_equipo_screen.dart
     ├── detalle_equipo_screen.dart
     └── manual_screen.dart
```

## 🔜 Posibles mejoras futuras

- Editar/eliminar equipos desde la pantalla de detalle.
- Notificaciones/recordatorios de próximos mantenimientos preventivos.
- Exportar historial a PDF o Excel.
- Login de usuarios (técnico responsable de cada mantenimiento).
- Reemplazar la búsqueda simple del manual por una IA real (usando la API de Claude)
  para responder preguntas en lenguaje natural sobre el manual.
