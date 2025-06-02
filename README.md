Travelling Salesman Problem Solver using Dynamic ProgrammingOverview and AlgorithmPermasalahan Traveling Salesman Problem (TSP):TSP adalah masalah optimasi klasik dalam ilmu komputer dan riset operasi. Tujuannya adalah untuk menemukan rute terpendek yang memungkinkan seorang "salesman" mengunjungi setiap kota dalam daftar yang diberikan tepat satu kali dan kembali ke kota asal (kota pertama). Ini adalah masalah NP-hard, yang berarti tidak ada algoritma solusi efisien (waktu polinomial) yang diketahui untuk semua kasus, terutama untuk jumlah kota yang besar.Algoritma yang Digunakan (Dynamic Programming - Held-Karp):Program ini mengimplementasikan solusi TSP menggunakan pendekatan pemrograman dinamis, khususnya variasi dari algoritma Held-Karp. Cara kerjanya adalah sebagai berikut:State: Sebuah state dalam DP biasanya direpresentasikan sebagai (mask, last_city), di mana mask adalah bitmask yang menunjukkan himpunan kota yang telah dikunjungi, dan last_city adalah kota terakhir yang dikunjungi dalam sub-rute tersebut.Memoization: Hasil dari setiap state (biaya minimum untuk mencapai last_city setelah mengunjungi semua kota di mask) disimpan dalam tabel memoization untuk menghindari perhitungan berulang.Rekurensi: Biaya untuk state (mask, u) dihitung dengan mempertimbangkan semua kemungkinan kota v yang belum ada di mask, lalu mengambil minimum dari biaya(v, u) + dp[mask | (1 << u)][u].Kasus Dasar: Biaya untuk mengunjungi kota pertama dari kota pertama adalah 0.Solusi Akhir: Setelah semua state terisi, solusi akhir adalah biaya minimum untuk mengunjungi semua kota dan kembali ke kota awal.Program ini akan meminta input jumlah kota (N) dan matriks jarak (adjacency matrix) antar kota secara interaktif. Kemudian, program akan menghitung dan menampilkan rute dengan biaya minimal, dengan asumsi titik awal dan akhir adalah kota pertama (indeks 0 dalam program, atau kota ke-1 dalam tampilan pengguna). Output juga akan disimpan dalam sebuah file teks.Project Structure.
├── 📁 output/                     # Direktori untuk menyimpan file output (dibuat otomatis)
│   └── tsp_output_YYYYMMDD_HHMMSS.txt
├── 📁 test/                       # (Opsional) Direktori untuk file uji manual Anda
│   └── test1.txt
│   └── test2.txt
│   └── test3.txt
├── main.rb                       # Kode program utama
├── pseudocode.txt                # (Opsional) Pseudocode algoritma jika Anda menyediakannya
└── README.md                     # File ini
PrerequisitesRubyDownload dan instal Ruby dari situs resmi Ruby.Verifikasi instalasi dengan menjalankan perintah berikut di terminal Anda:ruby -v
Anda juga bisa memeriksa versi gem (manajer paket Ruby):gem -v
How to Compile and Run the ProgramClone this repository (Jika Anda meng-host ini di GitHub)Untuk mendapatkan kode program, Anda bisa meng-clone repository ini (jika sudah ada di GitHub) dengan perintah:git clone [https://github.com/USERNAME_ANDA/NAMA_REPOSITORY_ANDA.git](https://github.com/USERNAME_ANDA/NAMA_REPOSITORY_ANDA.git)
cd NAMA_REPOSITORY_ANDA
Ganti USERNAME_ANDA dan NAMA_REPOSITORY_ANDA dengan detail yang sesuai. Jika Anda hanya memiliki file main.rb, lewati langkah ini.Run the programUntuk menjalankan program, navigasikan ke direktori tempat file main.rb berada menggunakan terminal, lalu jalankan perintah:ruby main.rb
Program akan meminta Anda memasukkan jumlah kota dan matriks jarak secara interaktif. Hasilnya akan ditampilkan di konsol dan juga disimpan dalam sebuah file di dalam folder output/.Contoh Sesi Input/Output ProgramBerikut adalah contoh bagaimana program berinteraksi dengan pengguna dan output yang dihasilkan (tampilan konsol)

  Travelling Salesman Problem Solver using Dynamic Programming
Masukkan banyaknya jumlah kota (N):
4
Masukkan adjacent matrix:
Gunakan 'inf' atau angka yang sangat besar untuk jarak tak hingga.
Baris 1 : 0 10 15 20
Baris 2 : 5 0 9 10
Baris 3 : 6 13 0 12
Baris 4 : 8 8 9 0

Your adjacent matrix:
0	10	15	20
5	0	9	10
6	13	0	12
8	8	9	0

Minimum cost: 35
Optimal path: 1 -> 2 -> 4 -> 3 -> 1

Output berhasil ditulis ke: output/tsp_output_20250602_205015.txt
Cara Menambahkan Gambar Screenshot ke README.md:Ambil screenshot dari sesi input/output program Anda.Simpan gambar tersebut (misalnya sebagai contoh_io.png) di dalam direktori repository Anda. Cara yang umum adalah membuat folder assets/ atau images/ dan meletakkan gambar di sana.Untuk menampilkan gambar di README, gunakan sintaks Markdown berikut