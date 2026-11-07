# Autor: Diego Rincon

base = Path.expand("../../problema1_Rutas", __DIR__)
Code.require_file(Path.join(base, "lib/alcance.exs"))

salida = Path.join(__DIR__, "salida_prueba")

# Arma un grafo %{ciudad => [{vecino, distancia}]} con las conexiones en ambos sentidos.
construir = fn conexiones ->
  Enum.reduce(conexiones, %{}, fn {a, b, km}, g ->
    g
    |> Map.update(a, [{b, km}], &[{b, km} | &1])
    |> Map.update(b, [{a, km}], &[{a, km} | &1])
  end)
end


IO.puts("=== PARTE 1: ejemplo del enunciado ===\n")

grafo_enunciado =
  construir.([
    {"Armenia", "Pereira", 45},
    {"Pereira", "Manizales", 52},
    {"Armenia", "Cartago", 60},
    {"Cartago", "Pereira", 25}
  ])

ruta1 = Path.join(salida, "alcance_enunciado.txt")
Alcance.reiniciar(ruta1)
pasos = Alcance.hasta_estabilizar(grafo_enunciado, "Armenia")
Alcance.escribir(Alcance.lineas("Armenia", pasos), ruta1)
IO.puts("Manizales alcanzable desde Armenia: #{Alcance.alcanzable?(pasos, "Manizales")} (esperado true)")

# ---------- PARTE 2: cuántos pasos se calculan de verdad (evaluación perezosa) ----------
IO.puts("\n=== PARTE 2: pasos que se calculan ===\n")

grafo_enunciado
|> Alcance.pasos("Armenia")
|> Stream.with_index()
|> Stream.each(fn {_paso, n} -> IO.puts("calculando paso #{n}") end)
|> Stream.map(fn {paso, _n} -> paso end)
|> Alcance.estabilizar()
|> length()
|> then(&IO.puts("pasos devueltos: #{&1} (esperado 3)"))



IO.puts("\n=== PARTE 3: conexiones.csv depurado ===\n")

grafo_csv =
  construir.([
    {"Armenia", "Pereira", 45},
    {"Pereira", "Manizales", 52},
    {"Armenia", "Cartago", 60},
    {"Cartago", "Pereira", 25},
    {"Armenia", "Calarcá", 12},
    {"Calarcá", "Montenegro", 18},
    {"Montenegro", "Pereira", 50},
    {"Armenia", "Manizales", 130},
    {"Manizales", "Santa Rosa", 35},
    {"Pereira", "Santa Rosa", 20},
    {"Montenegro", "Quimbaya", 14.5},
    {"Quimbaya", "Pereira", 38.5},
    {"Leticia", "Puerto Nariño", 75}
  ])

ruta3 = Path.join(salida, "alcance_csv.txt")
Alcance.reiniciar(ruta3)

pasos_armenia = Alcance.hasta_estabilizar(grafo_csv, "Armenia")
Alcance.escribir(Alcance.lineas("Armenia", pasos_armenia), ruta3)

pasos_leticia = Alcance.hasta_estabilizar(grafo_csv, "Leticia")
Alcance.escribir(Alcance.lineas("Leticia", pasos_leticia), ruta3)

IO.puts("Manizales desde Armenia: #{Alcance.alcanzable?(pasos_armenia, "Manizales")} (esperado true)")
IO.puts("Leticia desde Armenia: #{Alcance.alcanzable?(pasos_armenia, "Leticia")} (esperado false = sin rutas)")
