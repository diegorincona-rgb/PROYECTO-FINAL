# Autora: Natalia Garcia

defmodule Ruta do
  @moduledoc """
  Módulo que representa una ruta entre varias ciudades.
  """
  defstruct [:ciudades, :distancia]

  @doc """
  Devuelve el número de ciudades en la ruta.
  """
  def num_ciudades(%Ruta{ciudades: ciudades}), do: length(ciudades)

  @doc """
  Devuelve una representación en texto de la ruta, incluyendo las ciudades y la distancia total.
  """
  def a_texto(%Ruta{ciudades: ciudades, distancia: distancia} = ruta) do
    "#{Enum.join(ciudades, " -> ")} (#{num_ciudades(ruta)} ciudades, #{formato(distancia)} km)"
  end

  # Formatea la distancia para que se muestre de manera legible, redondeando a dos decimales si es necesario.
  defp formato(numero) when is_integer(numero), do: Integer.to_string(numero)

  defp formato(numero) when is_float(numero) do
    redondeado = Float.round(numero, 2)

    if redondeado == Float.round(redondeado) do
      Integer.to_string(trunc(redondeado))
    else
      Float.to_string(redondeado)
    end
  end
end
