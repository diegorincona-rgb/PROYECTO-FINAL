# Autora: Natalia Garcia

defmodule LectorRutas do
  @moduledoc """
  Módulo que implementa la lectura de archivos de conexiones y consultas.
  """

  @doc """
  Lee las conexiones `origen,destino,distancia`.
  Devuelve `{:ok, entradas}` o `{:error, :archivo_no_existe}`.
  """
  def conexiones(ruta) do
    leer(ruta, fn {texto, numero} -> entrada(numero, texto, Conexion.parse(texto)) end)
  end

  @doc """
  Lee las consultas `origen,destino`.
  Devuelve `{:ok, entradas}` o `{:error, :archivo_no_existe}`.
  """
  def consultas(ruta) do
    leer(ruta, fn {texto, numero} -> entrada(numero, texto, parsear_consulta(texto)) end)
  end

  @doc """
  Separa las entradas válidas de las inválidas. Las entradas válidas son aquellas cuyo resultado es `{:ok, _}`.
  Devuelve una tupla `{validas, invalidas}`.
  """
  def separar(entradas) do
    Enum.split_with(entradas, fn %{resultado: resultado} -> match?({:ok, _}, resultado) end)
  end

  @doc """
  Escribe las entradas inválidas en un archivo de errores.
  Cada línea contiene el número de línea, el texto original y el motivo del error.
  """
  def escribir_errores(invalidas, ruta_archivo) do
    File.mkdir_p!(Path.dirname(ruta_archivo))

    Stream.map(invalidas, fn %{linea: numero, texto: texto, resultado: {:error, motivo}} ->
      "Línea #{numero}: #{texto} -> #{motivo}\n"
    end)
    |> Stream.into(File.stream!(ruta_archivo))
    |> Stream.run()
  end

  # Lee un archivo y aplica la función `transformar` a cada línea útil.
  # Devuelve `{:ok, entradas}` o `{:error, :archivo_no_existe}`.
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

  # Crea un mapa con la información de la línea: número, texto y resultado del parseo.
  defp entrada(numero, texto, resultado) do
    %{linea: numero, texto: texto, resultado: resultado}
  end

  # Devuelve un stream de tuplas `{texto, numero}` con las líneas útiles del archivo.
  # Se ignoran las líneas vacías y los comentarios (líneas que comienzan con #).
  defp lineas_utiles(ruta) do
    File.stream!(ruta)
    |> Stream.map(&String.trim/1)
    |> Stream.with_index(1)
    |> Stream.reject(fn {texto, _numero} ->
      texto == "" or String.starts_with?(texto, "#")
    end)
  end

  # Parsea una línea de consulta `origen,destino`.
  # Devuelve `{:ok, {origen, destino}}` o `{:error, mensaje}`.
  defp parsear_consulta(texto) do
    case String.split(texto, ",") |> Enum.map(&String.trim/1) do
      [origen, destino] when origen != "" and destino != "" -> {:ok, {origen, destino}}
      _ -> {:error, "campos incorrectos (se esperan exactamente origen,destino)"}
    end
  end
end
