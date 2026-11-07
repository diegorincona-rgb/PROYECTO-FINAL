#Autor: Carlos Andres

defmodule Secuencia do
  @secuencia_reinas Path.join(__DIR__, "secuencia_reinas.csv")


  # Genera una secuencia infinita: 1, 2, 3, 4...
  def terminos do
    Stream.iterate(1, fn n -> n + 1 end)
  end

  # Calcula las soluciones y mide el tiempo empleado
  def medir(n) do
    {tiempo_microsegundos, cantidad} = #Guarda el tiempo y la cantidad de soluciones
      :timer.tc(fn -> #Inicia la medicion del tiempo mientras se ejecuta la funcion
        Reinas.contar_soluciones(n)
      end)

    tiempo_ms = tiempo_microsegundos / 1000 #Convierte el tiempo de microsegundos a milisegundos

    {n, cantidad, tiempo_ms}
  end

  # Genera el archivo CSV.
  def generar_csv() do
    case File.open(@secuencia_reinas, [:write]) do
      {:ok, archivo} ->
        try do
          IO.puts(archivo, "n;soluciones;tiempo_ms") #Escribe los encabezados de las columnas del csv

          terminos()
          |> Stream.map(fn n -> medir(n) end)
          |> Stream.take_while(fn {_n, _cantidad, tiempo_ms} -> #Comprueba el tiempo de cada calculo
            tiempo_ms < 10_000
          end)
          |> Stream.each(fn {n, cantidad, tiempo_ms} ->
            linea =
              "#{n};#{cantidad};#{Float.round(tiempo_ms, 3)}"

            IO.puts(archivo, linea)
          end)
          |> Stream.run() #Consume el Stream y ejecuta todas las operaciones anteriores.

          :ok
        after
          File.close(archivo)
        end

      {:error, razon} ->
        {:error, razon}
    end
  end
end
