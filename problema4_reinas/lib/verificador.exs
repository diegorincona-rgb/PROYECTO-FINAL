# Autor Diego Rincon


defmodule Verificador do
  @moduledoc """
  Un tablero es una lista de columnas: el valor en la posición i es la columna
  de la reina de la fila i, y N es la cantidad de valores.
  """

  @doc """
  Recibe el texto de una propuesta (por ejemplo "0 2 1 3") y devuelve la línea
  de verificacion_reinas.txt: "0 2 1 3 -> inválida: ...".
  """
  def procesar_linea(texto) do
    texto = String.trim(texto)

    case a_enteros(String.split(texto), []) do
      {:ok, []} ->
        "#{texto} -> inválida: formato inválido (la línea no tiene valores)"

      {:ok, columnas} ->
        "#{texto} -> " <> describir(verificar(columnas))

      {:error, token} ->
        "#{texto} -> inválida: formato inválido (\"#{token}\" no es un entero)"
    end
  end

  @doc "Devuelve :válida o {:inválida, motivos}."
  def verificar(columnas) do
    n = length(columnas)

    motivos =
      fuera_de_rango(columnas, n) ++ ataques(reinas_validas(columnas, 0, n))

    case motivos do
      [] -> :válida
      _ -> {:inválida, motivos}
    end
  end

  # ---------- Conversión de texto a enteros (sin lanzar excepciones) ----------

  defp a_enteros([], acumulado), do: {:ok, invertir(acumulado, [])}

  defp a_enteros([token | resto], acumulado) do
    case Integer.parse(token) do
      {numero, ""} -> a_enteros(resto, [numero | acumulado])
      _ -> {:error, token}
    end
  end

  defp invertir([], acumulado), do: acumulado
  defp invertir([x | resto], acumulado), do: invertir(resto, [x | acumulado])



  # ---------- Columnas fuera del tablero ----------

  # Una columna está fuera si es menor que 0 o mayor o igual que n.
  defp fuera_de_rango([], _n), do: []

  defp fuera_de_rango([columna | resto], n) do
    siguientes = fuera_de_rango(resto, n)

    if columna < 0 or columna >= n do
      ["la columna #{columna} está fuera de un tablero de #{n} × #{n}" | siguientes]
    else
      siguientes
    end
  end


  # Reinas {fila, columna} que sí están dentro del tablero. Las otras no se comparan.
  defp reinas_validas([], _fila, _n), do: []

  defp reinas_validas([columna | resto], fila, n) do
    siguientes = reinas_validas(resto, fila + 1, n)

    if columna >= 0 and columna < n do
      [{fila, columna} | siguientes]
    else
      siguientes
    end
  end


  # ---------- Pares de reinas que se atacan ----------

  # Cada reina se compara con todas las de las filas siguientes.
  defp ataques([]), do: []
  defp ataques([reina | resto]), do: contra_siguientes(reina, resto) ++ ataques(resto)

  defp contra_siguientes(_reina, []), do: []

  defp contra_siguientes({f1, c1} = reina, [{f2, c2} | resto]) do
    siguientes = contra_siguientes(reina, resto)

    cond do
      c1 == c2 ->
        ["reinas {#{f1},#{c1}} y {#{f2},#{c2}} en la misma columna" | siguientes]

      abs(c1 - c2) == f2 - f1 ->
        ["reinas {#{f1},#{c1}} y {#{f2},#{c2}} en la misma diagonal" | siguientes]

      true ->
        siguientes
    end
  end

  
  # ---------- Texto del resultado ----------

  defp describir(:válida), do: "válida"
  defp describir({:inválida, motivos}), do: "inválida: " <> unir(motivos)

  defp unir([motivo]), do: motivo
  defp unir([motivo | resto]), do: motivo <> "; " <> unir(resto)
end
