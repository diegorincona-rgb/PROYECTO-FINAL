#Autor: Carlos Andres

defmodule Secuencia do
  @secuencia_reinas Path.join(__DIR__, "secuencia_reinas.csv")


  # Genera una secuencia infinita: 1, 2, 3, 4...
  def terminos do
    Stream.iterate(1, fn n -> n + 1 end)
  end

  # Calcula las soluciones y mide el tiempo empleado.
  # Devuelve: {n, cantidad_de_soluciones, tiempo_en_ms}
  def medir(n) do
    {tiempo_microsegundos, cantidad} =
      :timer.tc(fn ->
        Reinas.contar_soluciones(n)
      end)

    tiempo_ms = tiempo_microsegundos / 1000

    {n, cantidad, tiempo_ms}
  end

  # Genera el archivo CSV.
  def generar_csv() do
    {:ok, archivo} = File.open(@secuencia_reinas, [:write, :utf8])

    try do
      IO.puts(archivo, "n;soluciones;tiempo_ms")

      terminos()
      |> Enum.reduce_while(:ok, fn n, _acumulado ->
        {n, cantidad, tiempo_ms} = medir(n)

        if tiempo_ms < 10_000 do
          linea =
            "#{n};#{cantidad};#{Float.round(tiempo_ms, 3)}"

          IO.puts(archivo, linea)

          {:cont, :ok}
        else
          {:error, :ok}
        end
      end)

    after
      File.close(archivo)
    end

    :ok
  end
end
