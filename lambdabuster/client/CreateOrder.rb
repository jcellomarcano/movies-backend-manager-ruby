def create_order(movies,type,user)
    if type == :rent
        my_name="rentar"
        verb_in_past="rentado"
        my_price="rent_price"
        action="rent_order"
        store="rented_movies"
    else
        my_name="comprar"
        verb_in_past="comprado"
        my_price="price"
        action="buy_order"
        store="owned_movies"
    end
    puts "¿Que pelicula quiere #{my_name}?"
    puts "Inserta el nombre de la pelicula"
    movie_name = gets.chomp.to_i
    movie=movies.scan(:name) { |x| x == movie_name}
    if movie.length < 0
        puts "\nSorry, no se encontró la pelicula :("
        while true
            puts "\nQue accion quiere realizar?"
            puts "1. Intentar con otro nombre"
            puts "2. Volver al menu inicial"
            puts "3. Consultar peliculas"
            puts "4. Salir"
            puts ""
            puts "Inserta el numero de la opcion"
            option = gets.chomp.to_i
            case option
            when 1
                resp=create_order(movies,type)
                break
            when 2
                resp=1
                break
            when 3
                puts "3. Consultar peli"
                break
            when 4
                puts "\nGracias por usar Lambdabuster"
                puts "Nos vemos en la proxima :D"
                exit(0)
            else
                puts "\nPrueba una opcion valida :3"
            end
        end
    else
        my_movie=nil
        movie.each do |x|
            x.to_s
            # puts "\nPelicula encontrada: #{x.name}"
            # puts "Duracion: #{x.runtime}"
            # puts "Categorias: #{x.categories}"
            # puts "Fecha de lanzamiento: #{x.release_date}"
            # puts "Directors: #{x.directors}"
            # puts "Actores: #{x.actors}"
            # puts "Precio de compra: #{x.price}"
            # puts "Precio para rentar: #{x.rent_price}"
            my_movie=x
        end
        while true
            puts "\nElige el metodo de pago que mejor se adapte:"
            puts "1. Dolares"
            puts "2. Bolivares"
            puts "3. Euros"
            puts "4. Bitcoin"
            option = gets.chomp.to_i
            currency=my_movie.method(my_price).call.dolars
            case option
            when 1
                break
            when 2
                puts "Precio: #{currency.in(:bolivares).to_s}"
                break
            when 3
                puts "Precio: #{currency.in(:euros).to_s}"
                break
            when 4
                puts "Precio: #{currency.in(:bitcoin).to_s}"
                break
            else
                puts "\nPrueba una opcion valida"
            end  
        end
        puts "Precio: #{currency.to_s}"
        while true
            puts "\n1. Continuar"
            puts "2. Volver al menu inicial"
            option = gets.chomp.to_i
            case option
            when 1
                transaction=Transaction.new(my_movie,type)
                method(action).call(transaction)
                user.method(store)<<my_movie
                user.method("transactions")<<transaction
                puts "\nLa pelicula se ha #{verb_in_past} con exito!!"
                puts "Ya la tienes disponible en tu perfil"
                puts "Que la disfrutes :D"
                break
            when 2
                break
            else
                puts "\nPrueba una opcion valida"
            end

        end
    end
end