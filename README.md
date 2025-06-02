# Travelling Salesman Problem Using Dynamic Programming

## Permasalahan TSP (Travelling Salesman Problem)

Travelling Salesman Problem (TSP) adalah salah satu permasalahan optimasi perjalanan suatu agen untuk mengunjungi sejumlah kota (N), tepat satu kali masing-masing, dan kembali ke kota awal dengan total biaya atau jarak yang seminimal mungkin.

## Deskripsi Singkat Program

Program ini diimplementasikan dalam bahasa Ruby dan menyelesaikan permasalahan TSP menggunakan pendekatan rekursif berbasis Dynamic Programming dengan bitmasking dan memoization. Program meminta input berupa jumlah kota dan matriks ketetanggaan (biaya antar kota). Hasil yang ditampilkan mencakup rute optimal dan total biaya minimal.

## Penjelasan Algoritma

### Fungsi Utama: `tsp_solver`

Fungsi ini menginisialisasi variabel global dan struktur data yang diperlukan:

* `$dist_matrix`: Matriks jarak antar kota
* `$memo[mask][city]`: Menyimpan biaya minimum untuk kombinasi kota yang telah dikunjungi (bitmask) dan posisi kota saat ini
* `$path_tracker[mask][city]`: Menyimpan jejak kota berikutnya yang optimal untuk keperluan rekonstruksi jalur
* `$all_visited_mask`: Nilai bitmask ketika semua kota telah dikunjungi (misal untuk 4 kota = `1111` dalam biner)

Kemudian, program menjalankan fungsi rekursif `tsp_recursive(start_city, mask)` untuk menghitung biaya minimum, lalu merekonstruksi rute menggunakan informasi pada `$path_tracker`.

### Fungsi Rekursif: `tsp_recursive(current_city, mask)`

1. **Basis:**
   Jika semua kota sudah dikunjungi (mask = `$all_visited_mask`), kembalikan jarak dari `current_city` ke kota awal.

2. **Memoization:**
   Jika hasil subproblem untuk `mask` dan `current_city` sudah dihitung sebelumnya, langsung kembalikan nilainya dari `$memo`.

3. **Eksplorasi Kota Berikutnya:**
   Iterasi ke semua kota yang belum dikunjungi dan memiliki jalur dari kota saat ini.

   * Tandai kota baru sebagai dikunjungi (`new_mask = mask | (1 << next_city)`)
   * Hitung biaya total: jarak dari `current_city` ke `next_city` ditambah hasil rekursif dari `next_city`
   * Perbarui biaya minimum dan simpan jejak kota optimal di `$path_tracker`

4. **Simpan hasil:**
   Setelah mengevaluasi semua kemungkinan kota berikutnya, simpan hasil ke `$memo` dan kembalikan nilai minimum.

### Rekonstruksi Jalur

Setelah mendapatkan total biaya minimum, program menyusun kembali rute optimal dari data di `$path_tracker`, dimulai dari kota awal hingga semua kota telah dikunjungi, lalu kembali ke awal.


## Struktur Proyek

```
├── output
    ├── tsp_output_xxxx.txt
├── test
│   ├── test1
│   ├── test2
│   └── test3
├── main.rb
└── LICENSE
└── README.md
```

## Prasyarat

1. Ruby

   * Unduh dan pasang Ruby dari [situs resmi](https://www.ruby-lang.org/en/)
   * Verifikasi instalasi dengan menjalankan perintah:

     ```bash
     $ ruby --version
     ```

## Cara Compile dan Menjalankan Program

1. **Clone repositori**

   ```bash
   $ git clone https://github.com/xinuzo/Tantangan_DP_IF2211_10123083.git
   ```
2. **Jalankan program**

   ```bash
   $ ruby main.rb
   ```

## Contoh Kasus Uji
![Screenshot 2025-06-02 204859](https://github.com/user-attachments/assets/6ebaf8fe-c01e-447b-9cd5-73aaf9b16dcb)



## Penulis

| Nama           | NIM      | Kelas |
| -------------- | -------- | ----- |
| Rendi Adinata  | 10123083 | K01   |
