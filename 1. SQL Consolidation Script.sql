use Vegetarianventures; 
ALTER TABLE `VWR INTERNAL Vegetarianventures recipeList` ADD `idid` INT(9) NOT NULL AUTO_INCREMENT AFTER `url`, ADD UNIQUE `indexidid` (`idid`);
UPDATE `VWR INTERNAL Vegetarianventures recipeList` SET idid=idid+848000000;
CREATE TABLE `Vegetarianventures`.`temp` ( `id` INT(9) NOT NULL , `url` TEXT NOT NULL ) ENGINE = InnoDB;
CREATE TABLE `Vegetarianventures`.`temp2` ( `id` INT(9) NOT NULL , `url` TEXT NOT NULL ) ENGINE = InnoDB;
insert into temp (select min(idid),url  from `VWR INTERNAL Vegetarianventures recipeList` group by url having count(url) >1);
insert into temp2(select min(idid),url  from `VWR INTERNAL Vegetarianventures recipeList` group by url having count(url) =1);

insert into Group10.Recipes(id,name,url,image,prepTime,cookTime,recipeYield,datePublished,recipeCourse,recipeCategory,aggregateRating,aggregateCount)
(select idid,name,url,image,prepTime,cookTime,recipeYield,datePublished,recipeCourse,recipeCategory,aggregateRating,aggregateCount
from `VWR INTERNAL Vegetarianventures recipeList` where idid in (select id from temp2))
UNION All
(select idid,name,url,image,prepTime,cookTime,recipeYield,datePublished,recipeCourse,recipeCategory,aggregateRating,aggregateCount
from `VWR INTERNAL Vegetarianventures recipeList` where idid in (select id from temp));

Insert into Group10.Ingredients(id,source_ind,ingredient)(select r.idid, i.source_index,i.recipeIngredient
FROM Vegetarianventures.`VWR INTERNAL Vegetarianventures ingredients`  i  
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeList` r on i.parent_row_id = r.row_id);

Insert into Group10.Instructions(id,source_ind,instruction)(select r.idid, i.source_index,i.recipeInstruction
FROM  Vegetarianventures.`VWR INTERNAL Vegetarianventures howToStep` i  
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeList` r on i.parent_row_id = r.row_id);



insert into Group10.Nutrition(id,calories,proteinContent,fatContent,carbohyderateContent,fiberContent,sugarContent)
(select idid,calories,proteinContent,fatContent,carbohydrateContent,fiberContent,sugarContent
 from `VWR INTERNAL Umamigirl recipeLink` where idid in (select id from temp))
 Union ALL
 (select idid,calories,proteinContent,fatContent,carbohydrateContent,fiberContent,sugarContent
 from `VWR INTERNAL Umamigirl recipeLink` where idid in (select id from temp2));

ALTER TABLE `VWR INTERNAL Vegetarianventures ingredients` ADD `groupName` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL AFTER `segment`;
Update Vegetarianventures.`VWR INTERNAL Vegetarianventures ingredients` t1
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeIngredients` c
on c.row_id=t1.parent_row_id 
set t1.groupName=c.groupName;

Insert into Group10.Ingredients(id,source_ind,groupName,ingredient)(select s.idid, i.source_index,i.groupName,i.recipeIngredient
FROM Vegetarianventures.`VWR INTERNAL Vegetarianventures ingredients`  i  
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeIngredients` r on i.parent_row_id = r.row_id
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeList` s on s.row_id=r.parent_row_id);


ALTER TABLE `VWR INTERNAL Vegetarianventures howToStep` ADD `section` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL AFTER `segment`;
Update Vegetarianventures.`VWR INTERNAL Vegetarianventures howToStep` c
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeInstructions` t1
on t1.row_id=c.parent_row_id 
set c.section=t1.howToSection;

Insert into Group10.Instructions(id,source_ind,section,instruction)(select s.idid, i.source_index,i.section,i.recipeInstruction
FROM Vegetarianventures.`VWR INTERNAL Vegetarianventures howToStep`  i  
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeInstructions` r on i.parent_row_id = r.row_id
inner join Vegetarianventures.`VWR INTERNAL Vegetarianventures recipeList` s on s.row_id=r.parent_row_id);

Next Week

QUERIES OF INGREDIENT TABLE

QTY COLUMN
This query will separate the quantity from the ingredient string. E.g.  2 Liter orange juice we will get 2 from this query 
UPDATE ingredients SET QTY=REGEXP_SUBSTR(ingredient,'^[0-9/. ]+') WHERE ingredient REGEXP '^[0-9/. ]+(.*)$'

UNIT COLUMN
This query will separate the unit from ingredient string. E.g.  2 Liter orange juice we will get liter from this query
UPDATE ingredients SET UNIT= REGEXP_SUBSTR(	SUBSTRING(ingredient, POSITION(QTY in ingredient)+LENGTH(QTY))	,	'(?(?=.*[\,\:])[^A-Za-z]*|[A-Za-z]*)'	) WHERE QTY IS NOT NULL;

ING COLUMN
This query will separate all the ingredients from ingredient string. E.g.  2 Liter orange juice we will get orange juice from this query
UPDATE ingredients SET Ing= REGEXP_SUBSTR(	SUBSTRING(ingredient, POSITION(Unit in ingredient)+LENGTH(Unit)) , '(?(?=.*[\,\:])(^(.+?),|\\s*:.*)|^[^ ]* (.*))' ) WHERE Unit IS NOT NULL;

This query will remove the round brackets and the string written in it. E.g., 1 ounce vodka (optional) in this string (optional) will be removed.
UPDATE ingredients SET Ing= REGEXP_SUBSTR(Ing , '\([^()]*\)' );

ACTION COLUMN
This query will extract all actions. E.g., Garnish: Orange wheel in this string Garnish: will be extracted 
UPDATE ingredients SET action=REGEXP_SUBSTR(ingredient,'(^(.+?):|\\s*,.*)')

PROCESS COLUMN
This query will extract all the processes. e.g., Cracked pepper from this string Cracked will be extracted 
UPDATE ingredients SET process=REGEXP_SUBSTR(ingredient,'[A-Za-z]+ed\ +');

PROCESSED ING COLUMN
This query will remove all processes from the Ing column e.g., Cracked pepper from this string we will get pepper
UPDATE ingredients SET P_Ing=REGEXP_SUBSTR (Ing,'(? (?= . *[A-Za-z]+ed\ +)((?<=ed).*[^ed]+)|[^\n]+)');
UPDATE ingredients SET P_Ing=REGEXP_SUBSTR (P_Ing , '(?(?=^(ed))\s(.*)|[^\n]+)' );
UPDATE ingredients SET P_Ing=REGEXP_SUBSTR (P_Ing , '(?(?=^(d))\s(.*)|[^\n]+)' );
