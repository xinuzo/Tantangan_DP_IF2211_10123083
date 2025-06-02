require 'fileutils' 

UNCOMPUTED = -1.0
NO_PATH_MARKER = -1

$memo = []
$path_tracker = []
$dist_matrix = []
$num_cities = 0
$start_node = 0
$all_visited_mask = 0

def tsp_recursive(current_city, mask)
  # base case: semua kota telah dikunjungi, kembali ke kota awal
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
      cost = $dist_matrix[current_city][next_city] + tsp_recursive(next_city, new_mask)

      if cost < min_cost_for_current_state
        min_cost_for_current_state = cost
        best_next_city_for_current_state = next_city
      end
    end
  end

  $memo[mask][current_city] = min_cost_for_current_state
  $path_tracker[mask][current_city] = best_next_city_for_current_state 
  min_cost_for_current_state
end

def tsp_solver(input_matrix)
  $dist_matrix = input_matrix
  $num_cities = $dist_matrix.length
  return { cost: Float::INFINITY, path: ["Matrix jarak kosong atau tidak valid"] } if $num_cities.zero?
  if $num_cities == 1
    cost_one = $dist_matrix[0][0] == Float::INFINITY ? 0 : $dist_matrix[0][0]
    return { cost: cost_one, path: [0, 0] } 
  end

  $start_node = 0 
  $all_visited_mask = (1 << $num_cities) - 1 

 
  $memo = Array.new(1 << $num_cities) { Array.new($num_cities, UNCOMPUTED) }
  $path_tracker = Array.new(1 << $num_cities) { Array.new($num_cities, NO_PATH_MARKER) }

  initial_mask = (1 << $start_node)
  min_total_cost = tsp_recursive($start_node, initial_mask)

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

def read
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
    print "Baris #{i + 1}: "
    row_str = gets.chomp.split
    if row_str.length != n
      puts "Error: Jumlah kolom tidak sesuai dengan N (#{n}). Ulangi input untuk baris ini."
      redo 
    end
    begin
      row = row_str.map do |val|
        val.downcase == 'inf' ? Float::INFINITY : Integer(val)
      end
      matrix << row
    rescue ArgumentError
      puts "Error: Input tidak valid. Pastikan semua nilai adalah angka atau 'inf'. Ulangi input untuk baris ini."
      redo 
    end
  end
  matrix
end

def output(result, output_dir = "output") 
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
        adjusted_path = result[:path].map { |p| p + 1 } 
        file.puts "Optimal path: #{adjusted_path.join(' -> ')}"
      end
    end
    puts "Output berhasil ditulis ke: #{output_filename}"
  rescue StandardError => e
    puts "Error saat menulis output ke file: #{e.message}"
  end
end

if __FILE__ == $PROGRAM_NAME
  distance_matrix = read

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
    output(result)
  else
    puts "Input matriks tidak berhasil."
  end
end
