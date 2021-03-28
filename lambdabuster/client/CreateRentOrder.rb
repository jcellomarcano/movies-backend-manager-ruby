def create_rent_order(movies)
    puts "¿Que pelicula quiere rentar?"
    puts "Inserta el nombre de la pelicula"
    movie_name = gets.chomp.to_i
    movie=movies.scan(:name) { |x| x == movie_name}
    if movie.length < 0
    end
end