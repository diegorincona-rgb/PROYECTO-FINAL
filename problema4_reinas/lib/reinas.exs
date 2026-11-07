#Autor: Carlos Andres

defmodule Reinas do

  def soluciones(n) when n > 0 do
    colocar_reina(n, 0, [])
  end

  def soluciones(_n) do
    Stream.map([], fn x -> x end)
  end

  def colocar_reina(n, fila, colocadas) when fila == n do
    solucion = Enum.reverse(colocadas) #Invierte la lista porque las reinas se agregaron al inicio
    Stream.map([solucion], fn x -> x end)
  end

   #Intenta ubicar una reina en cada columna de la fila actual.
  def colocar_reina(n, fila, colocadas) do
    Stream.flat_map(0..(n - 1), fn columna -> #Recorre las columnas del tablero
      if segura?(columna, colocadas) do
        colocar_reina(n, fila + 1, [columna | colocadas])
      else
        Stream.map([], fn x -> x end)
      end
    end)
  end

  #Comprueba si una columna es segura frente a las reinas anteriores.
  def segura?(columna, colocadas) do
    colocadas
    |> Enum.with_index(1) #Agrega a cada reina un índice que representa su distancia en filas respecto a la nueva reina
    |> Enum.all?(fn {columna_anterior, distancia_filas} ->  #Comprueba que todas las reinas anteriores cumplan las condiciones
      columna != columna_anterior and # Verifica que no esten en la misma columna
        abs(columna - columna_anterior) != distancia_filas #Verifica que no esten en la misma diagonal
    end)
  end

  def contar_soluciones(n) do
    Enum.count(soluciones(n)) #Cuenta las soluciones
  end
end

"""
IO.puts("Prueba para N = 1")
IO.inspect(Reinas.contar_soluciones(1))

IO.puts("Prueba para N = 2")
IO.inspect(Reinas.contar_soluciones(2))

IO.puts("Prueba para N = 3")
IO.inspect(Reinas.contar_soluciones(3))

IO.puts("Prueba para N = 4")
IO.inspect(Reinas.contar_soluciones(4))

IO.puts("Prueba para N = 5")
IO.inspect(Reinas.contar_soluciones(5))

IO.puts("Prueba para N = 6")
IO.inspect(Reinas.contar_soluciones(6))

IO.puts("Prueba para N = 7")
IO.inspect(Reinas.contar_soluciones(7))

IO.puts("Prueba para N = 8")
IO.inspect(Reinas.contar_soluciones(8))

IO.puts("Soluciones para N = 4 take/1 to_list")
Reinas.soluciones(4)
|> Stream.take(1)
|> Enum.to_list()
|> IO.inspect()

IO.puts("Soluciones para N = 4 to_list")
Reinas.soluciones(4)
|> Enum.to_list()
|> IO.inspect()

IO.puts("Soluciones para N = 20 take/1")
Reinas.soluciones(20)
|> Enum.take(1)
|> IO.inspect()
"""
