# ☕ CoffeeFlow - Coffee Shop Management System

Proyek Full-Stack Aplikasi Kasir & Manajemen Coffee Shop yang mengintegrasikan:
- **Frontend**: Flutter + GetX State Management
- **Backend**: CodeIgniter 4 REST API
- **Database**: MySQL (phpMyAdmin)

---

## 📁 Struktur Monorepo

```text
cofeflow/
├── coffeeflow-fe/           # Frontend Mobile & Web (Flutter)
│   ├── lib/
│   │   ├── controllers/    # State management GetX
│   │   ├── models/         # Model data (MenuModel, OrderModel)
│   │   ├── services/       # Komunikasi REST API (http client)
│   │   ├── views/          # Halaman UI (Home, Menu, Order, History)
│   │   └── widgets/        # Komponen UI reusable
│   ├── test/               # Unit test & Widget smoke test
│   └── pubspec.yaml
│
├── coffeeflow-backend/      # Backend REST API (CodeIgniter 4)
│   ├── app/
│   │   ├── Controllers/Api/# REST Resource Controllers (Menus, Orders)
│   │   ├── Models/         # CI4 Database Models
│   │   └── Config/Routes.php # Routing REST API & CORS
│   ├── coffeeflow.sql      # Backup / dump database MySQL
│   └── .env.example        # Template konfigurasi database
│
└── Laporan_Praktikum_REST_API_CoffeeFlow.pdf # Dokumen Laporan Praktikum & Refleksi
```

---

## 🚀 Cara Menjalankan Proyek

### 1. Database MySQL
1. Buka XAMPP Control Panel dan nyalakan **Apache** serta **MySQL**.
2. Masuk ke phpMyAdmin (`http://localhost/phpmyadmin`).
3. Buat database baru bernama `coffeeflow`.
4. Import file SQL: `coffeeflow-backend/coffeeflow.sql`.

---

### 2. Backend REST API (CodeIgniter 4)
1. Buka terminal di folder `coffeeflow-backend`:
   ```bash
   cd coffeeflow-backend
   ```
2. Pastikan file `.env` sudah ada dan sesuai dengan database Anda (bisa salin dari `.env.example`).
3. Jalankan server backend CodeIgniter 4:
   ```bash
   php spark serve --port 8080
   ```
4. Server REST API akan aktif di `http://localhost:8080/api/`.

---

### 3. Frontend (Flutter)
1. Buka terminal baru di folder `coffeeflow-fe`:
   ```bash
   cd coffeeflow-fe
   ```
2. Ambil seluruh dependencies package:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi (pilih salah satu target):
   - **Chrome / Web**:
     ```bash
     flutter run -d chrome
     ```
   - **Android Emulator / Device**:
     ```bash
     flutter run
     ```
   - **Windows Desktop**:
     ```bash
     flutter run -d windows
     ```

---

## 🧪 Pengujian (Testing)

Untuk menjalankan seluruh suite pengujian otomatis:
```bash
cd coffeeflow-fe
flutter test
```
*Hasil: 8/8 tests passed (Unit test model, format mata uang Rupiah, dan smoke test widget).*

---

## 👨‍💻 Pengembang
- **Nama**: Muhammad Feryanto Pratama
- **NIM**: 2411016310015
- **Program Studi**: Ilmu Komputer, Universitas Lambung Mangkurat
