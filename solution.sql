-- =============================================================================
-- LIMPIEZA DE TABLAS (Para evitar errores si lo corres más de una vez)
-- =============================================================================
DROP TABLE IF EXISTS inscripciones CASCADE;
DROP TABLE IF EXISTS cursos CASCADE;
DROP TABLE IF EXISTS estudiantes CASCADE;
DROP TABLE IF EXISTS docentes CASCADE;
DROP VIEW IF EXISTS vista_historial_academico CASCADE;
DROP ROLE IF EXISTS revisor_academico;

-- =============================================================================
-- TASK 1: Diseño inicial y creación de la base de datos
-- =============================================================================

CREATE TABLE docentes (
    id_docente SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(100) NOT NULL UNIQUE,
    departamento_academico VARCHAR(100) NOT NULL,
    anios_experiencia INT NOT NULL CHECK (anios_experiencia >= 0)
);

CREATE TABLE estudiantes (
    id_estudiante SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    genero VARCHAR(20) NOT NULL,
    identificacion VARCHAR(50) NOT NULL UNIQUE,
    carrera VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATE NOT NULL
);

CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    creditos INT NOT NULL CHECK (creditos > 0),
    semestre INT NOT NULL CHECK (semestre >= 1),
    id_docente INT,
    CONSTRAINT fk_docente FOREIGN KEY (id_docente) REFERENCES docentes(id_docente) ON DELETE SET NULL
);

CREATE TABLE inscripciones (
    id_inscripcion SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    calificacion_final DECIMAL(4,2) CHECK (calificacion_final >= 0.0 AND calificacion_final <= 5.0),
    CONSTRAINT fk_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_curso FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE
);

-- =============================================================================
-- TASK 2: Inserción de datos
-- =============================================================================

INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia) VALUES
('Carlos Mendoza', 'carlos.m@universidad.edu', 'Ingeniería', 6),
('Ana Rodríguez', 'ana.r@universidad.edu', 'Matemáticas', 4),
('Luis Peña', 'luis.p@universidad.edu', 'Sistemas', 8);

INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso) VALUES
('Juan Pérez', 'juan.perez@mail.com', 'Masculino', '1001', 'Ingeniería de Sistemas', '2002-05-15', '2021-02-01'),
('María Gómez', 'maria.gomez@mail.com', 'Femenino', '1002', 'Ingeniería de Sistemas', '2003-08-22', '2021-02-01'),
('Pedro López', 'pedro.lopez@mail.com', 'Masculino', '1003', 'Matemáticas', '2001-11-10', '2020-08-01'),
('Laura Cárdenas', 'laura.c@mail.com', 'Femenino', '1004', 'Industrial', '2004-01-30', '2022-02-01'),
('Andrés Castro', 'andres.c@mail.com', 'Masculino', '1005', 'Ingeniería de Sistemas', '2002-03-05', '2021-08-01');

INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente) VALUES
('Bases de Datos I', 'BD101', 4, 3, 3),
('Cálculo Integral', 'MAT202', 4, 2, 2),
('Introducción a la Programación', 'PROG101', 3, 1, 3),
('Álgebra Lineal', 'MAT101', 4, 1, 1);

INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final) VALUES
(1, 1, '2026-02-01', 4.5),
(1, 2, '2026-02-01', 3.8),
(2, 1, '2026-02-01', 4.2),
(2, 3, '2026-02-01', 4.8),
(3, 2, '2026-02-01', 3.0),
(4, 4, '2026-02-01', 3.5),
(5, 1, '2026-02-01', 4.0),
(5, 3, '2026-02-01', 2.9);

-- =============================================================================
-- TASK 3: Consultas básicas y manipulación
-- =============================================================================

-- Listar estudiantes con sus inscripciones y cursos (JOIN)
SELECT e.nombre_completo, c.nombre AS curso, i.fecha_inscripcion, i.calificacion_final
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso;

-- Listar cursos dictados por docentes con > 5 años de experiencia
SELECT c.nombre AS curso, d.nombre_completo AS docente, d.anios_experiencia
FROM cursos c
JOIN docentes d ON c.id_docente = d.id_docente
WHERE d.anios_experiencia > 5;

-- Obtener promedio de calificaciones por curso (GROUP BY + AVG)
SELECT c.nombre AS curso, AVG(i.calificacion_final) AS promedio_calificaciones
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre;

-- Mostrar estudiantes inscritos en más de un curso (HAVING COUNT(*) > 1)
SELECT e.nombre_completo, COUNT(i.id_curso) AS total_cursos
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING COUNT(i.id_curso) > 1;

-- ALTER TABLE: agregar columna estado_academico a estudiantes
ALTER TABLE estudiantes ADD COLUMN estado_academico VARCHAR(20) DEFAULT 'Activo';

-- Eliminar un docente y observar el efecto en cursos (ON DELETE SET NULL)
DELETE FROM docentes WHERE id_docente = 1;

-- Consultar cursos con más de 2 estudiantes inscritos (GROUP BY + COUNT + HAVING)
SELECT c.nombre AS curso, COUNT(i.id_estudiante) AS total_estudiantes
FROM cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre
HAVING COUNT(i.id_estudiante) > 2;

-- =============================================================================
-- TASK 4: Subconsultas y funciones
-- =============================================================================

-- Estudiantes con calificación promedio > promedio general
SELECT e.nombre_completo, AVG(i.calificacion_final) AS promedio_estudiante
FROM estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY e.id_estudiante, e.nombre_completo
HAVING AVG(i.calificacion_final) > (SELECT AVG(calificacion_final) FROM inscripciones);

-- Nombres de carreras con estudiantes inscritos en cursos del semestre >= 2
SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE e.id_estudiante IN (
    SELECT i.id_estudiante
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE c.semestre >= 2
);

-- Indicadores globales con ROUND, SUM, MAX, MIN, COUNT
SELECT
    COUNT(*) AS total_inscripciones,
    ROUND(SUM(calificacion_final), 2) AS suma_total_calificaciones,
    MAX(calificacion_final) AS calificacion_maxima,
    MIN(calificacion_final) AS calificacion_minima
FROM inscripciones;

-- =============================================================================
-- TASK 5: Creación de una vista
-- =============================================================================

CREATE VIEW vista_historial_academico AS
SELECT
    e.nombre_completo AS nombre_estudiante,
    c.nombre AS nombre_curso,
    d.nombre_completo AS nombre_docente,
    c.semestre,
    i.calificacion_final
FROM inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
LEFT JOIN docentes d ON c.id_docente = d.id_docente;

-- =============================================================================
-- TASK 6: Control de acceso y transacciones
-- =============================================================================

-- Control de accesos
CREATE ROLE revisor_academico;
GRANT SELECT ON vista_historial_academico TO revisor_academico;
REVOKE UPDATE, INSERT, DELETE ON inscripciones FROM revisor_academico;

-- Simulación de transacción
BEGIN;

UPDATE inscripciones
SET calificacion_final = 5.0
WHERE id_inscripcion = 1;

SAVEPOINT punto_control_1;

UPDATE inscripciones
SET calificacion_final = 1.0
WHERE id_inscripcion = 2;

ROLLBACK TO punto_control_1;

COMMIT;