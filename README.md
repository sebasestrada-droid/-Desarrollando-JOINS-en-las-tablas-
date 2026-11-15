PRY2205 – Desarrollo de JOINS en las Tablas

Descripción del proyecto

Este proyecto corresponde a la actividad formativa de la Semana 4 de la asignatura PRY2205 – Consulta de Bases de Datos.

El objetivo es desarrollar consultas SQL utilizando JOIN entre distintas tablas de una base de datos Oracle, aplicando funciones de una fila, funciones de grupo, restricciones de datos y criterios de ordenamiento.

El caso práctico está basado en la empresa Conciertos Chile S.A., que requiere gestionar información de sus trabajadores, ventas de tickets y bonificaciones.

Tecnologías utilizadas

- Oracle Database
- Oracle SQL Developer
- SQL

Configuración de la base de datos

Usuario: "PRY2205_S4"

Nombre de la conexión: "PRY2205_ACTIVIDAD_S4"

Desarrollo de los casos

Caso 1: Listado de Trabajadores

Consulta que permite obtener información de los trabajadores cuyo sueldo base se encuentra entre $650.000 y $3.000.000.

Información obtenida:

- Nombre completo del trabajador.
- RUT.
- Tipo de trabajador.
- Ciudad.
- Sueldo base.

Se utilizan JOIN entre las tablas TRABAJADOR, TIPO_TRABAJADOR y COMUNA_CIUDAD.

La información se ordena por ciudad de forma descendente y sueldo base de forma ascendente.

Caso 2: Listado de Cajeros

Consulta que permite obtener información de los trabajadores que desempeñan el cargo de cajero y que han realizado ventas de tickets.

Información obtenida:

- RUT del trabajador.
- Nombre del trabajador.
- Cantidad de tickets vendidos.
- Total vendido.
- Comisión total.
- Tipo de trabajador.
- Ciudad.

Se utilizan JOIN y LEFT JOIN, además de funciones de agrupación como COUNT y SUM.

Se aplica HAVING para considerar únicamente a los trabajadores cuya suma de ventas supera los $50.000.

La información se ordena por total vendido de forma descendente.

Caso 3: Listado de Bonificaciones

Consulta que permite calcular las bonificaciones correspondientes a cada trabajador, considerando su antigüedad, sistema de salud y cargas familiares.

Información obtenida:

- RUT del trabajador.
- Nombre.
- Año de ingreso.
- Años de antigüedad.
- Cantidad de cargas familiares.
- Sistema de salud.
- Sueldo base.
- Bono Fonasa.
- Bono por antigüedad.
- AFP.
- Estado civil.

Reglas de cálculo:

- Bono Fonasa: 1% del sueldo base cuando corresponde a Fonasa.
- Bono por antigüedad: 10% del sueldo para trabajadores con hasta 10 años de antigüedad.
- Bono por antigüedad: 15% del sueldo para trabajadores con 11 o más años de antigüedad.

Se utilizan JOIN, LEFT JOIN, COUNT, CASE, NVL, EXTRACT y MONTHS_BETWEEN.

También se consideran únicamente los estados civiles vigentes al momento de ejecutar la consulta.

La información se ordena por RUT de forma ascendente.

Funciones SQL utilizadas

Durante el desarrollo se aplican las siguientes funciones y herramientas:

Función / Comando| Utilidad
UPPER| Convierte texto a mayúsculas.
INITCAP| Convierte la primera letra de cada palabra a mayúscula.
TO_CHAR| Convierte y da formato a los valores.
LPAD| Alinea los datos agregando espacios.
NVL| Controla valores nulos.
ROUND| Redondea valores numéricos.
COUNT| Cuenta registros.
SUM| Calcula sumatorias.
CASE| Aplica condiciones.
EXTRACT| Obtiene el año de una fecha.
MONTHS_BETWEEN| Calcula la diferencia entre fechas.
SYSDATE| Obtiene la fecha actual.
GROUP BY| Agrupa registros.
HAVING| Filtra resultados agrupados.
JOIN / LEFT JOIN| Relaciona información de distintas tablas.

Consideraciones

- Los cálculos monetarios se presentan redondeados a números enteros.
- Se utiliza SYSDATE para trabajar con la fecha actual, evitando fechas fijas.
- Se consideran valores nulos mediante NVL y LEFT JOIN cuando corresponde.
- Las consultas respetan los formatos de presentación solicitados en la actividad.
- No se utiliza la cláusula WITH.

Ejecución

1. Conectarse a Oracle utilizando el usuario PRY2205_S4.
2. Verificar que las tablas y los datos del modelo relacional estén creados.
3. Abrir el archivo SQL del proyecto en Oracle SQL Developer.
4. Ejecutar las consultas correspondientes a los tres casos.
5. Revisar los resultados obtenidos.

