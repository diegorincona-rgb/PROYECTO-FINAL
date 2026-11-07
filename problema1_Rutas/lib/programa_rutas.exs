#Autor: Carlos Andres
Code.require_file(Path.join(__DIR__, "conexion.exs"))
Code.require_file(Path.join(__DIR__, "ruta.exs"))
Code.require_file(Path.join(__DIR__, "lector_rutas.exs"))
Code.require_file(Path.join(__DIR__, "grafo.exs"))
Code.require_file(Path.join(__DIR__, "depurador.exs"))
Code.require_file(Path.join(__DIR__, "alcance.exs"))
Code.require_file(Path.join(__DIR__, "escritor_rutas.exs"))

defmodule ProgramaRutas do

  #Archivos de entrada.
  @conexiones Path.join(__DIR__, "../datos/conexiones.csv")
  @consultas Path.join(__DIR__, "../datos/consultas.txt")

  #Archivos de salida.
  @errores_conexiones Path.join(__DIR__, "resultados/errores_conexiones.txt")
  @errores_consultas Path.join(__DIR__, "resultados/errores_consultas.txt")
  @depuracion Path.join(__DIR__, "resultados/depuracion_conexiones.txt")
  @alcance Path.join(__DIR__, "resultados/alcance.txt")
  @rutas Path.join(__DIR__, "resultados/rutas_encontradas.txt")


  def main do

    # Crea la carpeta de resultados si no existe.
    File.mkdir_p!(Path.join(__DIR__, "resultados"))

    # Limpia los archivos antes de comenzar el procesamiento.
    reiniciar_archivos()

    # Lee las conexiones y construye el grafo.
    case preparar_grafo() do

      {:ok, grafo} ->

        # Procesa todas las consultas.
        procesar_consultas(grafo)

        IO.puts("\nProcesamiento terminado.")
        IO.puts("Revisa la carpeta resultados para consultar los archivos.")

      {:error, motivo} ->
        IO.puts("No fue posible preparar el grafo: #{motivo}")
    end
  end

  # Lee las conexiones, separa las inválidas y depura las válidas.
  defp preparar_grafo do

    case LectorRutas.conexiones(@conexiones) do

      {:ok, entradas} ->

        # Separa las conexiones válidas de las que tienen errores.
        {validas, invalidas} = LectorRutas.separar(entradas)

        # Escribe las conexiones incorrectas en el archivo de errores.
        LectorRutas.escribir_errores(invalidas, @errores_conexiones)

        # Convierte las entradas válidas al formato que espera Depurador.
        conexiones_para_depurador =
          Enum.map(validas, fn entrada ->
            {:ok, conexion} = entrada.resultado

            %{
              linea: entrada.linea,
              texto: entrada.texto,
              conexion: conexion
            }
          end)

        # Depura conexiones repetidas, distancias diferentes y ciudades iguales.
        {conexiones_depuradas, observaciones} =
          Depurador.depurar(conexiones_para_depurador)

        # Guarda las observaciones de la depuración.
        Depurador.escribir_reporte(observaciones, @depuracion)

        # Construye el grafo únicamente con las conexiones depuradas.
        grafo = Grafo.construir(conexiones_depuradas)

        {:ok, grafo}

      {:error, _razon} ->
        {:error, "No se encontró el archivo conexiones.csv"}
    end
  end

  # Prepara los archivos que deben comenzar vacíos en cada ejecución.
  defp reiniciar_archivos do
    File.write!(@rutas, "")
    File.write!(@errores_conexiones, "")
    File.write!(@errores_consultas, "")

    Alcance.reiniciar(@alcance)
  end

  # Lee y procesa todas las consultas del archivo.
  defp procesar_consultas(grafo) do

    case LectorRutas.consultas(@consultas) do

      {:ok, entradas} ->

        # Separa las consultas correctas de las mal formadas.
        {validas, invalidas} = LectorRutas.separar(entradas)

        # Guarda los errores de las consultas.
        LectorRutas.escribir_errores(invalidas, @errores_consultas)

        # Procesa cada consulta válida en el orden del archivo.
        Enum.each(validas, fn entrada ->
          {:ok, {origen, destino}} = entrada.resultado

          procesar_consulta(grafo, origen, destino)
        end)

      {:error, _razon} ->
        IO.puts("No se encontró el archivo consultas.txt")
    end
  end

  # Calcula el alcance y después busca las rutas si es posible.
  defp procesar_consulta(grafo, origen, destino) do

    IO.puts("\nProcesando consulta: #{origen} -> #{destino}")

    cond do

      # Comprueba si el origen existe en el grafo.
      not Grafo.existe?(grafo, origen) ->

        mostrar_resultado(
          EscritorRutas.lineas_consulta(grafo, origen, destino)
        )

      # Comprueba si el destino existe en el grafo.
      not Grafo.existe?(grafo, destino) ->

        mostrar_resultado(
          EscritorRutas.lineas_consulta(grafo, origen, destino)
        )

      true ->

        # Calcula los conjuntos de ciudades alcanzables.
        pasos = Alcance.hasta_estabilizar(grafo, origen)

        # Genera y guarda las líneas del alcance.
        lineas_alcance = Alcance.lineas(origen, pasos)
        Alcance.escribir(lineas_alcance, @alcance)

        # Comprueba si el destino está en el conjunto final.
        if Alcance.alcanzable?(pasos, destino) do

          # Solo si es alcanzable se ejecuta la búsqueda recursiva.
          mostrar_resultado(
            EscritorRutas.lineas_consulta(grafo, origen, destino)
          )

        else

          # Si no es alcanzable, no se buscan rutas.
          lineas = [
            "=== #{origen} -> #{destino} ===",
            "Sin rutas: el destino no es alcanzable desde el origen."
          ]

          mostrar_resultado(lineas)
        end
    end
  end

  # Muestra los resultados en pantalla y los guarda en el archivo.
  defp mostrar_resultado(lineas) do

    # Convierte el Stream en una lista para poder recorrerlo dos veces.
    lineas = Enum.to_list(lineas)

    # Muestra los resultados en pantalla.
    Enum.each(lineas, &IO.puts/1)

    # Guarda los resultados en el archivo.
    EscritorRutas.escribir(lineas, @rutas)
  end
end
ProgramaRutas.main()
