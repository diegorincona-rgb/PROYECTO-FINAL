# Autora: Natalia Garcia

# Carga los módulos necesarios para el programa principal de N reinas.
Code.require_file("lib/tablero.exs", __DIR__)
Code.require_file("lib/lector_reinas.exs", __DIR__)
Code.require_file("lib/escritor_reinas.exs", __DIR__)
Code.require_file("lib/reinas.exs", __DIR__)
Code.require_file("lib/verificador.exs", __DIR__)
Code.require_file("lib/secuencia.exs", __DIR__)

defmodule ProgramaReinas do
  @moduledoc """
  Programa principal para el problema de las N reinas.
  Lee los tamaños de tablero desde datos/tamanos.txt, escribe todas las soluciones en salida/reinas_n<N>.txt,
  escribe la primera solución de N = 20 en salida/primera_solucion_n20.txt,
  """

  @datos Path.join(__DIR__, "datos")
  @salida Path.join(__DIR__, "salida")

  # Un término de la secuencia solo se acepta si su cálculo tarda menos que esto.
  @limite_ms 10_000

  def main do
    IO.puts("=== Problema 4: N reinas ===\n")
    procesar_tamanos()
    primera_solucion_n20()
    verificar_propuestas()
    escribir_secuencia()
  end

  # Lee los tamaños de tablero desde datos/tamanos.txt, separa los válidos de los inválidos,
  # escribe los inválidos en salida/errores_tamanos.txt y resuelve los válidos,
  # escribiendo todas las soluciones en salida/reinas_n<N>.txt.
  defp procesar_tamanos do
    case LectorReinas.tamanos(Path.join(@datos, "tamanos.txt")) do
      {:error, :archivo_no_existe} ->
        IO.puts("No se encontró datos/tamanos.txt. Se omiten los tamaños.\n")

      {:ok, entradas} ->
        {validos, invalidos} = LectorReinas.separar(entradas)
        LectorReinas.escribir_errores(invalidos, Path.join(@salida, "errores_tamanos.txt"))

        IO.puts(
          "Tamaños inválidos omitidos: #{length(invalidos)} (ver salida/errores_tamanos.txt)\n"
        )

        Enum.each(validos, fn %{resultado: {:ok, n}} -> resolver(n) end)
    end
  end

  # Resuelve el problema de las N reinas para un tamaño de tablero dado,
  # escribiendo todas las soluciones en salida/reinas_n<N>.txt.
  defp resolver(n) do
    IO.puts("=== N = #{n} ===")
    ruta = Path.join(@salida, "reinas_n#{n}.txt")
    total = EscritorReinas.escribir_soluciones(Reinas.soluciones(n), ruta)
    IO.puts("N = #{n}: #{total} soluciones guardadas en salida/reinas_n#{n}.txt\n")
  end

  # Escribe la primera solución para N = 20 en salida/primera_solucion_n20.txt.
  defp primera_solucion_n20 do
    IO.puts("=== Primera solución para N = 20 ===")
    ruta = Path.join(@salida, "primera_solucion_n20.txt")
    EscritorReinas.escribir_primera_solucion(Reinas.soluciones(20), ruta)
    IO.puts("")
  end

  # Verifica las propuestas de solución en datos/propuestas.txt,
  # escribiendo los resultados en salida/verificacion_reinas.txt.
  defp verificar_propuestas do
    IO.puts("=== Verificación de propuestas ===")

    case LectorReinas.propuestas(Path.join(@datos, "propuestas.txt")) do
      {:error, :archivo_no_existe} ->
        IO.puts("No se encontró datos/propuestas.txt. Se omite la verificación.\n")

      {:ok, propuestas} ->
        lineas = Enum.map(propuestas, fn %{texto: texto} -> Verificador.procesar_linea(texto) end)
        Enum.each(lineas, &IO.puts/1)
        EscritorReinas.escribir(lineas, Path.join(@salida, "verificacion_reinas.txt"))
        IO.puts("")
    end
  end

  # Escribe la secuencia de soluciones en salida/secuencia_reinas.csv,
  # deteniéndose al primer N que tarde 10 s o más en calcularse.
  defp escribir_secuencia do
    IO.puts("=== Secuencia de soluciones (se detiene al primer N que tarde 10 s o más) ===")
    ruta = Path.join(@salida, "secuencia_reinas.csv")
    File.mkdir_p!(@salida)

    File.open!(ruta, [:write, :utf8], fn archivo ->
      emitir(archivo, "n;soluciones;tiempo_ms")

      Secuencia.terminos()
      |> Stream.map(&Secuencia.medir/1)
      |> Stream.take_while(fn {_n, _soluciones, tiempo_ms} -> tiempo_ms < @limite_ms end)
      |> Stream.each(fn {n, soluciones, tiempo_ms} ->
        emitir(archivo, "#{n};#{soluciones};#{Float.round(tiempo_ms, 3)}")
      end)
      |> Stream.run()
    end)

    IO.puts("")
  end

  # Emite una línea en el archivo y en la pantalla.
  defp emitir(archivo, linea) do
    IO.write(archivo, linea <> "\n")
    IO.puts(linea)
  end
end

ProgramaReinas.main()
