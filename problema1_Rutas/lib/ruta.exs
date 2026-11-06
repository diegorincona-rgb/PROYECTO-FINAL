# Autora: Natalia Garcia
@moduledoc """
Módulo que representa una ruta entre ciudades.
Contiene información sobre las ciudades involucradas y la distancia total de la ruta.
"""
defmodule Ruta do
  defstruct [:ciudades, :distancia]
end
