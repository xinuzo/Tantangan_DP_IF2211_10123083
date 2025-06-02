# Dynamic Programming Travelling Salesman Problem

## Permasalahan TSP (Travelling Salesman Problem)

Travelling Salesman Problem (TSP) adalah salah satu permasalahan optimasi perjalanan suatu agen untuk mengunjungi sejumlah kota (N), tepat satu kali masing-masing, dan kembali ke kota awal dengan total biaya atau jarak yang seminimal mungkin.

## Deskripsi Singkat Program

Program ini diimplementasikan dalam bahasa Ruby dan menyelesaikan permasalahan TSP menggunakan pendekatan rekursif berbasis Dynamic Programming dengan bitmasking dan memoization. Program meminta input berupa jumlah kota dan matriks ketetanggaan (biaya antar kota). Hasil yang ditampilkan mencakup rute optimal dan total biaya minimal.

## Penjelasan Algoritma

Program ini mengimplementasikan solusi Traveling Salesman Problem (TSP) menggunakan pendekatan pemrograman dinamis. Prinsip utama algoritma ini adalah memecah masalah besar menjadi sub-masalah yang lebih kecil dan dapat dikelola, kemudian menyelesaikannya secara bertahap.

Sub-masalah dalam konteks ini didefinisikan sebagai "pencarian jalur terpendek yang mengunjungi himpunan bagian (subset) dari total kota dan berakhir di sebuah kota spesifik dalam himpunan tersebut". Solusi untuk sub-masalah yang lebih besar dibangun berdasarkan solusi dari sub-masalah yang lebih kecil yang telah dihitung sebelumnya.

Untuk efisiensi, hasil dari setiap sub-masalah disimpan dalam sebuah struktur data (proses memoization) untuk menghindari perhitungan berulang. Representasi himpunan kota yang telah dikunjungi dikelola untuk setiap sub-rute.

Setelah biaya minimum untuk mengunjungi semua kota ditemukan, langkah terakhir adalah menambahkan biaya untuk kembali ke kota awal. Hasilnya adalah total biaya minimum untuk keseluruhan tur.
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
| Rendi Adinata  | 10123083 | K1    |
