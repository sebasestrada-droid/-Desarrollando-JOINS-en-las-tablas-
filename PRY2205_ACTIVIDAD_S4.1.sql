/* ==================================================================
   PRY2205 - Consulta de Bases de Datos
   Actividad Formativa Semana 4: "Desarrollando JOINS en las tablas"
   Caso CONCIERTOS CHILE S.A. (trabajadores, tickets y bonificaciones)
   Usuario: PRY2205_S4  |  Conexión: PRY2205_ACTIVIDAD_S4

   Notas generales:
   - No hay fechas fijas: la fecha actual se obtiene con SYSDATE.
   - Los valores en dinero se muestran redondeados a enteros.
   - Los textos se presentan con UPPER / INITCAP, sin depender de cómo
     estén guardados en las tablas.
   - LPAD alinea a la derecha los importes de texto (resultado de TO_CHAR).
     Si alguna columna queda desalineada, subir o bajar en 1 el ancho.
   ================================================================== */


/* ============================================================
   CASO 1: Listado de Trabajadores
   Reglas:
   - Solo trabajadores con sueldo base entre 650.000 y 3.000.000
     (ambos valores incluidos).
   - Nombre completo en MAYÚSCULAS; RUT con puntos y dígito verificador.
   - Orden: nombre de ciudad descendente y sueldo base ascendente.
   Tablas: TRABAJADOR, TIPO_TRABAJADOR, COMUNA_CIUDAD
   ============================================================ */
SELECT UPPER(t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno)  AS "Nombre Completo Trabajador",
       -- FM quita el espacio inicial cuando el RUT tiene menos dígitos
       TO_CHAR(t.numrut, 'FM99G999G999') || '-' || t.dvrut           AS "RUT Trabajador",
       UPPER(tt.desc_categoria)                                      AS "Tipo Trabajador",
       UPPER(cc.nombre_ciudad)                                       AS "Ciudad Trabajador",
       LPAD(TO_CHAR(t.sueldo_base, 'FM$9G999G999'), 12)              AS "Sueldo Base"
FROM trabajador t
     JOIN tipo_trabajador tt ON t.id_categoria_t = tt.id_categoria
     JOIN comuna_ciudad  cc ON t.id_ciudad = cc.id_ciudad
-- BETWEEN incluye ambos extremos
WHERE t.sueldo_base BETWEEN 650000 AND 3000000
ORDER BY cc.nombre_ciudad DESC,
         t.sueldo_base ASC;


/* ============================================================
   CASO 2: Listado Cajeros
   Reglas:
   - Solo trabajadores con rol CAJERO que hayan vendido tickets.
   - Se muestra cantidad de tickets, total vendido, comisión total
     y comuna del trabajador.
   - Solo cajeros cuya suma de montos de tickets supera 50.000
     (restricción de grupo: HAVING).
   - Orden: total vendido descendente.
   Tablas: TRABAJADOR, TIPO_TRABAJADOR, COMUNA_CIUDAD,
           TICKETS_CONCIERTO, COMISIONES_TICKET
   ============================================================ */
SELECT TO_CHAR(t.numrut, 'FM99G999G999') || '-' || t.dvrut           AS "RUT Trabajador",
       -- Nombre con inicial mayúscula y apellido en mayúsculas
       INITCAP(t.nombre) || ' ' || UPPER(t.appaterno)                AS "Nombre Trabajador",
       COUNT(tk.nro_ticket)                                          AS "Total Tickets",
       LPAD(TO_CHAR(SUM(tk.monto_ticket), 'FM$9G999G999'), 14)       AS "Total Vendido",
       -- NVL: un ticket sin comisión suma 0
       LPAD(TO_CHAR(SUM(NVL(ct.valor_comision, 0)), 'FM$9G999G999'), 15) AS "Comisión Total",
       UPPER(tt.desc_categoria)                                      AS "Tipo Trabajador",
       UPPER(cc.nombre_ciudad)                                       AS "Ciudad Trabajador"
FROM trabajador t
     JOIN tipo_trabajador   tt ON t.id_categoria_t = tt.id_categoria
     JOIN comuna_ciudad     cc ON t.id_ciudad = cc.id_ciudad
     JOIN tickets_concierto tk ON tk.numrut_t = t.numrut
     -- LEFT JOIN: conserva tickets aunque no tengan registro de comisión
     LEFT JOIN comisiones_ticket ct ON ct.nro_ticket = tk.nro_ticket
WHERE UPPER(tt.desc_categoria) = 'CAJERO'
-- Todas las columnas que no son función de grupo van en el GROUP BY
GROUP BY t.numrut, t.dvrut, t.nombre, t.appaterno,
         tt.desc_categoria, cc.nombre_ciudad
-- HAVING filtra grupos (WHERE no admite funciones de grupo)
HAVING SUM(tk.monto_ticket) > 50000
-- Se ordena por el valor numérico, no por el alias formateado (texto)
ORDER BY SUM(tk.monto_ticket) DESC;


/* ============================================================
   CASO 3: Listado de Bonificaciones
   Reglas:
   - Año de ingreso y años de antigüedad (con la fecha actual).
   - Cantidad de cargas familiares (0 si no tiene).
   - Bono Fonasa: 1% del sueldo base si el sistema de salud es
     Fonasa; en otro caso 0.
   - Bono por antigüedad (todos los trabajadores): 10% del sueldo con
     10 años o menos; 15% con 11 años o más.
   - Solo trabajadores sin fecha de término del estado civil, o cuya
     fecha de término es posterior a la fecha de ejecución del reporte.
   - Orden: RUT ascendente.
   Tablas: TRABAJADOR, ISAPRE, AFP, EST_CIVIL, ESTADO_CIVIL,
           ASIGNACION_FAMILIAR
   ============================================================ */
SELECT TO_CHAR(t.numrut, 'FM99G999G999')                              AS "RUT Trabajador",
       INITCAP(t.nombre) || ' ' || INITCAP(t.appaterno)               AS "Trabajador Nombre",
       EXTRACT(YEAR FROM t.fecing)                                    AS "Año Ingreso",
       TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12)                  AS "Años Antigüedad",
       -- COUNT(columna) no cuenta los NULL que deja el LEFT JOIN
       COUNT(af.numrut_carga)                                         AS "Num. Cargas Familiares",
       LPAD(INITCAP(i.nombre_isapre), 14)                             AS "Nombre Isapre",
       LPAD(TO_CHAR(t.sueldo_base, 'FM$9G999G999'), 12)               AS "Sueldo Base",
       LPAD(CASE
                WHEN UPPER(i.nombre_isapre) = 'FONASA'
                    THEN TO_CHAR(ROUND(t.sueldo_base * 0.01), 'FM$9G999G999')
                ELSE '0'
            END, 12)                                                  AS "Bono Fonasa",
       LPAD(TO_CHAR(ROUND(t.sueldo_base *
                CASE
                    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12) <= 10 THEN 0.10
                    ELSE 0.15
                END), 'FM$9G999G999'), 16)                            AS "Bono Antigüedad",
       INITCAP(a.nombre_afp)                                          AS "Nombre AFP",
       UPPER(ec.desc_estcivil)                                        AS "Estado Civil"
FROM trabajador t
     JOIN isapre       i  ON t.cod_isapre = i.cod_isapre
     JOIN afp          a  ON t.cod_afp = a.cod_afp
     JOIN est_civil    e  ON e.numrut_t = t.numrut
     JOIN estado_civil ec ON ec.id_estcivil = e.id_estcivil_est
     -- LEFT JOIN: los trabajadores sin cargas también deben aparecer
     LEFT JOIN asignacion_familiar af ON af.numrut_t = t.numrut
-- Estado civil vigente: sin fecha de término o con término futuro
WHERE (e.fecter_estcivil IS NULL OR e.fecter_estcivil > SYSDATE)
GROUP BY t.numrut, t.nombre, t.appaterno, t.fecing, t.sueldo_base,
         i.nombre_isapre, a.nombre_afp, ec.desc_estcivil
ORDER BY t.numrut ASC;
