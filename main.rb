require 'fileutils' 

# Konstanta untuk menandakan nilai yang belum dihitung atau tidak valid
UNCOMPUTED = -1.0
NO_PATH_MARKER = -1

# Variabel global untuk memoization dan path traversing
$memo = []
$path_tracker = []
$dist_matrix = []
$num_cities = 0
$start_node = 0
$all_visited_mask = 0

# Fungsi rekursif TSP
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
    # Jika kota 'next_city' belum dikunjungi (bitnya 0 di mask) dan ada jalur dari current_city ke next_city
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
  $memo = Array.new(1 << $num_cities) { Array.new($num_cities, UNCOMPUTED) }
  $path_tracker = Array.new(1 << $num_cities) { Array.new($num_cities, NO_PATH_MARKER) }

  initial_mask = (1 << $start_node)
  min_total_cost = solve_tsp_recursive($start_node, initial_mask)

  if min_total_cost == Float::INFINITY
    return { cost: Float::INFINITY, path: ["Tidak ada tur yang valid ditemukan"] }
  end

  tour = [$start_node]
  current_mask_for_reconstruction = initial_mask
  current_city_for_reconstruction = $start_node

  while current_mask_for_reconstruction != $all_visited_mask
    next_c_in_tour = $path_tracker[current_mask_for_reconstruction][current_city_for_reconstruction]
    if next_c_in_tour == NO_PATH_MARKER
      return { cost: min_total_cost, path: ["Error saat merekonstruksi jalur."] }
    end
    tour << next_c_in_tour
    current_mask_for_reconstruction |= (1 << next_c_in_tour)
    current_city_for_reconstruction = next_c_in_tour
  end
  tour << $start_node
  { cost: min_total_cost, path: tour }
end

# Fungsi untuk membaca matriks dari input user
def read_matrix_from_interactive_input
  puts "Masukkan banyaknya jumlah kota (N):"
  n_str = gets.chomp
  unless n_str.match?(/^\d+$/) && n_str.to_i > 0
    puts "Error: Jumlah kota (N) tidak valid. Harus berupa angka positif."
    return nil
  end
  n = n_str.to_i

  puts "Masukkan adjacent matrix: "
  puts "Gunakan 'inf' atau angka yang sangat besar untuk jarak tak hingga."
  matrix = []
  n.times do |i|
    print "Baris #{i + 1} (pisahkan angka dengan spasi): "
    row_str = gets.chomp.split
    if row_str.length != n
      puts "Error: Jumlah kolom tidak sesuai dengan N (#{n}). Harap ulangi input untuk baris ini."
      redo # Ulangi iterasi saat ini (meminta input baris lagi)
    end
    begin
      row = row_str.map do |val|
        val.downcase == 'inf' ? Float::INFINITY : Integer(val)
      end
      matrix << row
    rescue ArgumentError
      puts "Error: Input tidak valid. Pastikan semua nilai adalah angka atau 'inf'. Harap ulangi input untuk baris ini."
      redo # Ulangi iterasi saat ini
    end
  end
  matrix
end

# Fungsi output ke file 
def write_output_to_file(result, output_dir = "output")
  # Buat direktori output 
  FileUtils.mkdir_p(output_dir) unless File.directory?(output_dir)

  timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
  output_filename = File.join(output_dir, "tsp_output_#{timestamp}.txt")

  begin
    File.open(output_filename, "w") do |file|
      if result[:cost] == Float::INFINITY
        file.puts "Minimum cost: INFINITY"
        file.puts "Optimal path: #{result[:path].join}" 
      else
        file.puts "Minimum cost: #{result[:cost]}"
        adjusted_path = result[:path].map { |p| p + 1 } # Indeks kota dimulai dari 1
        file.puts "Optimal path: #{adjusted_path.join(' -> ')}"
      end
    end
    puts "Output berhasil ditulis ke: #{output_filename}"
  rescue StandardError => e
    puts "Error saat menulis output ke file: #{e.message}"
  end
end

if __FILE__ == $PROGRAM_NAME
  distance_matrix = read_matrix_from_interactive_input

  if distance_matrix
    puts "\nAdjacent Matrix:"
    distance_matrix.each do |row|
      puts row.map { |val| val == Float::INFINITY ? "INF" : val }.join("\t")
    end
    puts
    result = tsp_solver(distance_matrix)

    if result[:cost] == Float::INFINITY
      puts "Minimum cost: INFINITY"
      puts "Optimal path: #{result[:path].join}" 
    else
      puts "Minimum cost: #{result[:cost]}"
      adjusted_path = result[:path].map { |p| p + 1 }
      puts "Optimal path: #{adjusted_path.join(' -> ')}"
    end
    write_output_to_file(result)
  else
    puts "Input matriks tidak berhasil."
  end
end
