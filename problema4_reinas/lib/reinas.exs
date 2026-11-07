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

   #Intenta ubicar una reina en cada columna de la fila actual
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
