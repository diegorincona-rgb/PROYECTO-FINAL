# Autora: Natalia Garcia

defmodule EscritorReinas do
  @moduledoc """
  Módulo que implementa la escritura de archivos de salida para el problema de las N reinas.
  """

  @doc """
  Escribe una colección de líneas en un archivo, creando los directorios necesarios.
  Cada línea se escribe con un salto de línea al final.
  """
  def escribir(lineas, ruta) do
    File.mkdir_p!(Path.dirname(ruta))

    Stream.map(lineas, fn linea -> linea <> "\n" end)
    |> Stream.into(File.stream!(ruta))
    |> Stream.run()
  end

  @doc """
  Escribe las soluciones en un archivo, con un encabezado y un total al final.
  Cada solución se escribe con un encabezado "Solución N:" y luego las líneas del tablero.
  Si `en_pantalla` es `true` (valor por defecto), también imprime las líneas en la pantalla.
  Devuelve el total de soluciones escritas.
  """
  def escribir_soluciones(soluciones, ruta, en_pantalla \\ true) do
    File.mkdir_p!(Path.dirname(ruta))

    File.open!(ruta, [:write, :utf8], fn archivo ->
      total =
        Enum.reduce(soluciones, 0, fn solucion, contador ->
          numero = contador + 1
          emitir(archivo, "Solución #{numero}:", en_pantalla)
          Enum.each(Tablero.lineas(solucion), fn linea -> emitir(archivo, linea, en_pantalla) end)
          emitir(archivo, "", en_pantalla)
          numero
        end)

      emitir(archivo, "Total de soluciones: #{total}", en_pantalla)
      total
    end)
  end

  @doc """
  Escribe la primera solución en un archivo, con un encabezado.
  Si `en_pantalla` es `true` (valor por defecto), también imprime las líneas en la pantalla.
  Devuelve `{:ok, solucion}` si hay al menos una solución, o `{:error, :sin_solucion}` si no hay soluciones.
  """
  def escribir_primera_solucion(soluciones, ruta, en_pantalla \\ true) do
    case Enum.take(soluciones, 1) do
      [solucion] ->
        lineas = ["Primera solución (N = #{length(solucion)}):" | Tablero.lineas(solucion)]
        escribir(lineas, ruta)
        if en_pantalla, do: Enum.each(lineas, &IO.puts/1)
        {:ok, solucion}

      [] ->
        escribir(["No se encontró ninguna solución"], ruta)
        {:error, :sin_solucion}
    end
  end

  # Emite una línea en el archivo y opcionalmente en la pantalla.
  defp emitir(archivo, linea, en_pantalla) do
    IO.write(archivo, linea <> "\n")
    if en_pantalla, do: IO.puts(linea)
  end
end
