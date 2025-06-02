# Traveling Salesman Problem (TSP) dengan Pemrograman Dinamis (Ruby)

Implementasi Traveling Salesman Problem (TSP) menggunakan algoritma Held-Karp (pemrograman dinamis dengan bitmasking) dalam bahasa Ruby. Program ini mencari rute terpendek yang mengunjungi setiap kota tepat satu kali dan kembali ke kota awal. Input diterima secara interaktif dari pengguna, dan output (hasil) dituliskan ke sebuah file teks.

## Deskripsi Algoritma

Program ini menggunakan pendekatan pemrograman dinamis, khususnya algoritma Held-Karp, untuk menyelesaikan TSP. Ide utamanya adalah memecah masalah menjadi sub-masalah yang lebih kecil dan tumpang tindih, lalu menyimpan solusi dari sub-masalah tersebut (memoization) untuk menghindari perhitungan berulang.

-   **State**: `memo[mask][pos]` merepresentasikan biaya minimum untuk mengunjungi semua kota dalam `mask` (sebuah bitmask), dimulai dari kota awal, dan berakhir di kota `pos`.
-   **Bitmask**: Sebuah integer digunakan untuk merepresentasikan himpunan kota yang telah dikunjungi. Jika bit ke-`j` adalah 1, kota `j` telah dikunjungi.
-   **Rekurensi**: Solusi dibangun secara rekursif dengan mencoba mengunjungi kota berikutnya yang belum dikunjungi dari kota saat ini.

## Prinsip Optimalitas dalam TSP

Solusi optimal untuk TSP mematuhi Prinsip Optimalitas Bellman. Prinsip ini menyatakan bahwa jika sebuah rute adalah optimal, maka setiap sub-rute dari rute tersebut juga harus optimal.

## Cara Menjalankan Program

1.  **Pastikan Ruby Terinstal**: Jika belum, instal Ruby (lihat panduan instalasi Ruby di respons sebelumnya atau situs resmi Ruby).
2.  **Simpan Kode**: Simpan kode program Ruby (dari blok kode `main.rb (input interaktif, output file)` di atas) sebagai file, misalnya `main.rb`.
3.  **Buka Terminal/Command Prompt**: Navigasi ke direktori tempat Anda menyimpan file `main.rb`.
4.  **Jalankan Program**:
    ```bash
    ruby main.rb
    ```
5.  **Input Interaktif**: Program akan meminta Anda untuk:
    * Memasukkan jumlah kota (N).
    * Memasukkan matriks jarak baris per baris. Pisahkan angka dalam satu baris dengan spasi. Gunakan `inf` (case-insensitive) untuk jarak tak hingga.
    Contoh sesi input:
    ```
    Input number of city (N):
    4
    Enter the adjacency matrix (each row on a new line):
    Gunakan 'inf' atau angka yang sangat besar untuk jarak tak hingga.
    Baris 1 (pisahkan angka dengan spasi): 0 10 15 20
    Baris 2 (pisahkan angka dengan spasi): 5 0 9 10
    Baris 3 (pisahkan angka dengan spasi): 6 13 0 12
    Baris 4 (pisahkan angka dengan spasi): 8 8 9 0
    ```
6.  **Output di Konsol**: Program akan mencetak matriks jarak yang dibaca, total biaya (jarak) minimum dari tur salesman, dan jalur (urutan kota) yang ditempuh ke konsol.
7.  **Output ke File**: Hasil yang sama juga akan dituliskan ke sebuah file teks di dalam direktori `output` (direktori ini akan dibuat jika belum ada). Nama file akan memiliki format `tsp_output_YYYYMMDD_HHMMSS.txt` (misalnya, `tsp_output_20250602_203000.txt`).

## Format Output File

File output akan berisi:
1.  Baris pertama: Biaya minimum tur.
    `Minimum cost: <biaya>`
2.  Baris kedua: Jalur optimal. Indeks kota dimulai dari 1.
    `Optimal path: <kota1> -> <kota2> -> ... -> <kota_awal>`

**Contoh Isi File Output (`output/tsp_output_....txt`):**
Minimum cost: 35Optimal path: 1 -> 2 -> 4 -> 3 -> 1Jika tidak ada solusi yang valid:
Minimum cost: INFINITYOptimal path: Tidak ada tur yang valid ditemukan (graf tidak terhubung?)
## Struktur Proyek (Direkomendasikan)
.├── main.rb           # Kode program utama├── output/           # Direktori untuk menyimpan file output (dibuat otomatis)│   └── tsp_output_....txt└── README.md         # File ini
## Penanganan Error
Program akan mencoba menangani beberapa error dasar pada input interaktif, seperti:
- Input N bukan angka positif.
- Jumlah kolom pada baris matriks tidak sesuai dengan N.
- Input nilai matriks bukan angka atau 'inf'.
Jika terjadi error pada input baris matriks, program akan meminta pengguna untuk mengulangi input untuk baris tersebut.
