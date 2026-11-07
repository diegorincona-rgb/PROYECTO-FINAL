# Autor: Carlos Andres

defmodule EscritorRutas do

  def buscar_rutas(grafo, origen, destino) do
    if Grafo.existe?(grafo, origen) and Grafo.existe?(grafo, destino) do
      buscar_recursivo(grafo, origen, destino, MapSet.new([origen]), [origen], 0)
    else
      []
    end
  end

  #Caso base: cuando llegamos al destino, encontramos una ruta completa
  defp buscar_recursivo(_grafo, actual, destino, _visitadas, camino, distancia)
       when actual == destino do

    [
      %Ruta{
        ciudades: Enum.reverse(camino),
        distancia: distancia
      }
    ]
  end

  #Caso recursivo: exploramos los vecinos de la ciudad actual
  defp buscar_recursivo(grafo, actual, destino, visitadas, camino, distancia) do

    Grafo.vecinos(grafo, actual)
    |> Enum.flat_map(fn {vecino, distancia_conexion} ->

      #Comprueba si la ciudad vecina no ha sido visitada
      if MapSet.member?(visitadas, vecino) do
        []
      else
        buscar_recursivo(grafo, vecino, destino, MapSet.put(visitadas, vecino), [vecino | camino], distancia + distancia_conexion)
      end
    end)
  end

  def lineas_consulta(grafo, origen, destino) do

    encabezado = "=== #{origen} -> #{destino} ==="

    lineas =
      cond do
        not Grafo.existe?(grafo, origen) ->
          [
            encabezado,
            "La ciudad de origen #{origen} no existe en el grafo."
          ]

        not Grafo.existe?(grafo, destino) ->
          [
            encabezado,
            "La ciudad de destino #{destino} no existe en el grafo."
          ]

        true ->
          rutas = buscar_rutas(grafo, origen, destino)
          generar_resultados(rutas)
          |> List.insert_at(0, encabezado)
      end

    Stream.map(lineas, fn linea -> linea end)
  end

  #Genera los resultados cuando existen rutas
  defp generar_resultados([]) do
    [
      "Número de rutas: 0",
      "Sin rutas entre las ciudades."
    ]
  end

  defp generar_resultados(rutas) do

    #Enumera las rutas para mostrarlas en pantalla y archivo
    lineas_rutas =
      rutas
      |> Enum.with_index(1)
      |> Enum.map(fn {ruta, numero} ->
        "Ruta #{numero}: #{Ruta.a_texto(ruta)}"
      end)

    #Busca la cantidad mínima de ciudades visitadas
    minimo_ciudades =
      rutas
      |> Enum.map(&Ruta.num_ciudades/1)
      |> Enum.min()

    #Conserva todas las rutas que tienen esa cantidad mínima
    rutas_mas_cortas =
      Enum.filter(rutas, fn ruta ->
        Ruta.num_ciudades(ruta) == minimo_ciudades
      end)

    #Busca la menor distancia total
    menor_distancia =
      rutas
      |> Enum.map(& &1.distancia)
      |> Enum.min()

    #Conserva las rutas que tienen la menor distancia
    rutas_menor_distancia =
      Enum.filter(rutas, fn ruta ->
        ruta.distancia == menor_distancia
      end)

    texto_mas_cortas =
      Enum.map_join(rutas_mas_cortas, " | ", fn ruta ->
        Enum.join(ruta.ciudades, " -> ")
      end)

    texto_menor_distancia =
      Enum.map_join(rutas_menor_distancia, " | ", fn ruta ->
        "#{Enum.join(ruta.ciudades, " -> ")} (#{formato_distancia(ruta.distancia)} km)"
      end)

    lineas_rutas ++
      [
        "Número de rutas: #{length(rutas)}",
        "Ruta más corta: #{texto_mas_cortas}",
        "Ruta de menor distancia: #{texto_menor_distancia}"
      ]
  end

  #Convierte las distancias a texto para mostrarlas con máximo dos decimales
  defp formato_distancia(numero) when is_integer(numero) do
    Integer.to_string(numero)
  end

  defp formato_distancia(numero) when is_float(numero) do
    redondeado = Float.round(numero, 2)

    if redondeado == Float.round(redondeado) do
      Integer.to_string(trunc(redondeado))
    else
      Float.to_string(redondeado)
    end
  end

  @doc """
  Escribe un Stream de líneas en el archivo indicado.
  Agrega el contenido al final del archivo.
  """
  def escribir(lineas, ruta) do
    File.mkdir_p!(Path.dirname(ruta))

    File.open!(ruta, [:append, :utf8], fn archivo ->
      Enum.each(lineas, fn linea ->
        IO.puts(archivo, linea)
      end)

      IO.puts(archivo, "")
    end)

    :ok
  end
end
