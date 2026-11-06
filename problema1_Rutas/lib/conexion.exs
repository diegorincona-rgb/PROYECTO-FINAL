# Autora: Natalia Garcia
@moduledoc """
Módulo que representa una conexión entre ciudades.
Contiene información sobre las ciudades de origen y destino, y la distancia entre ellas.
"""
defmodule Conexion do
  defstruct [:origen, :destino, :distancia]
end
