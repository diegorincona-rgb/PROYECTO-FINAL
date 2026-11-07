Repositorio, README y .gitignore (DIEGO RINCON, NATALIA GARCIA, CARLOS RUIZ)

Paso 1: verificar lo que ya existe
Comprobación	Cómo
El repositorio existe en GitHub	Abre la URL en el navegador
Es público o está compartido con el docente	GitHub > Settings > General > Danger Zone muestra la visibilidad. Si es privado, invita al docente como colaborador
NATALIA y CARLOS pueden hacer push	Settings > Collaborators. Deben aparecer los tres
Tu identidad de Git es correcta	Ejecuta en la terminal el bloque de abajo

git config --global user.name "Diego rincón"
git config --global user.email " diego.rincona@uqvirtual.edu.co"
git config --global pull.rebase true
Si el correo no coincide con el de tu cuenta de GitHub, tus commits no aparecerán a tu nombre y la evidencia de reparto se pierde.

Paso 2: invitar a NATALIA y CARLOS  (solo el dueño del repositorio puede)
1.	En GitHub, abre el repositorio.
2.	Settings > Collaborators (o Collaborators and teams).
3.	Add people.
4.	Se envía a los correos de Natalia (ngarciah_1@uqvirtual.edu.co), y de Carlos (carlosa.ruiza@uqvirtual.edu.co)
5.	Cada una recibe un correo y debe aceptar la invitación. Sin eso no pueden hacer push.
Paso 3: .gitignore
En VS Code, clic derecho en la raíz de PROYECTO FINAL, New File, nómbralo .gitignore y pega:


# Compilados de Elixir (no se usan, pero por si aparece alguno suelto)
ebin/
*.beam
_build/
deps/
erl_crash.dump
.elixir_ls/

# Salidas de ensayo de las pruebas
**/salida_prueba/

# Sistema operativo
.DS_Store
Thumbs.db
Paso 4: README.md
Crea README.md en la raíz y pega esto. Completa lo que está entre corchetes.
markdown
# Parcial 2 - Programación III

Problema 1 (Rutas entre ciudades) y Problema 4 (N reinas), en Elixir.


# Integrantes

| Integrante | Rol en la guía | Piezas | Carga |
|---|---|---|---|
| Natalia | Persona A | P1-a, P1-c, P4-b | 2 + 3 + 1 = 6 |
| Carlos | Persona B | P4-a, P4-d, P1-e | 3 + 2 + 1 = 6 |
| Diego | Persona C | P1-b, P1-d, P4-c, Doc | 2 + 2 + 1 + 1 = 6 |

## Reparto de piezas

| Pieza | Descripción | Peso | Responsable |
|---|---|---|---|
| P1-a | Structs, `Conexion.parse/1`, lectura perezosa, `errores_conexiones.txt`, lectura de consultas, archivo inexistente | 2 | Natalia |
| P1-b | Depuración recursiva de conexiones y `depuracion_conexiones.txt` | 2 | Diego |
| P1-c | Grafo, búsqueda recursiva de rutas, más corta y de menor distancia | 3 | Natalia |
| P1-d | Stream infinito de alcanzables, estabilización, `alcance.txt` | 2 | Diego |
| P1-e | Main del problema 1 y `rutas_encontradas.txt` | 1 | Carlos |
| P4-a | Búsqueda recursiva de N reinas con Stream y verificación de cada reina | 3 | Carlos |
| P4-b | Lectura de `tamanos.txt`, errores, `reinas_n<N>.txt`, primera solución N=20 y main del problema 4 | 1 | Natalia |
| P4-c | Validación recursiva de `propuestas.txt` y `verificacion_reinas.txt` | 1 | Diego |
| P4-d | Stream infinito de N, `secuencia_reinas.csv`, comparación con OEIS A000170 | 2 | Carlos |
| Doc | README, ensamblado del PDF, consolidación de la reflexión de IA | 1 | Diego | |

## Requisitos

- Elixir 1.20 o superior (el proyecto se probó con 1.20.4).
- todos los archivos son scripts `.exs`.

## Cómo ejecutar

Desde la carpeta raíz del repositorio:

```
elixir problema1_Rutas/programa_rutas.exs
elixir problema4_reinas/programa_reinas.exs
```

Las rutas se construyen con `__DIR__`, así que los comandos funcionan desde cualquier carpeta. Las salidas se crean en la carpeta `salida/` de cada problema y se reemplazan en cada ejecución.

En PowerShell las barras `\` también funcionan.

## Estructura

```
PROYECTO FINAL/
├── problema1_Rutas/
│   ├── datos/
│   │   ├── conexiones.csv
│   │   └── consultas.txt
│   ├── lib/
│   │   ├── alcance.exs
│   │   ├── buscador.exs
│   │   ├── conexion.exs
│   │   ├── depurador.exs
│   │   ├── grafo.exs
│   │   ├── lector_rutas.exs
│   │   └── ruta.exs
│   └── prueba/
│       ├── datos_prueba/
│       │   └── conexiones_enunciado.csv
│       ├── salida_prueba/
│       │   ├── alcance_csv.txt
│       │   ├── alcance_enunciado.txt
│       │   ├── depuracion_conexiones_c...
│       │   └── depuracion_enunciado.txt
│       ├── prueba_alcance.exs
│       └── prueba_depurador.exs
│
├── problema4_reinas/
│   ├── datos/
│   │   ├── propuestas.txt
│   │   └── tamanos.txt
│   ├── lib/
│   │   ├── escritor_reinas.exs
│   │   ├── lector_reinas.exs
│   │   ├── reinas.exs
│   │   ├── secuencia.exs
│   │   ├── tablero.exs
│   │   └── verificador.exs
│   ├── prueba/
│   │   ├── salida_prueba/
│   │   └── prueba_verificador.exs
│   ├── salida/
│   │   ├── errores_tamanos.txt
│   │   ├── primera_solucion_n20.txt
│   │   ├── reinas_n1.txt
│   │   ├── reinas_n2.txt
│   │   ├── reinas_n4.txt
│   │   ├── reinas_n5.txt
│   │   ├── reinas_n6.txt
│   │   ├── reinas_n8.txt
│   │   ├── secuencia_reinas.csv
│   │   └── verificacion_reinas.txt
│   └── programa_reinas.exs
│
├── .gitignore
└── README.md

## Problema 1: Rutas entre ciudades

### Módulos

| Orden | Módulo | Autor | Pieza | Función | Funciones principales |
|---|---|---|---|---|---|
| 1 | `conexion.exs` | Natalia | P1-a | Struct `%Conexion{}` y lectura de una línea | `parse/1` |
| 2 | `ruta.exs` | Natalia | P1-c | Struct `%Ruta{}` y formato de texto | `num_ciudades/1`, `a_texto/1` |
| 3 | `lector_rutas.exs` | Natalia | P1-a | Lectura perezosa de conexiones y consultas | `conexiones/1`, `consultas/1` |
| 4 | `depurador.exs` | Diego | P1-b | Depuración recursiva (sin `Enum` ni `Stream`) | `depurar/1` |
| 5 | `grafo.exs` | Natalia | P1-c | Construcción del grafo | `construir/1`, `existe?/2`, `vecinos/2` |
| 6 | `alcance.exs` | Diego | P1-d | Stream infinito de ciudades alcanzables | `pasos/2`, `hasta_estabilizar/2`, `lineas/2` |
| 7 | `buscador.exs` | Natalia | P1-c | Búsqueda recursiva de rutas | `todas_las_rutas/3`, `mas_cortas/1`, `menor_distancia/1` |
| 8 | `escritor_rutas.exs` | Carlos | P1-e | Salida de rutas en pantalla y archivo | `lineas_consulta/3`, `escribir/2` |
| 9 | `programa_rutas.exs` | Carlos | P1-e | Programa principal que coordina todo | `main/0` |

### Salidas

Todas se crean en `problema1_Rutas/salida/` y se reemplazan en cada ejecución.

| Orden | Archivo | Qué contiene | Lo genera | Pieza |
|---|---|---|---|---|
| 1 | `errores_conexiones.txt` | Líneas mal formadas de `conexiones.csv`: número de línea, contenido y motivo | Natalia | P1-a |
| 2 | `depuracion_conexiones.txt` | Conexiones descartadas (repetidas, de una ciudad consigo misma, con distancia distinta): número de línea, contenido y motivo | Diego | P1-b |
| 3 | `alcance.txt` | Pasos de ciudades alcanzables por consulta, hasta que el conjunto se estabiliza | Diego | P1-d |
| 4 | `rutas_encontradas.txt` | Rutas de cada consulta con número de ciudades y distancia, total de rutas, ruta más corta y ruta de menor distancia | Carlos | P1-e |### Flujo de ejecución

1. Se verifica que existan `conexiones.csv` y `consultas.txt`.
2. Se leen las conexiones de forma perezosa; las mal formadas van a `errores_conexiones.txt`.
3. Se depuran las conexiones válidas y se reportan en `depuracion_conexiones.txt`.
4. Se construye el grafo con las conexiones depuradas.
5. Para cada consulta se calcula el alcance (`alcance.txt`); si el destino no es alcanzable, se reporta "sin rutas".
6. Si es alcanzable, se buscan todas las rutas y se escriben en `rutas_encontradas.txt`.
Salidas: `errores_conexiones.txt`, `depuracion_conexiones.txt`, `alcance.txt`, `rutas_encontradas.txt`.

## Problema 4: N reinas

| Módulo | Autor | Función |
|---|---|---|
| `reinas.exs` | B | Búsqueda recursiva que devuelve un Stream |
| `tablero.exs` | A | Formato del tablero |
| `lector_reinas.exs` | A | Lectura de `tamanos.txt` y `propuestas.txt` |
| `escritor_reinas.exs` | A | Escritura de soluciones |
| `verificador.exs` | C | Verificación recursiva (sin `Enum` ni `Stream`) |
| `secuencia.exs` | B | Stream infinito de N con tiempos |

Salidas: `errores_tamanos.txt`, `reinas_n<N>.txt`, `primera_solucion_n20.txt`, `verificacion_reinas.txt`, `secuencia_reinas.csv`.

## Pruebas

Cada pieza de Diego tiene un script de prueba. Se ejecutan desde la raíz del repositorio:

```
elixir problema1_Rutas/prueba/prueba_depurador.exs
elixir problema1_Rutas/prueba/prueba_alcance.exs
elixir problema4_reinas/prueba/prueba_verificador.exs
```

| Script | Pieza | Qué prueba | Resultado esperado |
|---|---|---|---|
| `prueba_depurador.exs` | P1-b | Depuración de las conexiones del enunciado y de un archivo con líneas mal formadas y repetidas | Quedan las líneas 2 a 5; observaciones 6 de 6; conexiones conservadas 13 de 13 |
| `prueba_alcance.exs` | P1-d | Pasos de alcance desde Armenia y qué pasos calcula realmente el Stream | Pasos 0, 1 y 2; se calcula el paso 3 solo para comparar; `pasos devueltos: 3` |
| `prueba_verificador.exs` | P4-c | Verificación de tableros propuestos: válidos, con diagonales, misma columna, fuera de rango y con texto | `Casos correctos: 11 de 11` |

Los resultados de cada prueba se escriben en `salida_prueba/`, una carpeta que no se sube al repositorio (está en `.gitignore`).```

Escriben sus resultados en `salida_prueba/`, que no se sube al repositorio.

## Decisiones de diseño

- Las ciudades se comparan sensibles a mayúsculas (`Armenia` y `armenia` son distintas), después de aplicar `trim`.
- Los números de línea empiezan en 1 y cuentan comentarios y líneas vacías: se numera antes de filtrar.
- Una propuesta de reinas con texto no numérico se reporta como `formato inválido`, sin lanzar excepción.
- [Empate en distancia mínima: decidir y anotar.]
- [Consulta con origen igual a destino: decidir y anotar.]

## Uso de inteligencia artificial

Ver `docs/reflexion_ia.md`.
Hay tres cosas que ajustar:
1.	programa_rutas.exs todavía no existe (es de B). El README ya lo menciona; asegúrate de que cuando lo suba tenga ese nombre.
2.	Si el equipo renombra problema1_Rutas a minúscula, cambia las rutas en el README.
3.	Las dos decisiones entre corchetes las deben acordar A y B.
Paso 5: carpeta docs/ y plantillas
Crea en la raíz docs/persona_c/ con tres archivos.
docs/persona_c/bitacora_ia.md
markdown
# Bitácora de IA - Diego (Persona C)

**Herramienta usada:** Claude (Anthropic), en el chat web.
**Piezas:** P1-b (depurador), P1-d (alcance), P4-c (verificador) y Doc (repositorio, README, PDF).

## Resumen

| # | Tema | Pieza | ¿Recurso distinto a clase? |
|---|---|---|---|
| 1 | Reparto de trabajo y guía de equipo | Doc | No |
| 2 | Depurador recursivo con acumuladores | P1-b | No |
| 3 | `Stream.iterate` y `Stream.transform` para el alcance | P1-d | Sí: `Stream.transform/3` |
| 4 | Verificador: columnas fuera de rango y diagonales | P4-c | No |
| 5 | Error de rutas al ejecutar los scripts | Pruebas | Sí: `__DIR__` y `Code.require_file` |
| 6 | Repositorio, README y `.gitignore` | Doc | No |
| 7 | Pruebas de escritorio y árboles de llamadas | P1-b, P1-d, P4-c | No |

---

## Consulta 1: Reparto de trabajo
- **Qué pedimos:** ayuda para repartir los dos problemas entre tres personas con carga equilibrada.
- **Qué respondió la IA:** la guía de equipo, con piezas con peso (3 pesada, 2 media, 1 liviana), archivos por dueño, contrato de firmas y cronograma.
- **Qué hice con eso:** el equipo la adoptó. Lo realizo mi compañera Natalia donde repartio y se genero una totalidad en puntos repartidos y que su total dan 6 puntos.
- **Recurso distinto a lo visto en clase:** ninguno.
- **Qué aprendimos:** que definir las firmas de las funciones el primer día permite programar sin esperar a los demás, que podemos ir adelantando trabajos y dado al repositorio podemos organizarnos para dar un mejor orden y modificación frente al parcial 2

## Consulta 2: Depurador recursivo
- **Qué pedimos:** cómo depurar las conexiones con recursión, sin `Enum` ni `Stream`.
- **Qué respondió la IA:** una función con tres argumentos (pendientes, conservadas, observaciones), un caso base con lista vacía y otra función recursiva para buscar el par entre las conservadas.
- **Qué hice con eso:** Diego lo implemento en `depurador.exs` y lo probé con el archivo del enunciado: quedan las líneas 2 a 5 y las 3 observaciones.
- **Recurso distinto a lo visto en clase:** ninguno.
- **Qué aprendimos:** acumular por la cabeza de la lista es más simple, y al final hay que invertir las listas para respetar el orden del archivo.

## Consulta 3: Stream de alcance
- **Qué pedimos:** cómo construir la secuencia infinita de ciudades alcanzables y detenerla al estabilizarse.
- **Qué respondió la IA:** `Stream.iterate` para la secuencia infinita y `Stream.transform` con el paso anterior como acumulador, que devuelve `:halt` cuando dos pasos son iguales.
- **Qué hice con eso:** diego lo uso en `alcance.exs`. La prueba muestra que se calculan los pasos 0 a 3 y nunca el 4.
- **Recurso distinto a lo visto en clase:** `Stream.transform/3` y repetir una variable en un patrón (`paso, paso ->`) para comparar si dos valores son iguales.
- **Qué aprendimos:** el Stream es perezoso, así que no calcula nada hasta que `Enum.to_list` lo consume. El paso 3 se calcula solo para compararlo con el 2.

## Consulta 4: Verificador de tableros
- **Qué pedimos:** cómo verificar tableros propuestos con recursión y reportar todos los pares que se atacan.
- **Qué respondió la IA:** dos funciones recursivas, una para columnas fuera de rango y otra que compara cada reina con las filas siguientes (misma columna o diferencia de columnas igual a diferencia de filas).
- **Qué hice con eso:** diego lo implemento en `verificador.exs`. La prueba da 11 de 11 casos correctos.
- **Recurso distinto a lo visto en clase:** ninguno.
- **Qué aprendimos:** para saber si dos reinas están en diagonal basta comparar el valor absoluto de la diferencia de columnas con la diferencia de filas.

## Consulta 5: Error de rutas al ejecutar scripts
- **Qué pedimos:** por qué el script de prueba no encontraba `alcance.exs`.
- **Qué respondió la IA:** que las rutas relativas dependen de la carpeta desde donde se ejecuta, y que conviene construirlas con `Path.expand` y `__DIR__`.
- **Qué hice con eso:** ajusté la variable `base` de los scripts de prueba.
- **Recurso distinto a lo visto en clase:** `__DIR__` y `Code.require_file/1`.
- **Qué aprendimos:** `__DIR__` da la carpeta del archivo, así que los comandos funcionan desde cualquier lugar.

## Consulta 6: Repositorio, README y .gitignore
- **Qué pedimos:** ayuda para crear el `README.md`, el `.gitignore` y la estructura de carpetas del repositorio, y para verificar que quedaran bien ubicados. Después pedí reemplazar las letras A, B y C por los nombres del equipo y organizar mejor las tablas del README.
- **Qué respondió la IA:**
  - El contenido del `.gitignore` (compilados de Elixir, `salida_prueba/` y archivos del sistema) y del `README.md` (integrantes, cómo ejecutar, estructura, módulos por problema, pruebas y decisiones de diseño).
  - El orden de los commits, uno por tema.
  - La estructura completa del repositorio con el dueño de cada archivo.
  - Una advertencia: ambos archivos deben ir en la raíz, no dentro de `problema1_Rutas`.
- **Qué hice con eso:** cree los dos archivos y al principio quedaron dentro de `problema1_Rutas/datos`. Los moví a la raíz, corregí el nombre `READMI` a `README.md` y comprobé en el explorador de VS Code que quedaran al mismo nivel que las dos carpetas de los problemas. Luego cambié las letras por Natalia, Carlos y Diego, y agregué a las tablas el orden de los módulos, la pieza y las funciones principales.
- **Recurso distinto a lo visto en clase:** ninguno.
- **Qué aprendmos:**
  - Un `.gitignore` solo aplica a la carpeta donde está, así que en la raíz cubre todo el proyecto.
  - El README en la raíz es la portada del repositorio en GitHub; con otro nombre no se muestra.
  - `salida/` se sube como evidencia de la ejecución, mientras `salida_prueba/` se ignora porque son archivos temporales.
  - Conviene hacer un commit por tema, para que el historial muestre quién hizo cada parte.

## Consulta 7: Error en el árbol de llamadas y organización de la documentación
- **Qué pedimos:** por qué me aparecía un error al mostrar el árbol de llamadas de mis piezas (depurador, alcance y verificador), y cómo organizarlo en el repositorio sin dañar la estructura de mis compañeros. *(Describir aquí el error exacto: por ejemplo, el árbol se veía cortado, mezclado con el texto o con símbolos raros.)*
- **Qué respondió la IA:**
  - Que los árboles de texto deben ir dentro de un bloque de código con su cierre; si falta el cierre, todo lo que sigue en el archivo se rompe.
  - Que cada persona guarde su documentación en su propia carpeta, sin tocar las de Natalia  ni Carlos 
  - Que los cambios al README se hagan en un commit aparte y se avise al grupo.
  - Que antes de empezar se haga Pull, y que nunca se use `push --force`.
- **Qué hice con eso:** revisé que cada árbol estuviera abierto y cerrado con su bloque de código, dejé mi material solo en el README toqué únicamente las secciones de mis piezas, en commits separados.
- **Recurso distinto a lo visto en clase:** ninguno.
- **Qué aprendimos:**
  - Un bloque de código sin cierre daña el formato del resto del archivo.
  - Cada integrante es dueño de su carpeta, y así los cambios de uno no pisan los de otro.
  - Pull antes de empezar y commits pequeños evitan conflictos entre los tres.
docs/persona_c/pruebas_escritorio.md
markdown




# Pruebas de escritorio y árboles de llamadas - Diego (C)

Cada sección tiene la prueba de escritorio (tabla), el árbol de llamadas y la salida real de su script de prueba.

| Pieza | Módulo | Caso de prueba | Script de prueba |
|---|---|---|---|
| [P1-b Depurador](#p1-b-depurador-recursivo) | `depurador.exs` | Conexiones del enunciado (líneas 2 a 8) | `prueba_depurador.exs` |
 
Conexiones conservadas: 0 (esperado 4)
Observaciones: DIFERENTES

=== PARTE 2: conexiones.csv de Persona A ===

--- Mal formadas (6, esperado 6) ---
Línea 20: Armenia,Quimbaya -> Campos incorrectos (se esperan origen,destino,distancia)
Línea 21: Pereira,Armenia,Cartago,10 -> Campos incorrectos (se esperan origen,destino,distancia)
Línea 22: Salento,,30 -> Campos incorrectos (se esperan origen,destino,distancia)
Línea 23: Salento,Armenia,abc -> Distancia no numérica ("abc")
Línea 24: Salento,Armenia,30km -> Distancia no numérica ("30km")
Línea 25: Salento,Armenia,-5 -> La distancia no puede ser negativa (-5)

--- Depuración ---
Línea 28: Pereira,Armenia,45 -> repetida (línea 3); se descarta
Línea 29: Armenia,Pereira,45 -> repetida (línea 3); se descarta
Línea 30: Santa Rosa,Santa Rosa,0 -> conecta una ciudad consigo misma; se descarta
Línea 31: Cartago,Pereira,30 -> distancia distinta a la de la línea 6 (25); se conserva la de la línea 6
Línea 32: Manizales,Armenia,140 -> distancia distinta a la de la línea 10 (130); se conserva la de la línea 10
Línea 33: Leticia , Puerto Nariño , 75 -> repetida (línea 17); se descarta

Observaciones: 6 (esperado 6)
Conexiones conservadas: 13 (esperado 13)


| [P1-d Alcance](#p1-d-alcance-stream-infinito) | `alcance.exs` | Armenia en el grafo del enunciado | `prueba_alcance.exs` |
 
=== PARTE 1: ejemplo del enunciado ===

=== Alcance desde Armenia ===
Paso 0: Armenia
Paso 1: Armenia, Cartago, Pereira
Paso 2: Armenia, Cartago, Manizales, Pereira
Se estabiliza en el paso 2

Manizales alcanzable desde Armenia: true (esperado true)

=== PARTE 2: pasos que se calculan ===

calculando paso 0
calculando paso 1
calculando paso 2
calculando paso 3
pasos devueltos: 3 (esperado 3)

=== PARTE 3: conexiones.csv depurado ===

=== Alcance desde Armenia ===
Paso 0: Armenia
Paso 1: Armenia, Calarcá, Cartago, Manizales, Pereira
Paso 2: Armenia, Calarcá, Cartago, Manizales, Montenegro, Pereira, Quimbaya, Santa Rosa
Se estabiliza en el paso 2

=== Alcance desde Leticia ===
Paso 0: Leticia
Paso 1: Leticia, Puerto Nariño
Se estabiliza en el paso 1

Manizales desde Armenia: true (esperado true)
Leticia desde Armenia: false (esperado false = sin rutas)


| [P4-c Verificador](#p4-c-verificador-recursivo) | `verificador.exs` | Propuesta `0 2 1 3` | `prueba_verificador.exs` |
 
 
=== PARTE 1: resultado de cada propuesta ===

1 3 0 2 -> válida
   OK
0 2 1 3 -> inválida: reinas {0,0} y {3,3} en la misma diagonal; reinas {1,2} y {2,1} en la misma diagonal
   OK
1 3 0 0 -> inválida: reinas {2,0} y {3,0} en la misma columna
   OK
2 4 1 -> inválida: la columna 4 está fuera de un tablero de 3 × 3
   OK
2 0 3 1 -> válida
   OK
0 0 0 -> inválida: reinas {0,0} y {1,0} en la misma columna; reinas {0,0} y {2,0} en la misma columna; reinas {1,0} y {2,0} en la misma columna
   OK
0 0 5 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; reinas {0,0} y {1,0} en la misma columna
   OK
5 7 1 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; la columna 7 está fuera de un tablero de 3 × 3
   OK
-1 2 0 3 -> inválida: la columna -1 está fuera de un tablero de 4 × 4
   OK
0 -> válida
   OK
a b c -> inválida: formato inválido ("a" no es un entero)
   OK

Casos correctos: 11 de 11

=== PARTE 2: propuestas.txt -> archivo ===

1 3 0 2 -> válida
0 2 1 3 -> inválida: reinas {0,0} y {3,3} en la misma diagonal; reinas {1,2} y {2,1} en la misma diagonal
1 3 0 0 -> inválida: reinas {2,0} y {3,0} en la misma columna
2 4 1 -> inválida: la columna 4 está fuera de un tablero de 3 × 3
2 0 3 1 -> válida
0 0 0 -> inválida: reinas {0,0} y {1,0} en la misma columna; reinas {0,0} y {2,0} en la misma columna; reinas {1,0} y {2,0} en la misma columna
0 0 5 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; reinas {0,0} y {1,0} en la misma columna
5 7 1 -> inválida: la columna 5 está fuera de un tablero de 3 × 3; la columna 7 está fuera de un tablero de 3 × 3
-1 2 0 3 -> inválida: la columna -1 está fuera de un tablero de 4 × 4
0 -> válida
a b c -> inválida: formato inválido ("a" no es un entero)

docs/reflexion_ia.md (esqueleto, se llena al final con los aportes de A y B)
# Reflexión sobre el uso de inteligencia artificial

## 1. Herramientas y agentes utilizados:

Chat gpt

## 2. Un ejemplo concreto 

Se puede consultar y analizar de manera puntual un problema para encontrar alternativas que permitan solucionarlo, especialmente cuando se trata de estructurar un proceso, distribuir responsabilidades y organizar adecuadamente el trabajo.
Debemos tener en cuenta que una de las principales dificultades identificadas está relacionada con la organización y distribución de las actividades dentro del equipo. Por esta razón, la dinámica consiste en establecer una metodología de trabajo que permita que cada integrante pueda desarrollar y manejar su propio código sin intervenir ni afectar los archivos o avances de los demás compañeros.
El objetivo es mejorar la coordinación, mantener una estructura organizada del proyecto y garantizar que el trabajo colaborativo no genere inconvenientes que puedan perjudicar el desarrollo o la presentación del parcial.

## 3. Propuestas distintas a lo visto en clase

Una de las propuestas que me sugirió la IA era para reducir código y generar una opción más pequeña, Stream.chunk_every(2, 1) sirve para comparar cada paso con el siguiente sin usar Stream.transform. Queda más corto, pero calcula el paso repetido de otra forma, así que tendrías que volver a comprobar que el paso 4 nunca se calcula.


## 4. Conclusiones

La inteligencia artificial es una herramienta que nos permite desarrollar diferentes tareas y brinda apoyo en múltiples aspectos, especialmente al momento de buscar alternativas y soluciones a determinados problemas. Sin embargo, debemos tener presente que somos nosotros quienes decidimos cómo y cuándo utilizar estas herramientas, así como qué aportes incorporar y cuáles no.
Es importante comprender que la IA puede orientarnos, generar ideas y facilitar ciertos procesos, pero no debe reemplazar nuestro propio razonamiento. Somos nosotros quienes debemos establecer la lógica, tomar las decisiones y definir la estructura de nuestros proyectos, teniendo en cuenta que sus respuestas no son completamente infalibles y siempre requieren revisión y validación.
En conclusión, la inteligencia artificial debe utilizarse como un complemento para fortalecer nuestras capacidades y conocimientos, no como un sustituto de nuestro aprendizaje, criterio y responsabilidad.
Paso 6: commits y push
git pull
se realiza el commits separados, uno por tema. En VS Code, selecciona los archivos de cada grupo, escribe el mensaje y presiona Commit:
Archivos	Mensaje
.gitignore	docs: agrega .gitignore
README.md	docs: agrega README con comandos y estructura
docs/persona_c/	docs: agrega plantillas de bitácora y pruebas de escritorio
depurador.exs	depurador recursivo descarta conexiones repetidas
alcance.exs	alcance con Stream infinito y estabilización
verificador.exs	verificador recursivo de tableros propuestos
prueba/ de cada problema	test: agrega pruebas de depurador, alcance y verificador
Paso 7: comprobar en GitHub
Abre el repositorio en el navegador y confirma:
1.	Aparecen README.md, .gitignore, docs/, problema1_Rutas/ y problema4_reinas/.
2.	En la pestaña Commits hay commits de los tres integrantes.
3.	En el README se ven bien las tablas.
4.	Clonar en una carpeta limpia y ejecutar los comandos del README funciona. Esto lo harán todos el día .
Qué más te toca de Doc (según la guía)
Tarea	Cuándo
Mantener el README actualizado	Mientras Natalia y carlos suben sus programas principales
Ensamblar el PDF	Cuando todas las salidas oficiales estén generadas
Consolidar reflexion_ia.md con los aportes de Natalia y carlos	Al final
Revisar el código de A (revisión cruzada)	Cuando A termine una pieza

Bloque	Líneas	Qué ignora	Para qué
Compilados	ebin/, *.beam, _build/, deps/	Archivos compilados y dependencias	La guía exige ebin/ y *.beam; _build/ y deps/ son por si alguien usa mix
Volcado de errores	erl_crash.dump	Volcado cuando Erlang se cae	Es un archivo grande y no sirve en el repositorio
Editor	.elixir_ls/	Carpeta del plugin de Elixir en VS Code	Se regenera sola en cada máquina
Pruebas	**/salida_prueba/	Salidas de ensayo de las pruebas	Evita subir archivos temporales; salida/ sí se sube como evidencia
Sistema operativo	.DS_Store, Thumbs.db	Archivos que crean macOS y Windows	Son basura del sistema
			
Total de bloques	5		


