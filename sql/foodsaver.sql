.open FOODSAVER.DB

-- make views for all the ingredients of a recipe <TODO>

PRAGMA FOREIGN_KEYS = ON;

CREATE TABLE RECIPE
(
	Recipe_name VARCHAR(30) NOT NULL UNIQUE,
	Prep_time INT NOT NULL,
	Cook_time INT NOT NULL,
	Picture_link VARCHAR(300) UNIQUE,
	Instruction VARCHAR(10000) NOT NULL UNIQUE,
	Date_added DATE NOT NULL,
	
	PRIMARY KEY (Recipe_name),
	
	CONSTRAINT RCK1
	CHECK(Cook_time > 0),
	
	CONSTRAINT RCK2
	CHECK(Prep_time > 0)
);

CREATE TABLE INGREDIENT
(
	Ingredient_name VARCHAR(30) NOT NULL UNIQUE,
	Ingredient_category VARCHAR(30),
	
	PRIMARY KEY (Ingredient_name)
	
	CONSTRAINT ICK1
	CHECK(Ingredient_category in('Dairy', 'Meats', 'Oils', 'Soup', 'Beverages',
	'Vegetables', 'Fruits', 'Spices', 'Fish', 'Baking & Grains', 'Seafood', 'Added Sweetener',
	'Seasonings', 'Nuts', 'Condiments', 'Desserts & Snacks', 'Dairy Alternatives', 'Legumes',
	'Sauces', 'Alcohol', 'Liquids', 'Eggs'))
);

CREATE TABLE USER
(
	Account_name VARCHAR(30) NOT NULL UNIQUE,
	Password VARCHAR(15) NOT NULL,
	
	PRIMARY KEY (Account_name)
);

CREATE TABLE SHOPPING_LIST
(
	Shopping_listname VARCHAR(30) NOT NULL,
	SL_date DATE NOT NULL,
	Account_name VARCHAR(30) NOT NULL,
	
	PRIMARY KEY (Shopping_listname, Account_name),
	
	CONSTRAINT SLFK1
	FOREIGN KEY(Account_name)
	REFERENCES USER(Account_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

CREATE TABLE NUTRITION
(
	Nutritional_name VARCHAR(30) NOT NULL,
	Recipe_name VARCHAR(30) NOT NUll,
	Nutritional_value INT NOT NULL DEFAULT 0,
	Nutrition_type VARCHAR(10),
	
	PRIMARY KEY (Nutritional_name, Recipe_name),
	
	CONSTRAINT NFK1
	FOREIGN KEY(Recipe_name)
	REFERENCES RECIPE(Recipe_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT NCK1
	CHECK(Nutritional_value >= 0)
	
	CONSTRAINT NCK2
	CHECK (Nutritional_name in ('Calories', 'Carbs', 'Protein', 'Sodium', 'Fat', 'Cholesterol'))
	
	CONSTRAINT NCK3
	CHECK (Nutrition_type in ('kcal', 'g', 'mg'))
);

CREATE TABLE RATING
(
	Star_num INT,
	Recipe_name VARCHAR(30) NOT NULL,
	Account_name VARCHAR(30) NOT NULL,
	
	PRIMARY KEY (Recipe_name, Account_name),
	
	CONSTRAINT RFK1
	FOREIGN KEY(Recipe_name)
	REFERENCES RECIPE(Recipe_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT RFK2
	FOREIGN KEY(Account_name)
	REFERENCES USER(Account_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT RCK1
	CHECK(Star_num >= 1 AND Star_num <= 5)
);

CREATE TABLE RECIPE_CONTENT
(
	Recipe_name VARCHAR(30) NOT NULL,
	Ingredient_name VARCHAR(30) NOT NULL,
	Quantity VARCHAR(30) NOT NULL DEFAULT 0,
	
	PRIMARY KEY (Recipe_name, Ingredient_name),
	
	CONSTRAINT RCFK1
	FOREIGN KEY(Recipe_name)
	REFERENCES RECIPE(Recipe_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT RCFK2
	FOREIGN KEY (Ingredient_name)
	REFERENCES INGREDIENT(Ingredient_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT RCCK1
	CHECK(Quantity >= 0)
);

CREATE TABLE SHOPPING_LIST_CONTENT
(
	Account_name VARCHAR(30) NOT NULL,
	Ingredient_name VARCHAR(30) NOT NULL,
	Shopping_listname VARCHAR(30) NOT NULL,
	Quantity INT NOT NULL DEFAULT 0,
	
	PRIMARY KEY (Account_name, Ingredient_name, Shopping_listname),
	
	CONSTRAINT SLCFK1
	FOREIGN KEY(Account_name, Shopping_listname)
	REFERENCES SHOPPING_LIST(Account_name, Shopping_listname)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT SLCFK2
	FOREIGN KEY(Ingredient_name)
	REFERENCES INGREDIENT(Ingredient_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT SLCCK1
	CHECK(Quantity >= 0)
);

CREATE TABLE FAVORITE
(
	Recipe_name VARCHAR(30) NOT NULL,
	Account_name VARCHAR(30) NOT NULL,
	Date_added DATE NOT NULL,
	
	PRIMARY KEY (Recipe_name, Account_name),
	
	CONSTRAINT FAFK1
	FOREIGN KEY (Recipe_name)
	REFERENCES RECIPE(Recipe_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FAFK2
	FOREIGN KEY (Account_name)
	REFERENCES USER(Account_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

CREATE TABLE FRIEND
(
	Account_name VARCHAR(30) NOT NULL,
	Friends_account_name VARCHAR(30) NOT NULL,
	
	PRIMARY KEY (Account_name, Friends_account_name)
	
	CONSTRAINT FFK1
	FOREIGN KEY (Account_name)
	REFERENCES USER(Account_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FFK2
	FOREIGN KEY (Friends_account_name)
	REFERENCES USER(Account_name)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

INSERT INTO RECIPE VALUES
(
	'Spaghetti with Meatballs',
	60,
	15,
	'http://images.media-allrecipes.com/userphotos/600x600/754675.jpg',
	'1.) Heat the olive oil in a large saucepan over medium heat, and cook the onion
	until lightly brown. Mix in 2 cloves garlic, and cook 1 minute. Stir in crushed
	tomatoes, tomato paste, water, sugar, 1/2 the oregano, and bay leaf. Season with salt
	and pepper. Bring to a boil, reduce heat to low, and simmer while preparing meatballs.
	2.) In a bowl, mix the ground round, bread crumbs, remaining oregano, remaining garlic,
	parsley, eggs, and cheese. Season with salt and pepper. Roll into 1 inch balls, and drop into
	the sauce. Cook 40 minutes in the sauce, or until internal temperature of meatballs
	reaches a minimum of 160 degrees F (72 degrees C).
	3.) Bring a large pot of lightly salted water to a boil, and stir in the spaghetti.
	Cook 8 to 10 minutes until al dente, and drain. Serve the meatballs and sauce over the
	cooked spaghetti.',
	'2017-03-04'
),
(
	'Fish Tacos',
	20,
	40,
	'http://images.media-allrecipes.com/userphotos/250x250/317051.jpg',
	'1.) To make beer batter; In a large bowl, combine Flour, cornstarch, baking powder,
	and salt. Blend egg and beer, then quickly stir into the Flour mixture.
	2.) To make white sauce: In a medium bowl, mix together yogurt and mayonnaise. Gradually
	stir in fresh lime juice until consistency is slightly runny. Season with jalapeno,
	capers, oregano, cumin, dill, and cayenne.
	3.) Heat oil in deep-fryer to 375 degrees F (190 degrees C).
	4.) Dust fish pieces lightly with Flour. Dip into ber batter, and fry until crisp
	and golden brown. Drain on paper towels. Lightly fry tortillas; not to crisp. To serve,
	place fried fish in a tortilla, and top with shredded cabbage, and white sauce.',
	'2017-03-04'
),
(
	'Popovers',
	20,
	20,
	'http://images.media-allrecipes.com/userphotos/250x250/222537.jpg',
	'1.) Preheat over to 450 degrees F (230 degrees C). Grease and Flour six 6-once custard cups.
	2.) In a medium bowl beat eggs slightly, Beat in Flour, milk and salt until just smooth; being
	careful not to overbeat. Fill custard cups 1/2 full.
	3.) Bake at 450 degrees F (230 degrees C) for 20 minutes. Decrease oven temperature at 350 degrees F
	(175 degrees C) and bake for 20 minutes more. Immeadiately remove from cups and serve piping hot.',
	'2017-03-04'
)
;

INSERT INTO INGREDIENT VALUES
('Olive Oil', 'Oils'),
('Onions', 'Vegetables'),
('Garlics', 'Vegetables'),
('Tomatoes', 'Vegetables'),
('Tomato Paste', 'Seasonings'),
('Cold Water', 'Liquids'),
('Sugar', 'Added Sweetener'),
('Oregano', 'Vegetables'),
('Dried Bay Leaf', 'Seasonings'),
('Ground Beef', 'Meats'),
('Bread Crumbs', 'Baking & Grains'),
('Parsley', 'Vegetables'),
('Parmesan Cheese', 'Dairy'),
('Spaghetti Pasta', 'Baking & Grains'),
('All-purpose Flour', 'Baking & Grains'),
('Cornstarch', 'Baking & Grains'),
('Baking Powder', 'Baking & Grains'),
('Beer', 'Alcohol'),
('Yogurt', 'Dairy Alternatives'),
('Mayonnaise', 'Condiments'),
('Lime', 'Seasonings'),
('Capers', 'Vegetables'),
('Cumin', 'Seasonings'),
('Dill Weed', 'Seasonings'),
('Cayenne Pepper', 'Seasonings'),
('Cod Fillets', 'Fish'),
('Corn Tortillas', 'Baking & Grains'),
('Cabbage', 'Vegetables'),
('Skinless, boneless chicken breast halves', 'Meats'),
('Dry mustard', 'Spices'),
('Salt', 'Seasonings'),
('Hot water', 'Liquids'),
('White wine vinegar', 'Condiments'),
('Halved seedless red grapes', 'Fruits'),
('Coarsely chopped pecans', 'Legumes'),
('Coarsely crumbled blue cheese', 'Dairy'),
('Ground beef', 'Meats'),
('Italian sausage', 'Meats'),
('Tomato-based chili sauce', 'Sauces'),
('Pepper', 'Seasonings'),
('Prepared graham cracker crust', 'Baking & Grains'),
('Cream cheese, softened', 'Dairy'),
('White sugar', 'Added Sweetener'),
('Frozen whipped topping, thawed', 'Dairy'),
('Cherry pie filling', 'Desserts & Snacks'),
('Jalapeno pepper', 'Vegetables'),
('Rice vinegar', 'Condiments'),
('Dijon mustard', 'Condiments'),
('Black pepper', 'Condiments'),
('Vegetable oil', 'Oils'),
('Scallops', 'Seafood'),
('Sea salt', 'Condiments'),
('Cayenne pepper', 'Condiments'),
('Orange', 'Fruits'),
('Baking powder', 'Baking & Grains'),
('White suger', 'Added Sweetener'),
('Milk', 'Dairy'),
('Egg', 'Eggs'),
('Butter', 'Dairy'),
('Strawberries', 'Fruits'),
('Brown sugar', 'Added Sweetener'),
('Balsamic vinegar', 'Condiments'),
('Filet mignon', 'Meats'),
--added by alex
----------------------------------------------------------------------------
('Garlic powder','Seasonings'),
('Boneless round steak','Meats'),
('Broccoli Floret','Vegetables'),
('Soy Sauce','Sauces'),
('Rice','Baking & Grains'),
('Potato','Vegetables'),
('Baby Carrot','Vegetables'),
('italian Dressing','Oils')
-------------------------------------------------------------------------------
;

--For Spaghetti with MeatBalls
INSERT INTO RECIPE_CONTENT VALUES
('Spaghetti with Meatballs', 'Olive Oil', '3 tablespoons'),
('Spaghetti with Meatballs', 'Onions', '3/4 cup'),
('Spaghetti with Meatballs', 'Garlics', '4 cloves'),
('Spaghetti with Meatballs', 'Tomatoes', '16 ounces'),
('Spaghetti with Meatballs', 'Tomato Paste', '6 ounces'),
('Spaghetti with Meatballs', 'Cold Water', '1 cup'),
('Spaghetti with Meatballs', 'Sugar', '1/2 cup'),
('Spaghetti with Meatballs', 'Oregano', '1/4 cup'),
('Spaghetti with Meatballs', 'Dried Bay Leaf', '1'),
('Spaghetti with Meatballs', 'Salt', 'to taste'),
('Spaghetti with Meatballs', 'Pepper', 'to taste'),
('Spaghetti with Meatballs', 'Ground Beef', '1 pound'),
('Spaghetti with Meatballs', 'Bread Crumbs', '1/2 cup'),
('Spaghetti with Meatballs', 'Egg', '2'),
('Spaghetti with Meatballs', 'Parmesan Cheese', '1/2'),
('Spaghetti with Meatballs', 'Spaghetti Pasta', '16 ounce')
;

--For Fish Tacos
INSERT INTO RECIPE_CONTENT VALUES
('Fish Tacos', 'All-purpose Flour', '1 Flour'),
('Fish Tacos', 'Cornstarch', '2 tablespoons'),
('Fish Tacos', 'Baking Powder', '1 teaspoon'),
('Fish Tacos', 'Egg', '1'),
('Fish Tacos', 'Salt', '1/2 teaspoon'),
('Fish Tacos', 'Beer', '1 cup'),
('Fish Tacos', 'Yogurt', '1/2 cup'),
('Fish Tacos', 'Mayonnaise', '1/2 cup'),
('Fish Tacos', 'Lime', '1'),
('Fish Tacos', 'Capers', '1 teaspoon'),
('Fish Tacos', 'Cumin', '1/2 teaspoon'),
('Fish Tacos', 'Dill Weed', '1/2 teaspoon'),
('Fish Tacos', 'Cayenne Pepper', '1 teaspoon'),
('Fish Tacos', 'Cod Fillets', '3 ounces'),
('Fish Tacos', 'Corn Tortillas', '12 ounces'),
('Fish Tacos', 'Cabbage', '1/2')
;

--For Popovers
INSERT INTO RECIPE_CONTENT VALUES
('Popovers', 'All-purpose Flour', '1 cup'),
('Popovers', 'Egg', '2'),
('Popovers', 'Milk', '1 cup'),
('Popovers', 'Salt', '1/2 teaspoon')
;

--For Spaghetti with MeatBalls
INSERT INTO NUTRITION VALUES
('Calories', 'Spaghetti with Meatballs', 572, 'kcal'),
('Fat', 'Spaghetti with Meatballs', 17, 'g'),
('Carbs', 'Spaghetti with Meatballs', 80, 'g'),
('Protein', 'Spaghetti with Meatballs', 28, 'g'),
('Cholesterol', 'Spaghetti with Meatballs', 87, 'mg'),
('Sodium', 'Spaghetti with Meatballs', 1177, 'mg')
;

--For Fish Tacos
INSERT INTO NUTRITION VALUES
('Calories', 'Fish Tacos', 409, 'kcal'),
('Fat', 'Fish Tacos', 19, 'g'),
('Carbs', 'Fish Tacos', 43, 'g'),
('Protein', 'Fish Tacos', 17, 'g'),
('Cholesterol', 'Fish Tacos', 54, 'mg'),
('Sodium', 'Fish Tacos', 407, 'mg'),
('Calories', 'Popovers', 120, 'kcal'),
('Fat', 'Popovers', 2, 'g'),
('Carbs', 'Popovers', 18, 'g'),
('Protein', 'Popovers', 5, 'g'),
('Cholesterol', 'Popovers', 65, 'mg'),
('Sodium', 'Popovers', 234, 'mg')
;


INSERT INTO USER VALUES
('SaltBae', 'SweetBabe'),
('Rin', 'ILoveHAWTGUYS'),
('LanY', 'Asian4Lyf')
;

INSERT into RATING values
(4, 'Spaghetti with Meatballs', 'LanY'),
(2, 'Fish Tacos', 'LanY'),
(3, 'Spaghetti with Meatballs', 'Rin'),
(3, 'Popovers', 'SaltBae'),
(4, 'Popovers', 'Rin')
;

INSERT into FAVORITE values
('Spaghetti with Meatballs', 'LanY', '2017-01-02'),
('Popovers', 'Rin', '2017-03-01');

INSERT into FRIEND values
('LanY', 'Rin'),
('Rin', 'LanY')
;

INSERT into RECIPE values
(
	'Elegant Brunch Chicken Salad', 
	30, 
	30, 
	'http://images.media-allrecipes.com/userphotos/560x315/360721.jpg', 
	'1) Bring a large pot of water to a boil. Add the chicken and simmer until cooked through, approximately 10 minutes. Drain, cool and cut into cubes. 
	2) While boiling chicken, make the mayonnaise: Using a blender or hand-held electric mixer, beat the egg, mustard, salt, water and vinegar until light and frothy. Add the oil a tablespoon at a time, beating thoroughly after each addition. Once mixture begins to thicken, you can add oil more quickly. Continue until mixture reaches the consistency of creamy mayonnaise. NOTE: The more oil you add, the thicker it gets; you may not need the full cup of oil.
	3) In a large bowl, toss together the chicken, grapes, pecans, blue cheese and 1 cup of the mayonnaise. Stir until evenly coated, adding more mayonnaise if necessary. Refrigerate until serving.', 
	'2017-02-25'
),
(
	'Chili Burgers',
	 5, 
	15, 
	'http://images.media-allrecipes.com/userphotos/600x600/105059.jpg', 
	'1) Preheat a grill for high heat. When the grill is hot, lightly oil the grate. 
	2) In a medium bowl, mix together the ground beef, Italian sausage, chili sauce, salt and pepper. Form 8 balls out of the meat, and flatten into patties.
	3) Grill patties for 5 minutes per side, or until well done. Serve on buns with your favorite toppings.', 
	'2017-01-05'
),
(
	'Cherry Cheese Pie', 
	15, 
	120, 
	'http://images.media-allrecipes.com/userphotos/250x250/829069.jpg', 
	'1) In a medium mixing bowl, beat together softened cream cheese and sugar until light and fluffy. Fold in whipped topping and blend until mixture is smooth. Spread into graham cracker crust and spoon pie filling over top. Cover with plastic wrap and chill 2 hours before serving.', 
	'2017-05-01'
),
--added by alex
----------------------------------------------------------------------------
(
	'Chicken and potato bake', 
	5, 
	60, 
	'http://pictures.food.com/api/file/YYilXsYFSxy4JvjEfOz4-122-chick-pot-carrots.jpg', 
	'1) Place chicken pieces, cut up potatoes, and baby carrots in large baking dish. 
	2) Drizzle with Kraft Zesty Italian Dressing.
	3) Sprinkle with Parmesan cheese, then Bake for 1 hour at 400 degrees Fahrenheit.', 
	'2015-11-25'
),
(
	'Beef and Broccoli Stir-Fry', 
	17, 
	8, 
	'http://img.sndimg.com/food/image/upload/img/recipes/99/47/6/j7L11nRQNeKACth1WJkg_easy-beef-broccoli-stir-fry-6106.jpg', 
	'1) In a bowl, combine 2 tablespoons cornstarch, 2 tablespoons water and garlic powder until smooth, then Add beef and toss.
	2) In a large skillet or wok over medium high heat, stirfry beef in 1 tablespoon oil until beef reaches desired doneness remove and keep warm.
	3) Stir-fry broccoli and onion in remaining oil for 4 to 5 minutes.
	4) Return beef to pan, and combine soy sauce, brown sugar, ginger and remaining cornstarch and water until smooth; add to the pan.
	5) Cook and stir for 2 minutes then Serve over rice.', 
	'2017-01-31'
)
-----------------------------------------------------------------------------------
;


INSERT into USER values
( 'ProCook', 'Zloipovor#2'),
('Kristin', '4bestie!'),
('ExoticFoods', '7ystal_#'),
('HungryMe', 'Kolonka23%'),
--added by alex
---------------------------------------
('SnackAttack42','hunter2'),
('HungreyJoe','password')
-----------------------------------
;

INSERT into SHOPPING_LIST values
('For My Birthday', '2017-03-25', 'ProCook'),
('Dinner', '2017-03-27', 'ProCook'),
('Meat recipes', '2017-02-15', 'Kristin'),
('Breakfast', '2017-01-08', 'Kristin'),
('Desserts', '2016-12-19', 'ExoticFoods'),
('For Mom and Dad', '2017-01-29', 'ExoticFoods'),
('My Fav', '2017-02-04', 'HungryMe'),
('To try out', '2017-01-13', 'HungryMe')
;

INSERT into NUTRITION values
('Calories', 'Elegant Brunch Chicken Salad', 657, 'kcal'),
('Fat', 'Elegant Brunch Chicken Salad', 58, 'g'),
('Carbs', 'Elegant Brunch Chicken Salad', 13, 'g'),
('Protein', 'Elegant Brunch Chicken Salad', 25, 'g'),
('Cholesterol', 'Elegant Brunch Chicken Salad', 92, 'mg'),
('Sodium', 'Elegant Brunch Chicken Salad', 521, 'mg'),
('Calories', 'Chili Burgers', 230, 'kcal'),
('Fat', 'Chili Burgers', 15, 'g'),
('Carbs', 'Chili Burgers', 4, 'g'),
('Protein', 'Chili Burgers', 18, 'g'),
('Cholesterol', 'Chili Burgers', 63, 'mg'),
('Sodium', 'Chili Burgers', 486, 'mg'),
('Calories', 'Cherry Cheese Pie', 421, 'kcal'),
('Fat', 'Cherry Cheese Pie', 21, 'g'),
('Carbs', 'Cherry Cheese Pie', 56, 'g'),
('Protein', 'Cherry Cheese Pie', 4, 'g'),
('Cholesterol', 'Cherry Cheese Pie', 31, 'mg'),
('Sodium', 'Cherry Cheese Pie', 251, 'mg')
;

--For Stir fry and potato bake added by alex
------------------------------------------------------------------------
INSERT INTO NUTRITION VALUES
('Calories', 'Chicken and potato bake', 484, 'kcal'),
('Fat','Chicken and potato bake',11,'g'),
('Cholesterol','Chicken and potato bake',194,'mg'),
('Sodium','Chicken and potato bake',354,'mg'),
('Carbs','Chicken and potato bake',43,'g'),
('Calories','Beef and Broccoli Stir-Fry',150,'kcal'),
('Fat','Beef and Broccoli Stir-Fry',7,'g'),
('Cholesterol','Beef and Broccoli Stir-Fry',0,'mg'),
('Sodium','Beef and Broccoli Stir-Fry',731,'mg'),
('Carbs','Beef and Broccoli Stir-Fry',20,'g')
;
--------------------------------------------------------
INSERT into RATING values
(4, 'Elegant Brunch Chicken Salad', 'ProCook'),
(2, 'Elegant Brunch Chicken Salad', 'Kristin'),
(3, 'Elegant Brunch Chicken Salad', 'HungryMe'),
(3, 'Chili Burgers', 'ProCook'),
(4, 'Chili Burgers', 'Kristin'),
(3, 'Chili Burgers', 'ExoticFoods'),
(5, 'Chili Burgers', 'HungryMe'),
(5, 'Cherry Cheese Pie', 'Kristin'),
(4, 'Cherry Cheese Pie', 'ExoticFoods'),
--added by alex
-------------------------------------------------------------
(5,'Beef and Broccoli Stir-Fry','SnackAttack42'),
(4,'Chicken and potato bake','HungreyJoe')
--------------------------------------------------------------
;
--added by alex
----------------------------------------------------------------------
INSERT INTO RECIPE_CONTENT values
('Chicken and potato bake','Skinless, boneless chicken breast halves','2 pound'),
('Chicken and potato bake','Potato','4'),
('Chicken and potato bake','Baby Carrot','2 cups'),
('Chicken and potato bake','italian Dressing','1/2 cup'),
('Chicken and potato bake','Parmesan Cheese','1/4 cup'),
('Beef and Broccoli Stir-Fry','Cornstarch','3 tablespoon'),
('Beef and Broccoli Stir-Fry','Hot water','1/2 cup'),
('Beef and Broccoli Stir-Fry','Boneless round steak','1 pound'),
('Beef and Broccoli Stir-Fry','Garlic powder','1/2 teaspoon'),
('Beef and Broccoli Stir-Fry','Vegetable oil','2 tablespoon'),
('Beef and Broccoli Stir-Fry','Broccoli Floret','4 Cups'),
('Beef and Broccoli Stir-Fry','Onions','1'),
('Beef and Broccoli Stir-Fry','Soy Sauce','1/3 Cup'),
('Beef and Broccoli Stir-Fry','Brown sugar','2 tablespoon'),
('Beef and Broccoli Stir-Fry','Rice','1/2 pound')
;
------------------------------------------------------------------------
INSERT into RECIPE_CONTENT values
('Elegant Brunch Chicken Salad', 'Skinless, boneless chicken breast halves', '1 pound'),
('Elegant Brunch Chicken Salad', 'Egg', '1'),
('Elegant Brunch Chicken Salad', 'Dry mustard', '1/4 teaspoon'),
('Elegant Brunch Chicken Salad', 'Salt', '1/2 teaspoon'),
('Elegant Brunch Chicken Salad', 'Hot water', '2 teaspoons'),
('Elegant Brunch Chicken Salad', 'White wine vinegar', '1 tablespoon'),
('Elegant Brunch Chicken Salad', 'Olive Oil', '1 cup'),
('Elegant Brunch Chicken Salad', 'Halved seedless red grapes', '2 cups'),
('Elegant Brunch Chicken Salad', 'Coarsely chopped pecans', '1 cup'),
('Elegant Brunch Chicken Salad', 'Coarsely crumbled blue cheese', '1 cup'),
('Chili Burgers', 'Ground beef', '1 1/2 pounds'),
('Chili Burgers', 'Italian sausage', '1/2 pound'),
('Chili Burgers', 'Tomato-based chili sauce', '1/3 cup'),
('Chili Burgers', 'Salt', 'To taste'),
('Chili Burgers', 'Pepper', 'To taste'),
('Cherry Cheese Pie', 'Prepared graham cracker crust', '1 (9 inch)'),
('Cherry Cheese Pie', 'Cream cheese, softened', '1 (8 ounce)'),
('Cherry Cheese Pie', 'White sugar', '1/2 cup'),
('Cherry Cheese Pie', 'Frozen whipped topping, thawed', '2 cups'),
('Cherry Cheese Pie', 'Cherry pie filling', '1 can (21 ounce)')
;

INSERT into SHOPPING_LIST_CONTENT values
('ProCook', 'Skinless, boneless chicken breast halves', 'For My Birthday', 2),
('ProCook', 'Egg', 'For My Birthday', 2),
('ProCook', 'Halved seedless red grapes', 'For My Birthday', 2),
('ProCook', 'Coarsely chopped pecans', 'For My Birthday', 2),
('Kristin', 'Prepared graham cracker crust', 'Breakfast', 3),
('Kristin', 'Cream cheese, softened', 'Breakfast', 3),
('Kristin', 'Frozen whipped topping, thawed', 'Breakfast', 3),
('Kristin', 'Cherry pie filling', 'Breakfast', 3),
('ExoticFoods', 'Prepared graham cracker crust', 'Desserts', 1),
('ExoticFoods', 'Cherry pie filling', 'Desserts', 1),
('HungryMe', 'Ground beef', 'To try out', 1),
('HungryMe', 'Italian sausage', 'To try out', 2),
('HungryMe', 'Tomato-based chili sauce', 'To try out', 2)
;

INSERT into FAVORITE values
('Elegant Brunch Chicken Salad', 'ProCook', '2017-27-03'),
('Cherry Cheese Pie', 'Kristin', '2017-15-03'),
('Cherry Cheese Pie', 'ExoticFoods', '2017-28-02'),
('Chili Burgers', 'HungryMe', '2017-10-01');

INSERT into FRIEND values
('ProCook', 'Kristin'),
('ProCook', 'ExoticFoods'),
('Kristin', 'ProCook'),
('Kristin', 'ExoticFoods'),
('ExoticFoods', 'ProCook'),
('HungryMe', 'Kristin'),
('HungryMe', 'ProCook')
;

INSERT INTO RECIPE VALUES
(
	'Seared Scallops with Jalapeno Vinegarette',
	5,
	10,
	'http://images.media-allrecipes.com/userphotos/250x250/839057.jpg',
	'1.) Place 1 large jalapeno, 1/4 cup rice vinegar, 1/4 cup olive oil, and 1/4 teaspoon 
	Dijon mustard in a blender. Puree on high until mixture is completely liquefied, 
	1 to 2 minutes.
	2.) 12 large fresh season sea scallops with 1 pinch sea salt and 1 pinch cayenne pepper. 
	Heat 1 tablespoon vegetable oil in a skillet over high heat. Place scallops in skillet 
	and cook until browned, 2 to 3 minutes per side. Transfer to a plate. Garnish scallops 
	with oranges segments and drizzle jalapeno Vinegarette over the top.',
	'2017-03-04'
);


INSERT INTO RECIPE VALUES
(
	'Good Old Fashioned Pancakes',
	5,
	15,
	'http://images.media-allrecipes.com/userphotos/560x315/3821005.jpg',
	'1.) In a large bowl, sift together the 1 1/2 cups all- purpose Flour, 
	3 1/2 teaspoons baking powder, 1 teaspoon salt and 1 tablespoon white sugar. 
	Make a well in the center and pour in the 1 1/4 cups milk, 1 egg and 
	3 tablespoons melted butter; mix until smooth.
	2.) Heat a lightly oiled griddle or frying pan over medium high hear. 
	Pour or scoop the batter onto the griddle, using approximatedly 1/4 cup 
	for each pancake. Brown on both sides and serve hot.',
	'2017-03-04'
);

INSERT INTO RECIPE VALUES
(
	'Filet Mignon and Balsamic Strawberries',
	70,
	15,
	'http://images.media-allrecipes.com/userphotos/560x315/1313633.jpg',
	'1.) Mix together the 2 cups slided strawberries, 1/4 cup brown sugar, 
	and 1/4 cup balsamic vinegar in a bowl, and allow to sit for 1 to 3 hours, 
	stirring occasionally.
	2.) Preheat an oven to 400 degrees F (200 degrees C).
	3.) Heat 1 tablespoon olive oil in an oven-safe, heavy steel or 
	cast-iron skillet over high heat. Sprinkle the 4 (6 ounce) filets mignon 
	with some salt and pepper on both side until well-browned, 1 to 2 minutes 
	per side. Slide the skillet into the preheated oven, and cook until they 
	start to become firm and are reddish-pink and juicy in the center, about 
	10 minutes. An instant-read thermometer inserted into the center should 
	read 130 degrees F (54 degress C). Transfer the steaks to a platter, and 
	tnet with foil to rest.
	4.) Pour steak juices from the skillet into a small saucepan. Strain 
	the strawberries and discard the liquid. Add the strawberries to the 
	steak juices, bring the sauce to a simmer over medium-low heat, and 
	melt the 1 tablespoon butter into the sauce, tilting the pan several 
	times to gently incorporate the butter into the sauce. Serve each fillet 
	topped with about 1/2 cup of strawberries and a sprinkle of freshly 
	ground black pepper.',
	'2017-03-04'
);


INSERT INTO USER VALUES
('Vampire', 'Bloody'),
('Tom', 'Jerry'),
('CSS475', 'Database')
;

INSERT INTO SHOPPING_LIST VALUES
('New breakfast', '2017-03-07', 'Rin'),
('SteakSteak', '2017-03-04', 'LanY'),
('EasyEasy', '2017-03-04', 'LanY')
;


INSERT INTO NUTRITION VALUES
('Calories', 'Filet Mignon and Balsamic Strawberries', 438, 'kcal'),
('Fat', 'Filet Mignon and Balsamic Strawberries', 27, 'g'),
('Carbs', 'Filet Mignon and Balsamic Strawberries', 22, 'g'),
('Protein', 'Filet Mignon and Balsamic Strawberries',26 , 'g'),
('Cholesterol', 'Filet Mignon and Balsamic Strawberries', 94, 'mg'),
('Sodium', 'Filet Mignon and Balsamic Strawberries', 127, 'mg'),

('Calories', 'Good Old Fashioned Pancakes', 158, 'kcal'),
('Fat', 'Good Old Fashioned Pancakes', 6, 'g'),
('Carbs', 'Good Old Fashioned Pancakes', 22, 'g'),
('Protein', 'Good Old Fashioned Pancakes',5 , 'g'),
('Cholesterol', 'Good Old Fashioned Pancakes', 38, 'mg'),
('Sodium', 'Good Old Fashioned Pancakes', 504, 'mg'),

('Calories', 'Seared Scallops with Jalapeno Vinegarette', 307, 'kcal'),
('Fat', 'Seared Scallops with Jalapeno Vinegarette', 18, 'g'),
('Carbs', 'Seared Scallops with Jalapeno Vinegarette', 6, 'g'),
('Protein', 'Seared Scallops with Jalapeno Vinegarette',30 , 'g'),
('Cholesterol', 'Seared Scallops with Jalapeno Vinegarette', 72, 'mg'),
('Sodium', 'Seared Scallops with Jalapeno Vinegarette', 433, 'mg')
;

INSERT INTO RATING VALUES
(5, 'Filet Mignon and Balsamic Strawberries', 'LanY'),
(4, 'Good Old Fashioned Pancakes', 'Rin'),
(5, 'Seared Scallops with Jalapeno Vinegarette', 'CSS475');

INSERT INTO RECIPE_CONTENT VALUES
('Seared Scallops with Jalapeno Vinegarette', 'Jalapeno pepper', '1'),
('Seared Scallops with Jalapeno Vinegarette', 'Rice vinegar', '1/4 cup'),
('Seared Scallops with Jalapeno Vinegarette', 'Olive Oil', '1/4 cup'),
('Seared Scallops with Jalapeno Vinegarette', 'Dijon mustard', '1/4 teaspoon'),
('Seared Scallops with Jalapeno Vinegarette', 'Black pepper', 'Some'),
('Seared Scallops with Jalapeno Vinegarette', 'Salt', 'Some'),
('Seared Scallops with Jalapeno Vinegarette', 'Vegetable oil', '1 teaspoon'),
('Seared Scallops with Jalapeno Vinegarette', 'Scallops', '12'),
('Seared Scallops with Jalapeno Vinegarette', 'Sea salt', '1 pinch'),
('Seared Scallops with Jalapeno Vinegarette', 'Cayenne pepper', '1 pinch'),
('Seared Scallops with Jalapeno Vinegarette', 'Orange', '2'),

('Good Old Fashioned Pancakes', 'All-purpose Flour', '1 1/2 cups'),
('Good Old Fashioned Pancakes', 'Baking powder', '3 1/2 tablespoons'),
('Good Old Fashioned Pancakes', 'Salt', '1 teaspoon'),
('Good Old Fashioned Pancakes', 'White suger', '1 teaspoon'),
('Good Old Fashioned Pancakes', 'Milk', '1 1/4 cups'),
('Good Old Fashioned Pancakes', 'Egg', '1'),
('Good Old Fashioned Pancakes', 'Butter', '3 tablespoons'),

('Filet Mignon and Balsamic Strawberries', 'Strawberries', '2 cups'),
('Filet Mignon and Balsamic Strawberries', 'Brown sugar', '1/4 cup'),
('Filet Mignon and Balsamic Strawberries', 'Balsamic vinegar', '1/4 cup'),
('Filet Mignon and Balsamic Strawberries', 'Olive Oil', '1 tablespoon'),
('Filet Mignon and Balsamic Strawberries', 'Filet mignon', '4 (6 ounce) '),
('Filet Mignon and Balsamic Strawberries', 'Salt', 'some'),
('Filet Mignon and Balsamic Strawberries', 'Butter', '1 tablespoon'),
('Filet Mignon and Balsamic Strawberries', 'Black pepper', 'some')
;

INSERT INTO SHOPPING_LIST_CONTENT VALUES
('Rin', 'All-purpose Flour', 'New breakfast', 1),
('Rin', 'Baking Powder', 'New breakfast',1 ),
('LanY', 'Brown sugar', 'SteakSteak', 1),
('LanY', 'Balsamic vinegar', 'SteakSteak', 1),
('LanY', 'Filet mignon', 'SteakSteak', 2),
('LanY', 'Sea salt', 'EasyEasy', 1),
('LanY', 'Scallops', 'EasyEasy', 12),
('LanY','Dijon mustard', 'EasyEasy', 1)
;

INSERT INTO FAVORITE VALUES
('Seared Scallops with Jalapeno Vinegarette', 'LanY', '2017-03-04'),
('Good Old Fashioned Pancakes', 'Rin', '2017-03-07'),
('Filet Mignon and Balsamic Strawberries', 'LanY', '2017-03-04')
;

INSERT INTO FRIEND VALUES
('CSS475', 'Rin'),
('Rin', 'CSS475'),
('Tom', 'CSS475'),
('CSS475', 'Tom')
;

