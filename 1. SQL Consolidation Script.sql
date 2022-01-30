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
