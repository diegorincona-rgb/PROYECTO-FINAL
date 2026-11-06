# Autora: Natalia Garcia

defmodule Tablero do
  @moduledoc """
  Módulo que representa un tablero de ajedrez para el problema de las N reinas.
  """

  @doc """
  Devuelve una lista de strings que representa el tablero con las reinas colocadas.
  Cada string representa una fila del tablero, donde "Q" indica la posición de una reina
  """
  def lineas(solucion) do
    n = length(solucion)

    for columna <- solucion do
      Enum.map_join(0..(n - 1)//1, " ", fn c -> if c == columna, do: "Q", else: "." end)
    end
  end
end
