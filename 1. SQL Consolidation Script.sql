use Tinnedtomatoes; 
ALTER TABLE `VWR INTERNAL Tinnedtomatoes-2 recipeList` ADD `idid` INT(9) NOT NULL AUTO_INCREMENT AFTER `template_url`, ADD UNIQUE `indexidid` (`idid`);
UPDATE `VWR INTERNAL Tinnedtomatoes-2 recipeList` SET idid=idid+849000000;
CREATE TABLE `Tinnedtomatoes`.`temp` ( `id` INT(9) NOT NULL , `url` TEXT NOT NULL ) ENGINE = InnoDB;
CREATE TABLE `Tinnedtomatoes`.`temp2` ( `id` INT(9) NOT NULL , `url` TEXT NOT NULL ) ENGINE = InnoDB;
insert into temp (select min(idid),template_url  from `VWR INTERNAL Tinnedtomatoes-2 recipeList` group by template_url having count(template_url) >1);
insert into temp2(select min(idid),template_url  from `VWR INTERNAL Tinnedtomatoes-2 recipeList` group by template_url having count(template_url) =1);

insert into Group10.Recipes(id,name,url,image,author,prepTime,cookTime,totalTime,recipeYield)
(select idid,name,url,image,author,prepTime,cookTime,totalTime,recipeYield
from `VWR INTERNAL Tinnedtomatoes-2 recipeList` where idid in (select id from temp2))
UNION All
(select idid,name,url,image,author,prepTime,cookTime,totalTime,recipeYield
from `VWR INTERNAL Tinnedtomatoes-2 recipeList` where idid in (select id from temp));

Insert into Group10.recipeIngredients(id,source_ind,ingredient)(select r.idid, i.source_index,i.recipeIngredient
FROM Tinnedtomatoes.`VWR INTERNAL Tinnedtomatoes-2 recipeIngredients`i  
inner join Tinnedtomatoes.`VWR INTERNAL Tinnedtomatoes-2 recipeList` r on i.parent_row_id = r.row_id);

Insert into Group10.Instructions(id,source_ind,instruction)(select r.idid, i.source_index,i.recipeInstruction
FROM  Tinnedtomatoes.`VWR INTERNAL Tinnedtomatoes-2 recipeInstructions` i  
inner join Tinnedtomatoes.`VWR INTERNAL Tinnedtomatoes-2 recipeList` r on i.parent_row_id = r.row_id);



insert into Group10.Nutrition(id,calories,proteinContent,fatContent,carbohyderateContent,fiberContent,sugarContent)
(select idid,calories,proteinContent,fatContent,carbohydrateContent,fiberContent,sugarContent
 from `VWR INTERNAL Umamigirl recipeLink` where idid in (select id from temp))
 Union ALL
 (select idid,calories,proteinContent,fatContent,carbohydrateContent,fiberContent,sugarContent
 from `VWR INTERNAL Umamigirl recipeLink` where idid in (select id from temp2));
