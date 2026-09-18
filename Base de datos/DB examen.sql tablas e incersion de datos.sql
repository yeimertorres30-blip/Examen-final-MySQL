create database if not exists hospital;
use hospital;

create table if not exists especialidades (
    id_especialidad int auto_increment primary key,
    nombre varchar(100) not null unique
);

create table if not exists medicos (
    id_medico int auto_increment primary key,
    nombre varchar(150) not null,
    apellido varchar(150) not null,
    documento varchar(25) not null unique,
    tipo enum('titular', 'interino', 'sustituto') not null,
    id_especialidad int not null,
    constraint fk_medicos_especialidad foreign key (id_especialidad) references especialidades(id_especialidad)
);

create table if not exists horarios_medicos (
    id_horario int auto_increment primary key,
    id_medico int not null,
    dia_semana enum('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') not null,
    horas_consulta decimal(4,2) not null default 0.00,
    constraint fk_horarios_medico foreign key (id_medico) references medicos(id_medico)
);

create table if not exists sustituciones (
    id_sustitucion int auto_increment primary key,
    id_medico_sustituto int not null,
    id_medico_sustituido int not null,
    fecha_inicio date not null,
    fecha_fin date not null,
    constraint fk_sus_sustituto foreign key (id_medico_sustituto) references medicos(id_medico),
    constraint fk_sus_sustituido foreign key (id_medico_sustituido) references medicos(id_medico)
);

create table if not exists empleados (
    id_empleado int auto_increment primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    documento varchar(20) not null unique,
    rol enum('ATS', 'auxiliar_enfermeria', 'celador', 'administrativo') not null,
    id_supervisor_medico int null,
    constraint fk_emp_supervisor foreign key (id_supervisor_medico) references medicos(id_medico)
);

create table if not exists pacientes (
    id_paciente int auto_increment primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    documento varchar(20) not null unique,
    id_medico_asignado int not null,
    constraint fk_pacientes_medico foreign key (id_medico_asignado) references medicos(id_medico)
);

create table if not exists atenciones (
    id_atencion int auto_increment primary key,
    id_paciente int not null,
    id_medico int not null,
    fecha_atencion datetime not null,
    constraint fk_atencion_paciente foreign key (id_paciente) references pacientes(id_paciente),
    constraint fk_atencion_medico foreign key (id_medico) references medicos(id_medico)
);

create table if not exists vacaciones_med (
    id_vacacion int auto_increment primary key,
    id_medico int not null,
    dias_planificados int not null default 0,
    dias_disfrutados int not null default 0,
    año year not null,
    constraint fk_vac_medico foreign key (id_medico) references medicos(id_medico)
);

create table if not exists vacaciones_empleados (
    id_vacacion int auto_increment primary key,
    id_empleado int not null,
    dias_planificados int not null default 0,
    dias_disfrutados int not null default 0,
    año year not null,
    constraint fk_vac_empleado foreign key (id_empleado) references empleados(id_empleado)
);

set foreign_key_checks = 0;
truncate table atenciones;
truncate table vacaciones_empleados;
truncate table vacaciones_med;
truncate table pacientes;
truncate table empleados;
truncate table sustituciones;
truncate table horarios_medicos;
truncate table medicos;
truncate table especialidades;
set foreign_key_checks = 1;

insert into especialidades (id_especialidad, nombre) values
(1, 'medico general'),
(2, 'cardiologo'),
(3, 'pediatra'),
(4, 'psicologo'),
(5, 'odontologo'),
(6, 'neurologo'),
(7, 'dermatologo'),
(8, 'oftamologo'),
(9, 'otorrinonaringologo'),
(10, 'psiquiatra');

insert into medicos (id_medico, nombre, apellido, documento, tipo, id_especialidad) values
(1, 'Pepito', 'Pérez', '1010101', 'titular', 1),
(2, 'Maria', 'Suarez', '1010102', 'interino', 2),
(3, 'Javier', 'Cuadros', '1010103', 'sustituto', 10),
(4, 'Maria', 'Mendoza', '1010104', 'sustituto', 9),
(5, 'Duvan', 'Covilla', '1010105', 'titular', 7),
(6, 'Diana', 'Rojas', '6060606', 'sustituto', 8),
(7, 'Fernando', 'López', '7070707', 'interino', 5),
(8, 'Sofía', 'Mendoza', '8080808', 'titular', 6),
(9, 'Javier', 'Castillo', '9090909', 'sustituto', 3),
(10, 'Valentina', 'Ortega', '1001001', 'interino', 3);

insert into horarios_medicos (id_medico, dia_semana, horas_consulta) values
(1, 'Lunes', 6.00), (1, 'Martes', 6.00), (1, 'Miércoles', 6.00),
(2, 'Lunes', 7.00), (2, 'Martes', 7.00),
(3, 'Lunes', 5.00), (3, 'Viernes', 5.00),
(4, 'Lunes', 8.00), (4, 'Martes', 8.00), (4, 'Miércoles', 8.00), (4, 'Jueves', 8.00), (4, 'Viernes', 6.00),
(5, 'Martes', 6.00), (5, 'Jueves', 6.00),
(6, 'Martes', 4.00), (6, 'Jueves', 4.00),
(7, 'Lunes', 6.00), (7, 'Miércoles', 6.00),
(8, 'Lunes', 7.00), (8, 'Martes', 7.00), (8, 'Miércoles', 7.00),
(9, 'Lunes', 5.00), (9, 'Miércoles', 5.00),
(10, 'Martes', 6.00), (10, 'Jueves', 6.00);

insert into sustituciones (id_sustitucion, id_medico_sustituto, id_medico_sustituido, fecha_inicio, fecha_fin) values
(1, 3, 1, '2026-09-01', '2026-09-25'),
(2, 6, 2, '2026-09-10', '2026-09-30'),
(3, 3, 5, '2025-08-01', '2025-08-15'),
(4, 9, 4, '2026-09-05', '2026-09-20'),
(5, 6, 8, '2026-09-12', '2026-10-05'),
(6, 3, 7, '2025-03-01', '2025-03-10'),
(7, 9, 2, '2025-06-01', '2025-06-15'),
(8, 6, 4, '2025-04-10', '2025-04-20'),
(9, 3, 10, '2026-09-15', '2026-10-15'),
(10, 9, 1, '2025-11-01', '2025-11-10');

insert into empleados (id_empleado, nombre, apellido, documento, rol, id_supervisor_medico) values
(1, 'Sofía', 'Ramírez', '9000001', 'ATS', 1),
(2, 'Mateo', 'Ruiz', '9000002', 'auxiliar_enfermeria', 1),
(3, 'Lucía', 'Castro', '9000003', 'celador', 2),
(4, 'Diego', 'Morales', '9000004', 'administrativo', null),
(5, 'Valentina', 'Herrera', '9000005', 'ATS', 4),
(6, 'Andrés', 'Gil', '9000006', 'celador', null),
(7, 'Camila', 'Vargas', '9000007', 'auxiliar_enfermeria', 4),
(8, 'Gabriel', 'Soto', '9000008', 'administrativo', 1),
(9, 'Natalia', 'Páez', '9000009', 'ATS', 8),
(10, 'Samuel', 'Ríos', '9000010', 'celador', 5);

insert into pacientes (id_paciente, nombre, apellido, documento, id_medico_asignado) values
(1, 'Juan', 'López', '5050501', 1),
(2, 'María', 'Díaz', '5050502', 1),
(3, 'Pedro', 'Sánchez', '5050503', 1),
(4, 'Laura', 'Jiménez', '5050504', 2),
(5, 'Jorge', 'Vargas', '5050505', 2),
(6, 'Camila', 'Rojas', '5050506', 4),
(7, 'Felipe', 'Ortiz', '5050507', 4),
(8, 'Valeria', 'Mendoza', '5050508', 4),
(9, 'Gabriel', 'Navarro', '5050509', 4),
(10, 'Natalia', 'Paz', '5050510', 4),
(11, 'Samuel', 'Ríos', '5050511', 4),
(12, 'Daniela', 'Acosta', '5050512', 5),
(13, 'Alejandro', 'Cruz', '5050513', 5),
(14, 'Luciana', 'Mejía', '5050514', 8),
(15, 'Matías', 'Guzmán', '5050515', 8);

insert into atenciones (id_atencion, id_paciente, id_medico, fecha_atencion) values
(1, 1, 1, '2026-09-10 08:00:00'),
(2, 2, 1, '2026-09-10 09:00:00'),
(3, 6, 4, '2026-09-11 10:00:00'),
(4, 7, 4, '2026-09-11 11:00:00'),
(5, 4, 2, '2026-09-12 09:30:00'),
(6, 3, 1, '2026-09-12 10:30:00'),
(7, 8, 4, '2026-09-13 08:30:00'),
(8, 12, 5, '2026-09-14 09:00:00'),
(9, 14, 8, '2026-09-15 10:00:00'),
(10, 5, 2, '2026-09-15 11:00:00');

insert into vacaciones_med (id_medico, dias_planificados, dias_disfrutados, año) values
(1, 25, 15, 2026),
(2, 15, 10, 2026),
(3, 10,  0, 2026),
(4, 30, 22, 2026),
(5, 22, 18, 2026),
(6, 12,  5, 2026),
(7, 20, 10, 2026),
(8, 25, 21, 2026),
(9, 15,  8, 2026),
(10, 18, 12, 2026);

insert into vacaciones_empleados (id_empleado, dias_planificados, dias_disfrutados, año) values
(1, 20, 12, 2026),
(2, 15, 11, 2026),
(3, 15,  5, 2026),
(4, 25, 20, 2026),
(5, 22, 15, 2026),
(6, 10,  4, 2026),
(7, 18, 12, 2026),
(8, 24, 16, 2026),
(9, 15, 11, 2026),
(10, 12,  3, 2026);

