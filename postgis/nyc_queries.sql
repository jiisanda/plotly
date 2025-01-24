select n.name as neighborhood_name, sum(c.popn_total) as population, 100*sum(c.popn_white)/sum(c.popn_total) as white_pct, 100*sum(c.popn_black)/sum(c.popn_total) as black_pct from nyc_neighborhoods as n join nyc_census_blocks as c on ST_Intersects(n.geom, c.geom) where n.boroname = 'Manhattan' group by n.name order by white_pct desc;

select n.name as neighborhood_name, sum(c.popn_total) as population, 100*sum(c.popn_white)/sum(c.popn_total) as white_pct, 100*sum(c.popn_black)/sum(c.popn_total) as black_pct from nyc_neighborhoods as n join nyc_census_blocks as c on ST_Intersects(n.geom, c.geom) where n.boroname = 'Manhattan' group by n.name order by white_pct desc;

select s.name, n.name, n.boroname from nyc_neighborhoods as n join nyc_subway_stations as s on ST_Contains( n.geom, s.geom ) where s.name = 'Broad St';

select ST_Distance(a.geom, b.geom) from nyc_streets a, nyc_streets b where b.name = 'Columbus Cir' and a.name = 'Fulton Ave';

select ST_Distance(a.geom, b.geom) from nyc_streets a, nyc_streets b where a.name = 'Columbus Cir' and b.name = 'Fulton Ave';

select ST_Intersects(l,p), ST_Touches(l,p), ST_Contains(l,p), ST_Disjoint(l,p), ST_Overlaps(l,p), ST_Crosses(l,p), ST_within(l,p) from (select 'LINESTRING(0 0, 2 2)'::geometry as l, 'POINT(1 1)'::geometry as p) as subquery;

select Sum(popn_total) from nyc_census_blocks where ST_DWithin( geom, ST_GeomFromText('POINT(586782 4504202)', 26918), 50 );

select name, boroname from nyc_neighborhoods where ST_Intersects( geom, ST_GeomFromText('POINT(586782 4504202)', 26918) );

select name, ST_Transform(geom,4326) from nyc_streets where ST_DWithin( geom, ST_GeomFromText('POINT(583571 4506714)',26918), 10 );

select name from nyc_streets where ST_DWithin( geom, ST_GeomFromText('POINT(583571 4506714)',26918), 10 );

select ST_Transform(geom, 4326), name, boroname from nyc_neighborhoods where ST_Intersects( geom, ST_GeomFromText( 'POINT(583571 4506714)', 26918 ) );

select name, boroname from nyc_neighborhoods where ST_Intersects( geom, ST_GeomFromText( 'POINT(583571 4506714)', 26918 ) );

SELECT ST_Transform(geom, 4326), name from nyc_subway_stations where ST_Equals( geom, '0101000020266900000EEBD4CF27CF2141BC17D69516315141' );

SELECT name from nyc_subway_stations where ST_Equals( geom, '0101000020266900000EEBD4CF27CF2141BC17D69516315141' );

SELECT ST_Transform(geom, 4326), name, geom FROM nyc_subway_stations WHERE name='Broad St';

SELECT name, geom FROM nyc_subway_stations WHERE name='Broad St';

SELECT Sum(ST_Area(geom)) / 4047 FROM nyc_census_blocks WHERE boroname='Manhattan';

SELECT Sum(ST_Area(geom)) / 4047 FROM nyc_census_blocks WHERE boroname='Manhattan';

SELECT ST_Transform(geom, 4326), ST_AsGeoJSON(geom, 0) FROM nyc_subway_stations WHERE name='Broad St';

SELECT ST_AsGeoJSON(geom, 0) FROM nyc_subway_stations WHERE name='Broad St';

SELECT ST_AsText(geom) FROM geometrics WHERE name='Point';

SELECT ST_AsText(geom) FROM geometrics WHERE name='Point';

select Sum(popn_total) 
from nyc_census_blocks
where ST_DWithin(
geom,
ST_GeomFromText('POINT(586782 4504202)', 26918),
50
);

select 
    100.0*SUM(popn_white)/SUM(popn_total) as white_pct,
    100.0*SUM(popn_black)/SUM(popn_total) as black_pct,
    sum(popn_total) as popn_total
from nyc_census_blocks;

select 
    100*sum(c.popn_white)/sum(c.popn_total) as white_pct,
    100*sum(c.popn_black)/sum(c.popn_total) as black_pct,
    sum(c.popn_total) as popn_total
from nyc_census_blocks as c join nyc_subway_stations as s on st_dwithin(c.geom, s.geom, 200)
where strpos(s.routes, 'A') > 0;

select s.name, s.routes
from nyc_neighborhoods as n join nyc_subway_stations as s on st_contains(n.geom, s.geom)
where n.name = 'Little Italy'; 

--- make the table tracts 
create table nyc_census_tract_geoms as
    select st_union(geom) as geom,
           substr(blkid,1,11) as tractid
from nyc_census_blocks
group by tractid;

--- index the tractid
create index nyc_census_tract_geoms_tractid_idx on nyc_census_tract_geoms (tractid);

select 100.0*sum(c.edu_graduate_dipl)/sum(c.edu_total) as grad_pct, n.name, n.boroname
from nyc_neighborhoods as n join nyc_census_tracts as c on st_intersects(n.geom, c.geom)
where c.edu_total > 0
group by n.name, n.boroname
order by grad_pct desc
limit 10;

