SELECT
    G.id,
    E.name as "Entité",
    (select Ur.users_id from glpi_tickets_users Ur where Ur.type = 1 and Ur.tickets_id = G.id limit 1) as "DID",
    (select Ur.users_id from glpi_tickets_users Ur where Ur.type = 2 and Ur.tickets_id = G.id limit 1) as "TID",
    (select concat(concat(Ur2.realname,' '),Ur2.firstname) from glpi_users Ur2 where DID = Ur2.id) AS "Demandeur",
    (select concat(concat(Ur2.realname,' '),Ur2.firstname) from glpi_users Ur2 where TID = Ur2.id) AS "Technicien",
    R.name as "Source",
    CASE G.type 
	WHEN 1 THEN 'Incident' 
        ELSE 'Demande' 
        END as "Type",
    CASE G.status 
	WHEN 1 THEN 'Nouveau' 
        WHEN 2 THEN 'En Cours'
        WHEN 3 THEN 'En Cours (Attribué)'
        WHEN 4 THEN 'En Attente'
        WHEN 5 THEN 'Resolu'
        WHEN 6 THEN 'Clos'
        ELSE NULL 
        END as "Status",
    C.name as "Catégorie",
    G.name as "Objet",
    G.date,
    G.closedate,
    G.actiontime/3600 as "actiontime",
    G.waiting_duration/3600 as "temps attente", 
    G.close_delay_stat/3600 as "temps cloture",
    G.solve_delay_stat/3600 as "temps resolution", 
    G.takeintoaccount_delay_stat/3600 as "temp prise en compte"
FROM 
    glpi_tickets G left outer join
    glpi_itilcategories C on G.itilcategories_id = C.id left outer join
    glpi_entities E on G.entities_id = E.id left outer join 
    glpi_users U1 on G.users_id_recipient = U1.id left outer join
    glpi_users U2 on G.users_id_lastupdater = U2.id left outer join
    glpi_requesttypes R on G.requesttypes_id = R.id
WHERE 
    G.is_deleted = 0
