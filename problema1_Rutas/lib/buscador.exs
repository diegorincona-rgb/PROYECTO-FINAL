# Autora: Natalia Garcia

defmodule Buscador do
  @moduledoc """
  Módulo que implementa la búsqueda de rutas entre ciudades en un grafo.
  """

  @doc """
  Devuelve todas las rutas posibles entre `origen` y `destino` en el grafo.
  Cada ruta se representa como una estructura `%Ruta{}` que contiene la lista de ciudades
  y la distancia total.
  """
  def todas_las_rutas(grafo, origen, destino) do
    buscar(grafo, origen, destino, [origen], 0)
  end

  # Caso base: si la ciudad actual es el destino, se devuelve la ruta encontrada.
  defp buscar(_grafo, destino, destino, camino, distancia) do
    [%Ruta{ciudades: Enum.reverse(camino), distancia: distancia}]
  end

  # Caso recursivo: se exploran los vecinos de la ciudad actual, evitando volver a las ciudades ya visitadas.
  defp buscar(grafo, actual, destino, camino, distancia) do
    grafo
    |> Grafo.vecinos(actual)
    |> Enum.reject(fn {vecino, _tramo} -> vecino in camino end)
    |> Enum.flat_map(fn {vecino, tramo} ->
      buscar(grafo, vecino, destino, [vecino | camino], distancia + tramo)
    end)
  end

  @doc """
  Devuelve las rutas con el menor número de ciudades entre todas las rutas posibles.
  """
  def mas_cortas([]), do: []

  def mas_cortas(rutas) do
    minimo =
      rutas
      |> Enum.map(&Ruta.num_ciudades/1)
      |> Enum.min()

    Enum.filter(rutas, fn ruta -> Ruta.num_ciudades(ruta) == minimo end)
  end

  @doc """
  Devuelve la ruta con la menor distancia entre todas las rutas posibles.
  """
  def menor_distancia([]), do: nil
  def menor_distancia(rutas), do: Enum.min_by(rutas, fn ruta -> ruta.distancia end)
end
