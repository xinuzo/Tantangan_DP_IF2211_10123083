# main.rb
# Implementasi Traveling Salesman Problem (TSP) menggunakan Pemrograman Dinamis (Algoritma Held-Karp)

# Konstanta untuk menandakan nilai yang belum dihitung atau tidak valid
UNCOMPUTED = -1.0
NO_PATH_MARKER = -1

# Variabel global untuk memoization dan pelacakan jalur
# Akan diinisialisasi dalam fungsi tsp_solver
$memo = []
$path_tracker = []
$dist_matrix = []
$num_cities = 0
$start_node = 0
$all_visited_mask = 0

# Fungsi rekursif inti untuk TSP
# current_city: kota saat ini
# mask: bitmask kota yang sudah dikunjungi
def solve_tsp_recursive(current_city, mask)
  # Kasus dasar: semua kota telah dikunjungi, kembali ke kota awal
  if mask == $all_visited_mask
    return $dist_matrix[current_city][$start_node]
  end

  # Cek memoization
  return $memo[mask][current_city] if $memo[mask][current_city] != UNCOMPUTED

  min_cost_for_current_state = Float::INFINITY
  best_next_city_for_current_state = NO_PATH_MARKER

  # Iterasi ke semua kota berikutnya yang memungkinkan
  (0...$num_cities).each do |next_city|
    # Jika kota 'next_city' belum dikunjungi (bitnya 0 di mask)
    # dan ada jalur dari current_city ke next_city
    if (mask & (1 << next_city)).zero? && $dist_matrix[current_city][next_city] != Float::INFINITY
      new_mask = mask | (1 << next_city) # Tandai next_city sebagai dikunjungi
      cost = $dist_matrix[current_city][next_city] + solve_tsp_recursive(next_city, new_mask)

      if cost < min_cost_for_current_state
        min_cost_for_current_state = cost
        best_next_city_for_current_state = next_city
      end
    end
  end

  # Simpan hasil ke memoization table
  $memo[mask][current_city] = min_cost_for_current_state
  $path_tracker[mask][current_city] = best_next_city_for_current_state # Simpan untuk rekonstruksi jalur
  min_cost_for_current_state
end

# Fungsi utama untuk mengatur dan memanggil solusi TSP
def tsp_solver(input_matrix)
  $dist_matrix = input_matrix
  $num_cities = $dist_matrix.length

  # Penanganan kasus sederhana
  return { cost: Float::INFINITY, path: ["Matrix jarak kosong atau tidak valid"] } if $num_cities.zero?
  if $num_cities == 1
    cost_one = $dist_matrix[0][0] == Float::INFINITY ? 0 : $dist_matrix[0][0]
    return { cost: cost_one, path: [0, 0] } # Kota direpresentasikan dengan indeks 0-based
  end

  $start_node = 0 # Asumsi tur dimulai dan berakhir di kota dengan indeks 0
  $all_visited_mask = (1 << $num_cities) - 1 # Mask jika semua kota dikunjungi

  # Inisialisasi tabel memoization dan path_tracker
  # Ukuran mask adalah 2^N
  # $memo[mask][city_index]
  $memo = Array.new(1 << $num_cities) { Array.new($num_cities, UNCOMPUTED) }
  # $path_tracker[mask][city_index] = next_city_in_optimal_path
  $path_tracker = Array.new(1 << $num_cities) { Array.new($num_cities, NO_PATH_MARKER) }

  # Mask awal: hanya start_node yang dikunjungi
  initial_mask = (1 << $start_node)

  # Panggil fungsi rekursif
  min_total_cost = solve_tsp_recursive($start_node, initial_mask)

  # Rekonstruksi jalur jika solusi ditemukan
  if min_total_cost == Float::INFINITY
    return { cost: Float::INFINITY, path: ["Tidak ada tur yang valid ditemukan (graf tidak terhubung?)"] }
  end

  # Rekonstruksi jalur
  tour = [$start_node] # Jalur dimulai dari start_node
  current_mask_for_reconstruction = initial_mask
  current_city_for_reconstruction = $start_node

  while current_mask_for_reconstruction != $all_visited_mask
    next_c_in_tour = $path_tracker[current_mask_for_reconstruction][current_city_for_reconstruction]

    if next_c_in_tour == NO_PATH_MARKER
      # Ini seharusnya tidak terjadi jika min_total_cost valid dan N > 1
      return { cost: min_total_cost, path: ["Error saat merekonstruksi jalur."] }
    end

    tour << next_c_in_tour
    current_mask_for_reconstruction |= (1 << next_c_in_tour) # Update mask
    current_city_for_reconstruction = next_c_in_tour       # Pindah ke kota berikutnya
  end

  tour << $start_node # Kembali ke kota awal untuk melengkapi siklus

  # Mengubah indeks menjadi 1-based untuk output jika diinginkan, atau tetap 0-based
  # Untuk konsistensi dengan banyak contoh, kita akan tampilkan 0-based lalu bisa di-map jika perlu.
  { cost: min_total_cost, path: tour }
end

# Fungsi untuk membaca matriks dari input pengguna
def read_matrix_from_input
  puts "Masukkan jumlah kota (N):"
  n = gets.to_i
  if n <= 0
    puts "Jumlah kota tidak valid."
    return nil
  end

  puts "Masukkan matriks jarak (N baris, N kolom, pisahkan angka dengan spasi):"
  puts "Gunakan 'inf' atau angka yang sangat besar untuk jarak tak hingga."
  matrix = []
  n.times do |i|
    print "Baris #{i + 1}: "
    row_str = gets.chomp.split
    if row_str.length != n
      puts "Jumlah kolom tidak sesuai dengan N. Harap ulangi."
      return nil # Atau minta input ulang untuk baris ini
    end
    row = row_str.map do |val|
      val.downcase == 'inf' ? Float::INFINITY : val.to_i
    end
    matrix << row
  end
  matrix
end


# --- Program Utama Dimulai Di Sini ---
if __FILE__ == $PROGRAM_NAME
  puts "======================================================"
  puts "  Program Penyelesaian Traveling Salesman Problem   "
  puts "     Menggunakan Pemrograman Dinamis (Held-Karp)    "
  puts "======================================================"
  puts

  # Baca matriks dari input pengguna
  distance_matrix = read_matrix_from_input

  if distance_matrix
    puts "\nMatriks Jarak yang Dimasukkan:"
    distance_matrix.each do |row|
      puts row.map { |val| val == Float::INFINITY ? "INF" : val }.join("\t")
    end
    puts

    result = tsp_solver(distance_matrix)

    puts "------------------------------------------------------"
    if result[:cost] == Float::INFINITY
      puts "Biaya Minimum: Tak Terhingga"
      puts "Jalur: #{result[:path].join}" # Akan berisi pesan error
    else
      puts "Biaya Minimum Tur: #{result[:cost]}"
      # Menampilkan jalur dengan indeks kota dimulai dari 1 untuk kemudahan pembacaan pengguna
      adjusted_path = result[:path].map { |p| p + 1 }
      puts "Jalur Optimal (Kota Dimulai dari 1): #{adjusted_path.join(' -> ')}"
    end
    puts "------------------------------------------------------"
  else
    puts "Input matriks tidak berhasil. Program berhenti."
  end
end
