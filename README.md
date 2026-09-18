# Base de Datos `hospital`

Base de datos relacional que modela la gestión de un centro hospitalario: médicos, especialidades, horarios, sustituciones, empleados, pacientes, atenciones y vacaciones (tanto de médicos como de empleados).

## 📋 Tabla de contenido

- [Cómo fue creada](#cómo-fue-creada)
- [IDE / Herramienta utilizada](#ide--herramienta-utilizada)
- [Modelo de datos](#modelo-de-datos)
- [Estructura de tablas](#estructura-de-tablas)
- [Cómo funciona](#cómo-funciona)
- [Qué se puede hacer con esta base de datos](#qué-se-puede-hacer-con-esta-base-de-datos)
- [Qué NO se puede hacer con esta base de datos](#qué-no-se-puede-hacer-con-esta-base-de-datos)
- [Cómo ejecutarla](#cómo-ejecutarla)

---

## Cómo fue creada

La base de datos fue creada mediante un único script SQL (`DB_examen_sql_tablas_e_incersion_de_datos.sql`) que realiza, en orden:

1. **Creación de la base de datos**: `CREATE DATABASE IF NOT EXISTS hospital;`
2. **Creación de 9 tablas** con sus llaves primarias (`PRIMARY KEY AUTO_INCREMENT`), llaves foráneas (`FOREIGN KEY`) y restricciones (`UNIQUE`, `NOT NULL`, `ENUM`, valores por defecto).
3. **Limpieza previa de datos**: se desactivan temporalmente las validaciones de llaves foráneas (`SET FOREIGN_KEY_CHECKS = 0`), se vacían todas las tablas con `TRUNCATE` (en orden inverso a sus dependencias) y se reactivan las validaciones (`SET FOREIGN_KEY_CHECKS = 1`).
4. **Inserción de datos de prueba** en cada tabla: 10 especialidades, 10 médicos, 24 horarios, 10 sustituciones, 10 empleados, 15 pacientes, 10 atenciones y registros de vacaciones para médicos y empleados.

Adicionalmente, existe un segundo script (`Consultas.sql`) con 12 consultas de explotación de la información (reportes) que se ejecutan sobre este modelo ya creado y poblado.

## IDE / Herramienta utilizada

- **Motor de base de datos:** MySQL.
- **IDE / cliente utilizado:** **MySQL Workbench** (se observa en las capturas el "Result Grid", la barra de herramientas de ejecución de scripts y el panel de resultados típicos de esta herramienta).
- Los diagramas del modelo (conceptual y lógico) fueron generados también como apoyo visual del diseño, probablemente con un editor de diagramas ER (tipo notación Chen/Crow's Foot) antes de traducirlos al script SQL.

## Modelo de datos

Se incluyen dos representaciones del modelo:

- **Diagrama conceptual (entidad-relación):** muestra las entidades del negocio (Especialidades, Médicos, Pacientes, Empleados, Atenciones, Horarios Médicos, Sustituciones, Vacaciones Médicos, Vacaciones Empleados) y sus relaciones con cardinalidad (p. ej. un médico *tiene* una especialidad, un médico *tiene horario en* Horarios Médicos, un médico *sustituye/es sustituido* en Sustituciones, un empleado *supervisa (0,N)* médicos, etc.).
- **Diagrama lógico:** traduce el conceptual a tablas físicas con sus columnas, tipos de datos, llaves primarias (PK) y foráneas (FK).

### Relaciones principales

| Relación | Tipo | Descripción |
|---|---|---|
| `especialidades` → `medicos` | 1:N | Cada médico tiene una especialidad; una especialidad puede tener varios médicos. |
| `medicos` → `horarios_medicos` | 1:N | Un médico puede tener varios horarios (por día de la semana). |
| `medicos` → `sustituciones` (doble FK) | 1:N (x2) | Un médico puede actuar como sustituto (`id_medico_sustituto`) y/o ser sustituido (`id_medico_sustituido`). |
| `medicos` → `empleados` | 1:N | Un médico puede supervisar (0,N) empleados (`id_supervisor_medico`, campo opcional). |
| `medicos` → `pacientes` | 1:N | Un paciente tiene un médico asignado. |
| `medicos`/`pacientes` → `atenciones` | 1:N (x2) | Cada atención registra un médico y un paciente. |
| `medicos` → `vacaciones_med` | 1:N | Registro anual de vacaciones planificadas/disfrutadas por médico. |
| `empleados` → `vacaciones_empleados` | 1:N | Registro anual de vacaciones planificadas/disfrutadas por empleado. |

## Estructura de tablas

| Tabla | Propósito | Campos clave |
|---|---|---|
| `especialidades` | Catálogo de especialidades médicas | `id_especialidad` (PK), `nombre` (único) |
| `medicos` | Datos del personal médico | `id_medico` (PK), `documento` (único), `tipo` (titular/interino/sustituto), `id_especialidad` (FK) |
| `horarios_medicos` | Horas de consulta por médico y día | `id_horario` (PK), `id_medico` (FK), `dia_semana` (ENUM), `horas_consulta` |
| `sustituciones` | Períodos en que un médico sustituye a otro | `id_sustitucion` (PK), `id_medico_sustituto` (FK), `id_medico_sustituido` (FK), `fecha_inicio`, `fecha_fin` |
| `empleados` | Personal no médico (ATS, enfermería, celadores, administrativos) | `id_empleado` (PK), `documento` (único), `rol` (ENUM), `id_supervisor_medico` (FK opcional) |
| `pacientes` | Pacientes registrados | `id_paciente` (PK), `documento` (único), `id_medico_asignado` (FK) |
| `atenciones` | Consultas/atenciones realizadas | `id_atencion` (PK), `id_paciente` (FK), `id_medico` (FK), `fecha_atencion` |
| `vacaciones_med` | Vacaciones anuales de médicos | `id_vacacion` (PK), `id_medico` (FK), `dias_planificados`, `dias_disfrutados`, `año` |
| `vacaciones_empleados` | Vacaciones anuales de empleados | `id_vacacion` (PK), `id_empleado` (FK), `dias_planificados`, `dias_disfrutados`, `año` |

## Cómo funciona

1. El script de creación construye primero las tablas "maestras" (`especialidades`, `medicos`) y luego las tablas dependientes que referencian sus llaves primarias.
2. La integridad referencial se garantiza mediante `FOREIGN KEY`, por lo que no es posible insertar, por ejemplo, una atención para un médico o paciente que no exista.
3. Los datos de ejemplo simulan un hospital pequeño: 10 médicos con distintos tipos (titular, interino, sustituto), sus horarios semanales, períodos de sustitución entre ellos, empleados que reportan a un médico supervisor, pacientes asignados a un médico y el historial de atenciones/vacaciones.
4. Sobre este modelo poblado se ejecutan las 12 consultas del archivo `Consultas.sql`, que combinan `JOIN`/`LEFT JOIN`, funciones de agregación (`COUNT`, `SUM`, `AVG`), `GROUP BY`, `HAVING`, `ORDER BY` y `LIMIT` para generar reportes de gestión.

## Qué se puede hacer con esta base de datos

Con el modelo y las consultas incluidas es posible responder preguntas de negocio como:

- **Carga de pacientes por médico**, incluyendo médicos sin pacientes atendidos aún (Consulta 1, 7).
- **Vacaciones planificadas vs. disfrutadas** por empleado o por médico (Consulta 2, 8).
- **Horas de consulta totales** por médico, en total o desglosadas por día de la semana (Consulta 3, 6, 10).
- **Historial y actividad de sustituciones**: cuántas veces ha sustituido cada médico, quién está sustituyendo activamente hoy (`CURDATE()` entre `fecha_inicio` y `fecha_fin`) (Consulta 4, 5, 9).
- **El médico con más pacientes asignados** (Consulta 7).
- **Carga de trabajo por supervisor**: cuántas atenciones generan los médicos que supervisa cada empleado (Consulta 11).
- **Filtrado con `HAVING`**: empleados con más de X días disfrutados, médicos con más de X pacientes (Consulta 8, 12).
- **Ampliar el modelo** fácilmente: agregar nuevas especialidades, médicos, pacientes, horarios o períodos de sustitución respetando las llaves foráneas.
- **Escribir nuevas consultas** de análisis (rankings, promedios, conteos, combinaciones de tablas) gracias a que el modelo está normalizado y las relaciones están claramente definidas.

## Qué NO se puede hacer con esta base de datos

Limitaciones propias del diseño actual del script:

- **No hay control de solapamiento de fechas** en `sustituciones`: la base de datos no impide (a nivel de restricción) que un mismo médico tenga dos sustituciones activas al mismo tiempo, ni que un médico se sustituya a sí mismo.
- **No hay validación de coherencia de horarios**: nada impide registrar más de 24 horas de consulta en un mismo día, ni horarios duplicados para el mismo médico y día.
- **No se relaciona `vacaciones_med` con `horarios_medicos` ni `sustituciones`**: el modelo no valida que un médico de vacaciones no tenga horario asignado o sustituciones activas ese mismo período.
- **No existen procedimientos almacenados, funciones, triggers ni vistas**: toda la lógica de negocio (cálculos, validaciones, reportes) debe hacerse mediante consultas `SELECT` externas; no hay automatización dentro de la base de datos.
- **No hay control de usuarios ni permisos** definidos en el script (roles de acceso, `GRANT`/`REVOKE`): cualquier usuario con acceso a la base puede leer o modificar todas las tablas.
- **No hay auditoría ni histórico de cambios**: no existen columnas de tipo `created_at`/`updated_at`, ni tablas de log, por lo que no se puede saber cuándo se modificó un registro ni quién lo hizo.
- **No se registra información clínica de los pacientes** (diagnósticos, tratamientos, historia clínica): la tabla `atenciones` solo guarda que existió una atención, no su contenido.
- **Un médico solo puede tener una especialidad** (`id_especialidad` no admite múltiples valores), por lo que no se puede modelar un médico con dos o más especialidades sin cambiar el diseño.
- **No hay índices adicionales** más allá de las llaves primarias/foráneas y las columnas `UNIQUE`, por lo que el rendimiento en tablas con grandes volúmenes de datos podría verse afectado en consultas de filtrado no cubiertas por esas columnas.
- **El truncado inicial borra todos los datos existentes**: volver a ejecutar el script de creación elimina cualquier dato insertado manualmente después de la carga inicial (no es un script incremental/idempotente en cuanto a datos).

## Cómo ejecutarla

1. Abrir MySQL Workbench (u otro cliente MySQL) y conectarse a una instancia de MySQL.
2. Ejecutar el script `DB_examen_sql_tablas_e_incersion_de_datos.sql` completo para crear la base de datos `hospital`, sus tablas y cargar los datos de prueba.
3. Ejecutar `USE hospital;` seguido de cualquiera de las 12 consultas de `Consultas.sql` (o del script completo) para obtener los reportes descritos.
