# ☕ CoffeeFlow - Coffee Shop Management System

Aplikasi mobile kasir dan manajemen kedai kopi modern, minimalis, dan elegan menggunakan **Flutter**, **Dart**, dan **GetX**.

---

## 🎨 Konsep Desain & Tema Warna

Aplikasi dirancang dengan estetika Coffee/Espresso shop yang elegan dan profesional:

| Warna | Hex Code | Penggunaan |
|---|---|---|
| **Espresso Brown** | `#4B2E24` | Primary brand color, header, active state, CTA button |
| **Coffee Brown** | `#795548` | Secondary brand color, icons, badges |
| **Cream** | `#FAF7F2` | Scaffold background utama |
| **White** | `#FFFFFF` | Card surface, form field fill |
| **Light Beige** | `#EDE3D5` | Border, chip background, badge quantity |
| **Dark Text** | `#292321` | Typography text utama |

---

## 📁 Struktur Folder Project

```
lib/
├── main.dart                          # Entrypoint aplikasi & konfigurasi tema
├── controllers/                       # GetX Controllers (State Management)
│   ├── history_controller.dart        # Controller riwayat transaksi
│   ├── home_controller.dart           # Controller dashboard & statistik
│   ├── menu_controller.dart           # Controller CRUD menu & filter
│   ├── navigation_controller.dart     # Controller navigasi bottom bar
│   └── order_controller.dart          # Controller pembuatan pesanan & keranjang
├── models/                            # Data Models & JSON Serialization
│   ├── menu_model.dart                # Model Menu (fromJson, toJson, copyWith)
│   └── order_model.dart               # Model Order & OrderItem
├── services/                          # API & Business Logic Layer
│   ├── api_service.dart               # HTTP Client REST API (GET, POST, PUT, DELETE)
│   ├── menu_service.dart              # Service CRUD Menu (Sample data fallback)
│   └── order_service.dart             # Service Order (Sample data fallback)
├── utils/                             # Utility & Constants
│   ├── app_colors.dart                # Palet warna CoffeeFlow
│   └── currency_format.dart           # Formatter mata uang Rupiah (id_ID)
├── views/                             # Tampilan UI Halaman
│   ├── history/
│   │   ├── history_page.dart          # Daftar riwayat pesanan
│   │   └── order_detail_page.dart     # Detail transaksi pesanan
│   ├── home/
│   │   └── home_page.dart             # Dashboard (Statistik, Quick Actions, Recent Orders)
│   ├── menu/
│   │   ├── menu_form_page.dart        # Form Tambah & Edit Menu (dengan validasi)
│   │   └── menu_page.dart             # Halaman Kelola Menu (Search & Category filter)
│   └── orders/
│       └── order_page.dart            # Halaman Kasir / Buat Pesanan Baru
└── widgets/                           # Reusable Custom Widgets
    ├── bottom_navbar.dart             # Bottom navigation bar modern
    ├── menu_card.dart                 # Card item menu dengan aksi Edit & Delete
    └── summary_card.dart              # Card metrik statistik dashboard
```

---

## 🚀 Fitur Aplikasi

1. **Dashboard (Home)**:
   - Greeting dinamis berdasarkan waktu (*Good Morning / Good Afternoon / Good Evening*).
   - Card Total Menu, Total Orders, dan Total Revenue (format Rupiah).
   - Quick Actions: "Add Menu" (buka form menu baru) dan "New Order" (pindah ke tab order).
   - Recent Orders: Menampilkan 3 transaksi pesanan terakhir.
   - Pull-to-refresh untuk memuat ulang data.

2. **Menu Management**:
   - Menampilkan menu dalam bentuk card yang rapi dan elegan.
   - Search bar interaktif secara real-time.
   - Filter kategori: **All**, **Coffee**, dan **Non-Coffee**.
   - Tambah menu baru dengan form validasi (Nama wajib diisi, Kategori dipilih, Harga > 0).
   - Edit menu yang sudah ada.
   - Hapus menu dengan modal konfirmasi dialog.

3. **Orders (Kasir / Point of Sale)**:
   - Menampilkan seluruh katalog menu.
   - Kontrol tambah (+) dan kurang (-) kuantitas pesanan.
   - Floating cart summary yang menghitung total harga secara otomatis.
   - Tombol "Create Order" yang membuat nomor transaksi unik (`CF-YYYYMMDD-XXX`).
   - Keranjang otomatis dikosongkan setelah pesanan berhasil dibuat.

4. **Order History**:
   - Menampilkan riwayat transaksi lengkap dengan nomor order, tanggal/jam, jumlah item, dan total bayar.
   - Klik transaksi untuk membuka **Order Detail Page** (rincian item, harga satuan, subtotal, dan total pembayaran).

---

## 🔌 Integrasi CodeIgniter 4 & MySQL (XAMPP)

Aplikasi dirancang dengan arsitektur **Service Layer** yang siap switch ke REST API backend CodeIgniter 4.

### 1. Struktur Database MySQL

Jalankan query SQL berikut di **phpMyAdmin** XAMPP:

```sql
CREATE DATABASE IF NOT EXISTS coffeeflow;
USE coffeeflow;

-- Tabel Menu
CREATE TABLE IF NOT EXISTS menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category ENUM('Coffee', 'Non-Coffee') NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel Orders
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Order Items
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    menu_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Data Awal Menu
INSERT INTO menus (name, category, price) VALUES
('Americano', 'Coffee', 18000),
('Cafe Latte', 'Coffee', 22000),
('Cappuccino', 'Coffee', 22000),
('Espresso', 'Coffee', 15000),
('Mocha', 'Coffee', 25000),
('Matcha Latte', 'Non-Coffee', 20000),
('Chocolate', 'Non-Coffee', 18000),
('Thai Tea', 'Non-Coffee', 16000),
('Lemon Tea', 'Non-Coffee', 14000);
```

### 2. Endpoint REST API CodeIgniter 4

| Method | Endpoint | Deskripsi |
|---|---|---|
| `GET` | `/api/menus` | Mengambil seluruh daftar menu |
| `POST` | `/api/menus` | Menambahkan menu baru |
| `PUT` | `/api/menus/{id}` | Mengupdate menu berdasarkan ID |
| `DELETE` | `/api/menus/{id}` | Menghapus menu berdasarkan ID |
| `GET` | `/api/orders` | Mengambil riwayat seluruh pesanan |
| `POST` | `/api/orders` | Membuat transaksi pesanan baru |

### 3. Mengaktifkan Mode Live API di Flutter

Buka file `lib/services/api_service.dart` dan sesuaikan IP backend:
- Untuk Android Emulator gunakan: `http://10.0.2.2:8080/api`
- Untuk HP Android fisik gunakan IP LAN laptop/komputer Anda: `http://192.168.x.x:8080/api`

Kemudian pada `lib/services/menu_service.dart` dan `lib/services/order_service.dart`:
```dart
static bool useApi = true; // Ubah dari false menjadi true
```

---

## 🧪 Testing

Aplikasi dilengkapi unit test dan widget test:

```bash
flutter test
```
Semua 8 pengujian mencakup:
- Deserialisasi & Serialisasi JSON MenuModel (`fromJson` / `toJson`).
- Deserialisasi & Serialisasi JSON OrderModel (`fromJson` / `toJson`).
- Formatter & Parser Rupiah `CurrencyFormat`.
- Widget Smoke Test `CoffeeFlowApp`.
