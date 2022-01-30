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
