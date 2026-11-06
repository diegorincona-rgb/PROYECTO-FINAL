defmodule Reinas do

  def soluciones(n) when n > 0 do
    colocar_reina(n, 0, [])
  end

  def soluciones(_n) do
    Stream.map([], fn x -> x end)
  end

  def colocar_reina(n, fila, colocadas) when fila == n do
    solucion = Enum.reverse(colocadas)
    Stream.map([solucion], fn x -> x end)
  end

   # Intenta ubicar una reina en cada columna de la fila actual.
  def colocar_reina(n, fila, colocadas) do
    Stream.flat_map(0..(n - 1), fn columna ->
      if segura?(columna, colocadas) do
        colocar_reina(n, fila + 1, [columna | colocadas])
      else
        Stream.map([], fn x -> x end)
      end
    end)
  end

  # Comprueba si una columna es segura frente a las reinas anteriores.
  def segura?(columna, colocadas) do
    colocadas
    |> Enum.with_index(1)
    |> Enum.all?(fn {columna_anterior, distancia_filas} ->
      columna != columna_anterior and
        abs(columna - columna_anterior) != distancia_filas
    end)
  end

  # Cuenta las soluciones consumiendo el Stream.
  def contar_soluciones(n) do
    Enum.count(soluciones(n))
  end
end
