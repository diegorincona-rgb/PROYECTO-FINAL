#Autor Diego rincon

base = Path.expand("..", __DIR__)

for archivo <- ~w(tablero verificador lector_reinas escritor_reinas) do
  Code.require_file(Path.join(base, "lib/#{archivo}.exs"))
end

# ---------- PARTE 1: las 11 propuestas de propuestas.txt ----------
IO.puts("=== PARTE 1: resultado de cada propuesta ===\n")

casos = [
  {"1 3 0 2", "1 3 0 2 -> válida"},
  {"0 2 1 3",
   "0 2 1 3 -> inválida: reinas {0,0} y {3,3} en la misma diagonal; reinas {1,2} y {2,1} en la misma diagonal"},
  {"1 3 0 0", "1 3 0 0 -> inválida: reinas {2,0} y {3,0} en la misma columna"},
  {"2 4 1", "2 4 1 -> inválida: la columna 4 está fuera de un tablero de 3 × 3"},
  {"2 0 3 1", "2 0 3 1 -> válida"},
  {"0 0 0",
   "0 0 0 -> inválida: reinas {0,0} y {1,0} en la misma columna; reinas {0,0} y {2,0} en la misma columna; reinas {1,0} y {2,0} en la misma columna"},
  {"0 0 5",
   "0 0 5 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; reinas {0,0} y {1,0} en la misma columna"},
  {"5 7 1",
   "5 7 1 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; la columna 7 está fuera de un tablero de 3 × 3"},
  {"-1 2 0 3", "-1 2 0 3 -> inválida: la columna -1 está fuera de un tablero de 4 × 4"},
  {"0", "0 -> válida"},
  {"a b c", "a b c -> inválida: formato inválido (\"a\" no es un entero)"}
]

resultados =
  Enum.map(casos, fn {entrada, esperado} ->
    obtenido = Verificador.procesar_linea(entrada)
    IO.puts(obtenido)
    IO.puts("   " <> if(obtenido == esperado, do: "OK", else: "DIFERENTE"))
    obtenido == esperado
  end)

IO.puts("\nCasos correctos: #{Enum.count(resultados, & &1)} de #{length(casos)}")

# ---------- PARTE 2: integración con LectorReinas y EscritorReinas ----------
IO.puts("\n=== PARTE 2: propuestas.txt -> archivo ===\n")

ruta = Path.join(base, "datos/propuestas.txt")
salida = Path.join(__DIR__, "salida_prueba/verificacion_prueba.txt")

case LectorReinas.propuestas(ruta) do
  {:ok, entradas} ->
    entradas
    |> Stream.map(fn %{texto: texto} -> Verificador.procesar_linea(texto) end)
    |> Stream.each(&IO.puts/1)
    |> EscritorReinas.escribir(salida)

    IO.puts("\nArchivo generado: #{salida}")

  {:error, :archivo_no_existe} ->
    IO.puts(:standard_error, "Error: no existe el archivo #{ruta}")
end
