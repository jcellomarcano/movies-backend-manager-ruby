class Main

    # FUNCTIONS
    def self.get_path
        puts "\nPor favor ingrese la direccion desde donde se cargaran los archivo"
        path = gets.chomp
    end




    # MAIN

    puts "**************************"
    puts "Bienvenido a Lambdabuster\n"

    while TRUE
        path = self.get_path()
        charge_data = TRUE #Funcion que carga los datos
        if charge_data = FALSE
            puts "\nLo sentimos, no pudimos cargar los datos :("
            puts "\nAsegurate de haber colocado la ruta retaliva"
            puts "y la estructura del archivo correcta para el programa"
            puts "\nOpciones:"
            puts "1. Reintentar"
            puts "2. Salir"
            option = gets.chomp.to_i
            if option != 1
                exit(0)
            end
        else
            puts "\nDatos cargados con exito :D"
            break
        end
    end

    while TRUE
        puts "\nQue accion quiere realizar?"
        puts "1. Crear nueva orden de alquiler"
        puts "2. Crear nueva orden de compra"
        puts "3. Mi Usuario"
        puts "4. Consultar catálogo"
        puts "5. Salir"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i

        case option
        when 1
            puts "1. Crear nueva orden de alquiler"
        when 2
            puts "2. Crear nueva orden de compra"
        when 3
            puts "3. Mi Usuario"
        when 4
            puts "4. Consultar catálogo"
        when 5
            puts "\nGracias por usar Lambdabuster"
            puts "Nos vemos en la proxima :D"
            exit(0)
        else
            puts "\nPrueba una opcion valida :3"
        end

    end

    
end