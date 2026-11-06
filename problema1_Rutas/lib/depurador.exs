
#Autor: Diego Rincon
# Depuración recursiva de conexiones.
# Restricción del enunciado: este módulo NO usa Enum ni Stream; todo es recursión propia.

defmodule Depurador do
  @moduledoc """
  Depura la lista de conexiones antes de construir el grafo:
    1. descarta una conexión de una ciudad consigo misma,
    2. descarta una conexión repetida (mismo sentido o contrario),
    3. si el mismo par aparece con otra distancia, conserva la primera.
  """

  @doc """
  Recibe las entradas válidas en el orden del archivo. Cada entrada es un mapa:
    %{linea: 28, texto: "Pereira,Armenia,45", conexion: %Conexion{...}}
  Devuelve {conexiones_depuradas, observaciones}.
  """
  def depurar(entradas), do: depurar(entradas, [], [])

  # Caso base: no quedan entradas. Los acumuladores están al revés, se invierten.
  defp depurar([], conservadas, observaciones) do
    {solo_conexiones(conservadas, []), invertir(observaciones, [])}
  end

  # Caso recursivo: se decide sobre la primera entrada y se sigue con el resto.
  defp depurar([entrada | resto], conservadas, observaciones) do
    case decidir(entrada, conservadas) do
      :conservar ->
        depurar(resto, [entrada | conservadas], observaciones)

      {:descartar, motivo} ->
        depurar(resto, conservadas, [formatear(entrada, motivo) | observaciones])
    end
  end

  # Regla 1: la misma variable en origen y destino solo coincide si son iguales.
  defp decidir(%{conexion: %Conexion{origen: ciudad, destino: ciudad}}, _conservadas) do
    {:descartar, "conecta una ciudad consigo misma; se descarta"}
  end

  # Reglas 2, 3 y 4: se busca el par entre las ya conservadas.
  defp decidir(%{conexion: conexion}, conservadas) do
    comparar(conexion, buscar_par(conservadas, conexion))
  end

  # Regla 4: el par no estaba, se conserva.
  defp comparar(_conexion, nil), do: :conservar

  # Regla 2: el par estaba con la misma distancia (45 y 45.0 cuentan como iguales).
  defp comparar(%Conexion{distancia: nueva}, %{linea: l, conexion: %Conexion{distancia: anterior}})
       when nueva == anterior do
    {:descartar, "repetida (línea #{l}); se descarta"}
  end

  # Regla 3: el par estaba con otra distancia, se conserva la primera.
  defp comparar(_conexion, %{linea: l, conexion: %Conexion{distancia: anterior}}) do
    {:descartar,
     "distancia distinta a la de la línea #{l} (#{anterior}); se conserva la de la línea #{l}"}
  end

  # Búsqueda recursiva del par (reemplaza a Enum.find).
  defp buscar_par([], _conexion), do: nil

  defp buscar_par([%{conexion: guardada} = entrada | resto], conexion) do
    if mismo_par?(guardada, conexion), do: entrada, else: buscar_par(resto, conexion)
  end

  # Mismo par, en el mismo sentido o en el contrario.
  defp mismo_par?(%Conexion{origen: a, destino: b}, %Conexion{origen: c, destino: d}) do
    (a == c and b == d) or (a == d and b == c)
  end

  defp formatear(%{linea: linea, texto: texto}, motivo) do
    "Línea #{linea}: #{texto} -> #{motivo}"
  end

  # Saca el %Conexion{} de cada entrada. Como conservadas está al revés,
  # al recorrerla y acumular por la cabeza queda en el orden original.
  defp solo_conexiones([], acumulado), do: acumulado

  defp solo_conexiones([%{conexion: conexion} | resto], acumulado) do
    solo_conexiones(resto, [conexion | acumulado])
  end

  defp invertir([], acumulado), do: acumulado
  defp invertir([x | resto], acumulado), do: invertir(resto, [x | acumulado])

  @doc """
  Escribe depuracion_conexiones.txt línea por línea y muestra lo mismo en pantalla.
  El archivo se crea (o se reemplaza) en cada ejecución, aunque no haya observaciones.
  La ruta la entrega programa_rutas.exs, construida con __DIR__.
  """
  def escribir_reporte(observaciones, ruta) do
    File.mkdir_p!(Path.dirname(ruta))

    File.open!(ruta, [:write, :utf8], fn archivo ->
      escribir_lineas(observaciones, archivo)
    end)

    :ok
  end

  defp escribir_lineas([], _archivo), do: :ok

  defp escribir_lineas([linea | resto], archivo) do
    IO.puts(archivo, linea)
    IO.puts(linea)
    escribir_lineas(resto, archivo)
  end
end
