# Autora: Natalia Garcia

defmodule Grafo do
  @moduledoc """
  Módulo que representa un grafo de ciudades y sus conexiones.
  """

  @doc """
  Construye un grafo a partir de una lista de conexiones.
  El grafo se representa como un mapa donde cada clave es una ciudad y su valor es una
  lista de tuplas con los vecinos y las distancias.
  """
  def construir(conexiones) do
    conexiones
    |> Enum.reduce(%{}, fn %Conexion{origen: origen, destino: destino, distancia: distancia},
                           grafo ->
      grafo
      |> Map.update(origen, [{destino, distancia}], &[{destino, distancia} | &1])
      |> Map.update(destino, [{origen, distancia}], &[{origen, distancia} | &1])
    end)
    # Se invierte la lista de vecinos para que se mantenga el orden original de las conexiones.
    |> Map.new(fn {ciudad, vecinos} -> {ciudad, Enum.reverse(vecinos)} end)
  end

  @doc """
  Devuelve `true` si la ciudad existe en el grafo, `false` en caso contrario.
  """
  def existe?(grafo, ciudad), do: Map.has_key?(grafo, ciudad)

  @doc """
  Devuelve la lista de vecinos de una ciudad en el grafo. Si la ciudad no existe,
  devuelve una lista vacía.
  """
  def vecinos(grafo, ciudad), do: Map.get(grafo, ciudad, [])
end
