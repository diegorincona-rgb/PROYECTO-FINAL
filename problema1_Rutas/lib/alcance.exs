
# Autor: Diego Rincon
# Ciudades alcanzables desde un origen, con un Stream infinito de conjuntos.
# Supone que el grafo es un mapa %{ciudad => [{vecino, distancia}]} (contrato con Persona A).

defmodule Alcance do
  @moduledoc """
  Paso 0: solo el origen. Cada paso siguiente agrega los vecinos de las ciudades del anterior.
  La secuencia es infinita; se corta cuando un paso es igual al anterior.
  """

  @doc "Stream infinito de MapSet. No calcula nada hasta que alguien lo consume."
  def pasos(grafo, origen) do
    Stream.iterate(MapSet.new([origen]), fn actual -> ampliar(grafo, actual) end)
  end

  @doc "Devuelve la lista de pasos hasta estabilizarse (sin incluir el paso repetido)."
  def hasta_estabilizar(grafo, origen) do
    grafo
    |> pasos(origen)
    |> estabilizar()
  end

  @doc """
  Consume el stream solo hasta que un paso sea igual al anterior.
  El paso repetido se calcula para poder compararlo, pero no se incluye en el resultado.
  """
  def estabilizar(pasos) do
    pasos
    |> Stream.transform(nil, fn
      # igual al anterior: se detiene
      paso, paso -> {:halt, paso}
      # distinto: se emite y se recuerda
      paso, _anterior -> {[paso], paso}
    end)
    |> Enum.to_list()
  end

  @doc "El destino es alcanzable si está en el último paso (el conjunto final)."
  def alcanzable?(pasos, destino) do
    pasos |> List.last() |> MapSet.member?(destino)
  end

  @doc "Líneas de alcance.txt para una consulta (ciudades en orden alfabético)."
  def lineas(origen, pasos) do
    detalle =
      pasos
      |> Enum.with_index()
      |> Enum.map(fn {paso, n} -> "Paso #{n}: #{ciudades_a_texto(paso)}" end)

    ["=== Alcance desde #{origen} ==="] ++
      detalle ++ ["Se estabiliza en el paso #{length(pasos) - 1}"]
  end

  @doc "Crea (o reemplaza) alcance.txt. Se llama una sola vez, antes de las consultas."
  def reiniciar(ruta) do
    File.mkdir_p!(Path.dirname(ruta))
    File.write!(ruta, "")
  end

  @doc "Agrega las líneas de una consulta al archivo, una por una, y las muestra en pantalla."
  def escribir(lineas, ruta) do
    File.open!(ruta, [:append, :utf8], fn archivo ->
      Enum.each(lineas, fn linea ->
        IO.puts(archivo, linea)
        IO.puts(linea)
      end)

      IO.puts(archivo, "")
      IO.puts("")
    end)
  end

  # Agrega al conjunto actual los vecinos de todas sus ciudades.
  defp ampliar(grafo, actual) do
    Enum.reduce(actual, actual, fn ciudad, acumulado ->
      grafo
      |> vecinos(ciudad)
      |> Enum.reduce(acumulado, fn {vecino, _distancia}, acc -> MapSet.put(acc, vecino) end)
    end)
  end

  # Único punto que depende de la forma del grafo. Si Persona A usa Grafo.vecinos/2,
  # se cambia solo esta línea.
  defp vecinos(grafo, ciudad), do: Map.get(grafo, ciudad, [])

  defp ciudades_a_texto(paso), do: paso |> MapSet.to_list() |> Enum.sort() |> Enum.join(", ")
end
