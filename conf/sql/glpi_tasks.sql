SELECT
    Gt.id,
    Gt.date as "Date Tache",
    G.closedate as "Date Ticket Cloture",
    E.name as "Entité",
    (SELECT Ur.users_id FROM glpi_tickets_users Ur where Ur.type = 1 and Ur.tickets_id = G.id limit 1) as "DID",
    (SELECT concat(concat(Ur2.realname,' '),Ur2.firstname) FROM glpi_users Ur2 where DID = Ur2.id) AS "Demandeur",
    concat(concat(Gu.realname,' '),Gu.firstname) as "Technicien",
    Gc.name as "Categorie",
    G.name as "Objet",
	CASE G.type
        WHEN 1 THEN 'Incident'
        ELSE 'Demande'
        END as "Type",
	R.name as "Source",
    Gt.content as "Tache",
    Gt.actiontime/3600 as "actiontime" 
FROM
    glpi_tickettasks Gt left outer join
    glpi_users Gu on Gt.users_id = Gu.id left outer join
    glpi_tickets G on G.id = Gt.tickets_id left outer join
    glpi_entities E on G.entities_id = E.id left outer join
    glpi_itilcategories Gc on Gc.id = G.itilcategories_id left outer join
    glpi_requesttypes R on G.requesttypes_id = R.id
WHERE  
    G.is_deleted = 0
