# Autora: Natalia Garcia

defmodule Conexion do
  @moduledoc """
  Módulo que representa una conexión entre dos ciudades.
  """

  # Estructura que contiene el origen, destino y distancia de la conexión.
  defstruct [:origen, :destino, :distancia]

  @doc """
  Parsea una línea de texto que representa una conexión entre dos ciudades.
  La línea debe tener el formato: "origen,destino,distancia".
  Devuelve un `{:ok, %Conexion{}}` si la línea es válida, o un `{:error, mensaje}` si hay algún error.
  """
  def parse(linea) do
    campos =
      linea
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    with {:ok, {origen, destino, texto}} <- extraer_campos(campos),
         {:ok, distancia} <- convertir_distancia(texto) do
      {:ok, %Conexion{origen: origen, destino: destino, distancia: distancia}}
    end
  end

  # Extrae los campos de la lista y verifica que no estén vacíos.
  defp extraer_campos([origen, destino, texto])
       when origen != "" and destino != "" and texto != "" do
    {:ok, {origen, destino, texto}}
  end

  defp extraer_campos(_), do: {:error, "Campos incorrectos (se esperan origen,destino,distancia)"}

  # Acepta enteros ("45") y decimales ("45.5").
  defp convertir_distancia(texto) do
    case Integer.parse(texto) do
      {numero, ""} ->
        validar_no_negativa(numero)

      _ ->
        case Float.parse(texto) do
          {numero, ""} -> validar_no_negativa(numero)
          _ -> {:error, "Distancia no numérica (\"#{texto}\")"}
        end
    end
  end

  defp validar_no_negativa(numero) when numero >= 0, do: {:ok, numero}

  defp validar_no_negativa(numero) when numero < 0,
    do: {:error, "La distancia no puede ser negativa (#{numero})"}
end
