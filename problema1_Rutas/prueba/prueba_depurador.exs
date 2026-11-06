# Autor: Diego Rincon

base = Path.expand("../../problema1_Rutas", __DIR__)
Code.require_file(Path.join(base, "lib/conexion.exs"))
Code.require_file(Path.join(base, "lib/depurador.exs"))

defmodule LecturaPrueba do
  # Imita lo que hará LectorRutas: streams, numerando ANTES de filtrar.
  def leer(ruta) do
    resultados =
      ruta
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.with_index(1)
      |> Stream.reject(fn {t, _n} -> t == "" or String.starts_with?(t, "#") end)
      |> Stream.map(fn {t, n} -> {n, t, Conexion.parse(t)} end)
      |> Enum.to_list()

    errores = for {n, t, {:error, m}} <- resultados, do: "Línea #{n}: #{t} -> #{m}"
    entradas = for {n, t, {:ok, c}} <- resultados, do: %{linea: n, texto: t, conexion: c}
    {entradas, errores}
  end
end

salida = Path.join(__DIR__, "salida_prueba")



IO.puts("=== PARTE 1: archivo del enunciado ===\n")

{entradas, _errores} = LecturaPrueba.leer(Path.join(__DIR__, "datos_prueba/conexiones_enunciado.csv"))
{conexiones, observaciones} = Depurador.depurar(entradas)
Depurador.escribir_reporte(observaciones, Path.join(salida, "depuracion_enunciado.txt"))

esperado = [
  "Línea 6: Pereira,Armenia,45 -> repetida (línea 2); se descarta",
  "Línea 7: Manizales,Manizales,0 -> conecta una ciudad consigo misma; se descarta",
  "Línea 8: Cartago,Pereira,30 -> distancia distinta a la de la línea 5 (25); se conserva la de la línea 5"
]

IO.puts("\nConexiones conservadas: #{length(conexiones)} (esperado 4)")
IO.puts("Observaciones: " <> if(observaciones == esperado, do: "OK", else: "DIFERENTES"))




IO.puts("\n=== PARTE 2: conexiones.csv de Persona A ===\n")

{entradas, errores} = LecturaPrueba.leer(Path.join(base, "datos/conexiones.csv"))

IO.puts("--- Mal formadas (#{length(errores)}, esperado 6) ---")
Enum.each(errores, &IO.puts/1)

IO.puts("\n--- Depuración ---")
{conexiones, observaciones} = Depurador.depurar(entradas)
Depurador.escribir_reporte(observaciones, Path.join(salida, "depuracion_conexiones_csv.txt"))

IO.puts("\nObservaciones: #{length(observaciones)} (esperado 6)")
IO.puts("Conexiones conservadas: #{length(conexiones)} (esperado 13)")
