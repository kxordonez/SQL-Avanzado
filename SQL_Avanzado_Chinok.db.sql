--///////////////////    CONSULTA 1    ///////////////////
--Se desea saber la cantidad de pistas que pertenecen a cada artista 
--junto a la suma del precio unitario de las pistas.
--Tambien se desea consultar el año de facturacion del 2010 la suma y que sean entre 10 y 20
--El empleado encargado de la venta debe ser de Canada
select artists.Name AS "Artista",  
count(tracks.AlbumId) AS "Num de Pistas",
Sum(tracks.UnitPrice) AS "Suma de las pistas",
substr(invoices.InvoiceDate,0,5) AS "Año",
sum(invoices.Total) AS "Facturacion",
employees.Country AS "Pais del empleado"
from artists INNER JOIN albums
ON artists.ArtistId = albums.ArtistId INNER JOIN tracks
ON albums.AlbumId= tracks.AlbumId INNER JOIN invoice_items
ON tracks.TrackId=invoice_items.TrackId INNER JOIN invoices
ON invoice_items.InvoiceId=invoices.InvoiceId INNER JOIN customers
ON invoices.CustomerId= customers.CustomerId INNER JOIN employees
ON customers.SupportRepId= employees.EmployeeId
WHERE invoices.InvoiceDate like '2010%' AND employees.Country== 'Canada'
GROUP BY albums.ArtistId,artists.ArtistId
HAVING sum(invoices.Total) BETWEEN 10 AND 20
ORDER BY artists.Name ASC;


--///////////////////    CONSULTA 2   ///////////////////
-- Se desea realizar una consulta en la que muestre la lista de reproduccion junto a la cantidad de pistas que contiene cada una.
-- Colocar el monto total de las facturas generadas de las ventas. Permitir la impresion del nombre del empleado a cargo, generar 
-- una visualizacion de la compañia del cliente se debe de tener en cuenta que este no debe de estar vacio.
-- Por ultimo el numero de la cantidad de pistas deben de ser mayor a dos
select playlists.Name AS "List de reproducion",
        count(tracks.TrackId) AS "Num de pistas",
        SUM(invoices.Total) AS "Total Ventas",
        customers.Company,
        employees.FirstName AS "Nom empleado"
from playlists 
INNER JOIN playlist_track
ON playlists.PlaylistId= playlist_track.PlaylistId 
INNER JOIN tracks
ON playlist_track.TrackId= tracks.TrackId 
INNER JOIN invoice_items
ON tracks.TrackId=invoice_items.TrackId 
INNER JOIN invoices
ON invoice_items.InvoiceId=invoices.InvoiceId 
INNER JOIN customers
ON invoices.CustomerId= customers.CustomerId 
INNER JOIN employees
ON customers.SupportRepId= employees.EmployeeId
WHERE customers.Company <> 'NULL'
GROUP BY playlists.Name
HAVING count(tracks.TrackId) > 2;


--///////////////////    CONSULTA 3   ///////////////////
--Proporcione una consulta que muestre los tipos de medios cuando la suma total por las factutas sean mayores a 25
--Tambien se deben especificar la cantidad de facturas generadas por cada medio y mencionar nombre y titulo del empleado a cargo. 
select  media_types.Name AS "Tipo de Medio",
SUM(invoices.Total) AS "Suma total",
count(invoices.InvoiceId) AS "Cantidad Facturas",
genres.Name AS "Genero",
tracks.Name AS "Pista",
employees.FirstName AS "Nombre empleado",
employees.Title AS "Titulo del empleado"
FROM media_types INNER JOIN tracks
ON media_types.MediaTypeId = tracks.MediaTypeId INNER JOIN genres
ON tracks.GenreId=genres.GenreId INNER JOIN invoice_items
ON tracks.TrackId= invoice_items.TrackId INNER JOIN invoices
ON invoice_items.InvoiceId=invoices.InvoiceId INNER JOIN customers
ON invoices.CustomerId= customers.CustomerId INNER JOIN employees
ON customers.SupportRepId= employees.EmployeeId
GROUP BY media_types.Name
HAVING  SUM(invoices.Total) > 25;


--///////////////////    CONSULTA 4   //////////////////
-- Proporcione una consulta en la que se muestren los generos y la cantidad de pistas que contienen,
-- Tambien se debe mencionar el medio y las listas de reproducciones a las que pertenece.
-- Pero se debe de tener un control del conteo de las pistas que sean mayores a 100.
select genres.Name AS "Genero",
artists.Name AS "Artista", 
COUNT (albums.ArtistId) AS "Numb pista",
media_types.Name AS "Tipo de medio",
playlists.Name AS "Lista de reproduccion"
FROM artists INNER JOIN albums
ON artists.ArtistId= albums.ArtistId INNER JOIN tracks
ON albums.AlbumId = tracks.AlbumId INNER JOIN genres 
ON tracks.GenreId= genres.GenreId INNER JOIN media_types
ON media_types.MediaTypeId = tracks.MediaTypeId INNER JOIN playlist_track
ON tracks.TrackId= playlist_track.TrackId INNER JOIN playlists
ON playlist_track.PlaylistId= playlists.PlaylistId
GROUP BY genres.Name
HAVING COUNT (albums.ArtistId) >100;


-- //////////////////////   Consulta 5    /////////////////
--Se desea saber la cantidad de reportes que realizaron los empleados que vendieron pistas del Santana

select artists.Name AS "Artista",  
employees.LastName,
count(customers.SupportRepId)AS "Cantidad de reportes",
employees.EmployeeId
from artists INNER JOIN albums
ON artists.ArtistId = albums.ArtistId INNER JOIN tracks
ON albums.AlbumId= tracks.AlbumId INNER JOIN invoice_items
ON tracks.TrackId=invoice_items.TrackId INNER JOIN invoices
ON invoice_items.InvoiceId=invoices.InvoiceId INNER JOIN customers
ON invoices.CustomerId= customers.CustomerId INNER JOIN employees
ON customers.SupportRepId= employees.EmployeeId
WHERE artists.Name like 'Santana'
GROUP BY customers.SupportRepId;

-- //////////////////////   Consulta 6    /////////////////

--Proporcione una consulta del con el nombre e Id del cliente que haya comprado una o más pistas esta debe incluir 
--el total de pistas aquiridas (debe ser verificada con la cantidad de Linea de Factura), 
--el precio total de dichas pistas (esta debe ser verificada con el total de la factura), 
--en que pais fue adquirida la compra, 
--el total de bytes de las pistas y el agente que antendio la venta pero tambien se debe de verificar a que artista pertenece cada venta

SELECT * FROM tracks;
SELECT * FROM invoices;
SELECT * FROM invoice_items; 
SELECT * FROM customers;
SELECT * FROM employees;

SELECT i.InvoiceId,
        c.CustomerId,
        c.LastName AS Cliente,
        COUNT(i.InvoiceId) AS Total_Pistas,        
        SUM(t.UnitPrice) AS Precio_Total,        
        i.BillingCountry AS Pais,
        SUM(t.Bytes) AS Total_Bytes,
        SUM(il.Quantity) AS Cantidad_Pistas,
        e.LastName AS Agente,
        i.Total AS Total_Factura,
        a.Name AS Artista
FROM artists a INNER JOIN albums ab
ON a.ArtistId  = ab.ArtistId INNER JOIN tracks t
ON ab.AlbumId= t.AlbumId INNER JOIN invoice_items il
ON t.TrackId=il.TrackId INNER JOIN invoices i
ON il.InvoiceId=i.InvoiceId INNER JOIN customers c
ON i.CustomerId= c.CustomerId INNER JOIN employees e
ON c.SupportRepId= e.EmployeeId
GROUP BY  i.InvoiceId;

-- //////////////////////   Consulta 7    /////////////////
--Que empleado vendió el genero JAzZ en el año 2009, muestre la cantidad total vendida del género
SELECT  employees.EmployeeId,
        employees.LastName,
        employees.FirstName, 
        SUBSTR(invoices.InvoiceDate, 0,5) AS Año,
        genres.Name AS Genero,
        COUNT(genres.Name) AS Total_Genero
FROM employees 
INNER JOIN customers 
ON employees.EmployeeId = customers.SupportRepId
INNER JOIN invoices 
ON customers.CustomerId = invoices.CustomerId
INNER JOIN invoice_items 
ON invoice_items.InvoiceId = invoices.InvoiceId
INNER JOIN tracks
ON tracks.TrackId = invoice_items.TrackId
INNER JOIN albums 
ON albums.AlbumId = tracks.AlbumId
INNER JOIN artists 
ON artists.ArtistId = albums.ArtistId
INNER JOIN genres
ON genres.GenreId = tracks.GenreId
WHERE invoices.InvoiceDate LIKE '2009%' AND genres.Name = 'Jazz'
GROUP BY employees.EmployeeId
ORDER BY COUNT(genres.Name) DESC;



-- //////////////////////   Consulta 8    /////////////////
--Proporcione una consulta que muestre las tres pistas más vendidas en el año 2011, 
--incluya el Id de la factura y el nombre del album,artista, genero y tipo de medio al que pertenece.
SELECT  i.InvoiceId,
        I.CustomerId,
        t.Name AS Nombre_Pista, 
        COUNT(it.invoiceLineId) AS Total_Comprado, 
        SUBSTR(i.invoiceDate, 0,5) AS Año,
        a.Title AS Album,
        ar.Name AS Nombre_Artista,
        g.Name AS Género,
        mt.Name AS Tipo_Medio
FROM tracks t
INNER JOIN invoice_items it
ON t.TrackId = it.TrackId
INNER JOIN invoices i
ON it.InvoiceId = i.InvoiceId
INNER JOIN albums a
ON a.AlbumId = t.AlbumId
INNER JOIN artists ar
ON ar.ArtistId = a.ArtistId
INNER JOIN genres g
ON g.GenreId = t.GenreId
INNER JOIN media_types mt
ON mt.MediaTypeId = t.MediaTypeId
WHERE i.invoiceDate LIKE '2011%'
GROUP BY t.Name 
ORDER BY COUNT(it.invoiceLineId)
DESC LIMIT 3;



-- //////////////////////   Consulta 9    /////////////////
--Prporcione una consulta que muestre a los clientes que compraron más de 5 veces el tipo de media MPEG audio file,
--mostrando el total de tracks adquiros por el género Rock en el año 2010 debe mostrar el nombre del agente que atendio al cliente
SELECT * FROM media_types;
SELECT * FROM tracks;
SELECT * FROM genres;
SELECT * FROM invoice_items;
SELECT * FROM invoices; 
SELECT * FROM customers;
SELECT * FROM employees;

SELECT  customers.CustomerId,
        customers.LastName AS Cliente,
        COUNT(tracks.MediaTypeId) Total_Tracks,
        genres.Name AS Genero,
        SUBSTR(invoices.invoiceDate, 0,5) AS Año,
        media_types.Name AS Tipo_Medio,
        employees.LastName AS Agente
FROM media_types
INNER JOIN tracks
ON media_types.MediaTypeId = tracks.MediaTypeId
INNER JOIN genres
ON genres.GenreId = tracks.GenreId
INNER JOIN invoice_items
ON invoice_items.TrackId = tracks.TrackId
INNER JOIN invoices
ON invoices.InvoiceId = invoice_items.InvoiceId
INNER JOIN customers
ON customers.CustomerId = invoices.CustomerId
INNER JOIN employees 
ON employees.EmployeeId = customers.SupportRepId
WHERE invoices.InvoiceDate LIKE '2010%' AND media_types.Name = 'MPEG audio file' AND genres.Name = 'Rock'
GROUP BY  customers.CustomerId
HAVING COUNT(media_types.MediaTypeId) > 5;



-- //////////////////////   Consulta 10    /////////////////
--Proporcione una consulta que muestre el tracks y bytes ocupados en la Lista de Reproduccion Music 
--cuyo album sea Balls to the Wall y qué cliente adquirio dicha lista con ese track
SELECT DISTINCT playlists.PlaylistId,
        playlists.Name,
        tracks.TrackId,
        tracks.Name,
        tracks.Bytes,
        albums.Title,
        customers.LastName
FROM playlists
INNER JOIN playlist_track
ON playlists.PlaylistId = playlist_track.PlaylistId
INNER JOIN tracks
ON tracks.TrackId = playlist_track.TrackId
INNER JOIN albums
ON albums.AlbumId = tracks.TrackId
INNER JOIN invoice_items
ON invoice_items.TrackId = tracks.TrackId
INNER JOIN invoices
ON invoices.InvoiceId = invoice_items.InvoiceId
INNER JOIN customers
ON customers.CustomerId = invoices.CustomerId
WHERE playlists.Name = 'Music' AND albums.Title = 'Big Ones'
--Cuantas listas de reproduccion tine cada cliente