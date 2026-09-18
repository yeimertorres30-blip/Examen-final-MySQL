use hospital;
-- consulta 1
select m.id_medico, m.nombre, m.apellido, count(a.id_atencion) as total_pacientes
from medicos as m
left join atenciones a on m.id_medico = a.id_medico
group by m.id_medico, m.nombre, m.apellido;
-- consulta 2
select e.id_empleado, e.nombre, e.apellido, sum(v.dias_planificados) as planificadas, sum(v.dias_disfrutados) as disfrutadas
from empleados as e
left join vacaciones_empleados v on e.id_empleado = v.id_empleado
group by e.id_empleado, e.nombre, e.apellido;
-- consulta 3
select m.id_medico, m.nombre, m.apellido, sum(h.horas_consulta) as total_horas
from medicos as m
join horarios_medicos h on m.id_medico = h.id_medico
group by m.id_medico, m.nombre, m.apellido
order by total_horas desc;
-- consulta 4
select m.id_medico, m.nombre, m.apellido, count(s.id_sustitucion) as total_sustituciones
from medicos as m
join sustituciones s on m.id_medico = s.id_medico_sustituto
group by m.id_medico, m.nombre, m.apellido;
-- consulta 5
select count(distinct id_medico_sustituto) as medicos_activos_sustitucion
from sustituciones
where curdate() between fecha_inicio and fecha_fin;
-- consulta 6
select m.id_medico, m.nombre, m.apellido, h.dia_semana, sum(h.horas_consulta) as total_horas
from medicos as m
join horarios_medicos h on m.id_medico = h.id_medico
group by m.id_medico, m.nombre, m.apellido, h.dia_semana;
-- consulta 7
select m.id_medico, m.nombre, m.apellido, count(p.id_paciente) as total_pacientes
from medicos as m
left join pacientes p on m.id_medico = p.id_medico_asignado
group by m.id_medico, m.nombre, m.apellido
order by total_pacientes desc
limit 1;
-- consulta 8
select e.id_empleado, e.nombre, e.apellido, sum(v.dias_disfrutados) as disfrutadas
from empleados as e
join vacaciones_empleados v on e.id_empleado = v.id_empleado
group by e.id_empleado, e.nombre, e.apellido
having disfrutadas > 10;
-- consulta 9
select distinct m.id_medico, m.nombre, m.apellido
from medicos as m
join sustituciones s on m.id_medico = s.id_medico_sustituto
where curdate() between s.fecha_inicio and s.fecha_fin;
-- consulta 10
select h.dia_semana, avg(h.horas_consulta) as promedio_horas
from horarios_medicos h
group by h.dia_semana;
-- consulta 11
select e.id_empleado, e.nombre, e.apellido, count(a.id_atencion) as total_pacientes
from empleados as e
join medicos m on e.id_supervisor_medico = m.id_medico
left join atenciones a on m.id_medico = a.id_medico
group by e.id_empleado, e.nombre, e.apellido
order by total_pacientes desc;
-- consulta 12
select m.id_medico, m.nombre, m.apellido, count(distinct p.id_paciente) as total_pacientes, sum(h.horas_consulta) as total_horas
from medicos as m
left join pacientes p on m.id_medico = p.id_medico_asignado
join horarios_medicos h on m.id_medico = h.id_medico
group by m.id_medico, m.nombre, m.apellido
having total_pacientes > 5;