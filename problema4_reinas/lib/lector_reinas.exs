# Autora: Natalia Garcia

defmodule LectorReinas do
  @moduledoc """
  Módulo que implementa la lectura de archivos de entrada para el problema de las N reinas.
  """

  @doc """
  Función que lee los tamaños de tablero desde un archivo.
  Devuelve {:ok, [mapas]} o {:error, :archivo_no_existe},
  con cada mapa conteniendo el número de línea, el texto original y el resultado del parseo.
  """
  def tamanos(ruta) do
    leer(ruta, fn {texto, numero} ->
      %{linea: numero, texto: texto, resultado: parsear_tamano(texto)}
    end)
  end

  @doc """
  Función que lee las propuestas de solución desde un archivo.
  Devuelve `{:ok, [mapas]}` o `{:error, :archivo_no_existe}`,
  con cada mapa conteniendo el número de línea y el texto original.
  """
  def propuestas(ruta) do
    leer(ruta, fn {texto, numero} ->
      %{linea: numero, texto: texto}
    end)
  end

  # Verifica el archivo una sola vez y aplica la transformación a cada línea útil.
  defp leer(ruta, transformar) do
    if File.regular?(ruta) do
      entradas =
        lineas_utiles(ruta)
        |> Stream.map(transformar)
        |> Enum.to_list()

      {:ok, entradas}
    else
      {:error, :archivo_no_existe}
    end
  end

  # Devuelve un stream de las líneas útiles del archivo, con su número de línea.
  # Se ignoran las líneas vacías y las que comienzan con "#".
  defp lineas_utiles(ruta) do
    File.stream!(ruta)
    |> Stream.map(&String.trim/1)
    |> Stream.with_index(1)
    |> Stream.reject(fn {texto, _numero} ->
      texto == "" or String.starts_with?(texto, "#")
    end)
  end

  # Parsea un texto que representa un tamaño de tablero.
  # Devuelve `{:ok, n}` si es un entero positivo, o `{:error, motivo}` si no lo es.
  defp parsear_tamano(texto) do
    case Integer.parse(texto) do
      {n, ""} when n > 0 -> {:ok, n}
      {_n, ""} -> {:error, "El tamaño debe ser un entero positivo"}
      _ -> {:error, "No es un número entero"}
    end
  end

  @doc """
  Separa las entradas en válidas e inválidas.
  Las entradas válidas son aquellas cuyo resultado es `{:ok, _}`.
  Devuelve una tupla `{validas, invalidas}`.
  """
  def separar(entradas) do
    Enum.split_with(entradas, fn %{resultado: resultado} -> match?({:ok, _}, resultado) end)
  end

  @doc """
  Escribe las entradas inválidas en un archivo de errores.
  Cada línea contiene el número de línea, el texto recortado y el motivo del error.
  """
  def escribir_errores(invalidas, ruta_archivo) do
    File.mkdir_p!(Path.dirname(ruta_archivo))

    Stream.map(invalidas, fn %{linea: numero, texto: texto, resultado: {:error, motivo}} ->
      "Línea #{numero}: #{texto} -> #{motivo}\n"
    end)
    |> Stream.into(File.stream!(ruta_archivo))
    |> Stream.run()
  end
end
