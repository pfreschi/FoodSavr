// load the firebase-functions and firebase-admin modules,
// and initialize an admin app instance from which Realtime Database changes can be made.
const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var db = admin.database();
var ref = db.ref();
var itemsref = db.ref('/items/');
var usersref = db.ref("/users/");
////////////////////////////////////////////////////////////////////////
// INSERT YOUR OWN OCR, GOOGLE URL SHORTENER, and YUMMLY KEYS! 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////


var baseURLWithoutIngredients = 'http://api.yummly.com/v1/api/recipes?_app_id=' + yummlyAppId +  '&_app_key=' + yummlyAppKey;

var allergyRestrictions = [];
var dietaryRestrictions = [];
var excludedIngredient = "";


var allergyIdJSON = [  
   {  
      "id":"393",
      "shortDescription":"Gluten-Free",
      "longDescription":"Gluten-Free",
      "searchValue":"393^Gluten-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"394",
      "shortDescription":"Peanut-Free",
      "longDescription":"Peanut-Free",
      "searchValue":"394^Peanut-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"398",
      "shortDescription":"Seafood-Free",
      "longDescription":"Seafood-Free",
      "searchValue":"398^Seafood-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"399",
      "shortDescription":"Sesame-Free",
      "longDescription":"Sesame-Free",
      "searchValue":"399^Sesame-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"400",
      "shortDescription":"Soy-Free",
      "longDescription":"Soy-Free",
      "searchValue":"400^Soy-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"396",
      "shortDescription":"Dairy-Free",
      "longDescription":"Dairy-Free",
      "searchValue":"396^Dairy-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"397",
      "shortDescription":"Egg-Free",
      "longDescription":"Egg-Free",
      "searchValue":"397^Egg-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"401",
      "shortDescription":"Sulfite-Free",
      "longDescription":"Sulfite-Free",
      "searchValue":"401^Sulfite-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"395",
      "shortDescription":"Tree Nut-Free",
      "longDescription":"Tree Nut-Free",
      "searchValue":"395^Tree Nut-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"392",
      "shortDescription":"Wheat-Free",
      "longDescription":"Wheat-Free",
      "searchValue":"392^Wheat-Free",
      "type":"allergy",
      "localesAvailableIn":[  
         "en-US"
      ]
   }
];


var dietaryIdJSON = [  
   {  
      "id":"388",
      "shortDescription":"Lacto vegetarian",
      "longDescription":"Lacto vegetarian",
      "searchValue":"388^Lacto vegetarian",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"389",
      "shortDescription":"Ovo vegetarian",
      "longDescription":"Ovo vegetarian",
      "searchValue":"389^Ovo vegetarian",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"390",
      "shortDescription":"Pescetarian",
      "longDescription":"Pescetarian",
      "searchValue":"390^Pescetarian",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"386",
      "shortDescription":"Vegan",
      "longDescription":"Vegan",
      "searchValue":"386^Vegan",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"387",
      "shortDescription":"Lacto-ovo vegetarian",
      "longDescription":"Vegetarian",
      "searchValue":"387^Lacto-ovo vegetarian",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   },
   {  
      "id":"403",
      "shortDescription":"Paleo",
      "longDescription":"Paleo",
      "searchValue":"403^Paleo",
      "type":"diet",
      "localesAvailableIn":[  
         "en-US"
      ]
   }
];



exports.generateRecipes = functions.database.ref('/users/{userID}/inventoryOrderedByExpiration')
    .onWrite(event => {
      // Grab the current value of what was written to the Realtime Database.
      const inventoryOrderedByExpiration = event.data.val();
      console.log(inventoryOrderedByExpiration);

      //get preferences
      return event.data.ref.parent.once('value').then(function(snapshot) {
        var userObject = snapshot.val();
        if(typeof userObject["allergy"] != 'undefined'){
          var rawAllergyRestrictions = userObject["allergy"]
          console.log("original allergy restrictions are " + rawAllergyRestrictions)

          if (typeof rawAllergyRestrictions != 'undefined') {
            for (var i = 0; i < rawAllergyRestrictions.length; i++) {
              var result = getAllergySearchVal(rawAllergyRestrictions[i] + "-Free");
              if (typeof result != 'undefined'){
                allergyRestrictions.push(result[0]["searchValue"])
              }
            }
            console.log("modified allergy restrictions are " + allergyRestrictions);
            
          }
        }
        
        if(typeof userObject["diet"] != 'undefined'){
          var rawDietaryRestrictions = userObject["diet"]
          console.log("original dietary restrictions are " + rawDietaryRestrictions)

          if (typeof rawDietaryRestrictions != 'undefined') {
            for (var i = 0; i < rawDietaryRestrictions.length; i++) {
              var result = getDietarySearchVal(rawDietaryRestrictions[i]);
              if (typeof result != 'undefined'){
                dietaryRestrictions.push(result[0]["searchValue"])
              }
              
            }
          }
        }


        excludedIngredient = userObject["excludedIngredients"]


        // now ready to fetch the recipes using these prefs...
        var determinedTopRecipeList = false
        
        // save the returned recipes
        findRecipes(inventoryOrderedByExpiration, 7, 25, false, null, 7, event.data.ref.parent.child('recipes'))

      

      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
        return event.data.ref.parent.child('recipes').once('value').then(function(snapshot) {
          console.log(snapshot)
        });
      });
    });


// generates a list of reccommended recipes for A SINGLE ITEM INSERTED INTO INVENTORY
exports.generateItemRecipes = functions.database.ref('/users/{userID}/inventoryOrderedByExpiration/{itemKey}')
    .onWrite(event => {
      // Grab the current value of what was written to the Realtime Database.
      const inventoryOfOne = event.data.val();
      const itemKey = event.params.itemKey
      console.log(inventoryOfOne);
      

      //get preferences
      return event.data.ref.parent.parent.once('value').then(function(snapshot) {
        var userObject = snapshot.val();
        if(typeof userObject["allergy"] != 'undefined'){
          var rawAllergyRestrictions = userObject["allergy"]
          console.log("original allergy restrictions are " + rawAllergyRestrictions)

          if (typeof rawAllergyRestrictions != 'undefined') {
            for (var i = 0; i < rawAllergyRestrictions.length; i++) {
              var result = getAllergySearchVal(rawAllergyRestrictions[i] + "-Free");
              if (typeof result != 'undefined'){
                allergyRestrictions.push(result[0]["searchValue"])
              }
            }
            console.log("modified allergy restrictions are " + allergyRestrictions);
            
          }
        }
        
        if(typeof userObject["diet"] != 'undefined'){
          var rawDietaryRestrictions = userObject["diet"]
          console.log("original dietary restrictions are " + rawDietaryRestrictions)

          if (typeof rawDietaryRestrictions != 'undefined') {
            for (var i = 0; i < rawDietaryRestrictions.length; i++) {
              var result = getDietarySearchVal(rawDietaryRestrictions[i]);
              if (typeof result != 'undefined'){
                dietaryRestrictions.push(result[0]["searchValue"])
              }
              
            }
          }
        }


        excludedIngredient = userObject["excludedIngredients"]


        // now ready to fetch the recipes using these prefs...
        var determinedTopRecipeList = false
        
        // save the returned recipes for the item
        if (inventoryOfOne != "") {
          findRecipes([inventoryOfOne], 1, 10, false, null, 3, event.data.ref.parent.parent.child('recipesForItems/' + inventoryOfOne))
        }
        

      

      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
        return event.data.ref.parent.child('recipesForItems').once('value').then(function(snapshot) {
          console.log(snapshot)
        });
      });
    });









    function getAllergySearchVal(search) {
      return allergyIdJSON.filter(
        function(data){ return data.shortDescription == search }
      );
    }

    function getDietarySearchVal(search) {
      return dietaryIdJSON.filter(
        function(data){ return data.shortDescription == search }
      );
    }




    function findRecipes(allIngredients, numIngredients, maxNumberOfRecipesToReturn, foundTopRecipesToDisplay, returnedRecipes, numberOfTries, recipeUpdateRef){
        var topIngredients = allIngredients.slice(0, numIngredients)
        console.log(topIngredients)


        
        var queryURL = baseURLWithoutIngredients

        // add allowedingredients to recipe query
        for (i = 0; i < topIngredients.length; i++){
          queryURL = queryURL + "&allowedIngredient[]=" + topIngredients[i]
        }


        // add dietary restrictions to recipe query
        for (i = 0; i < dietaryRestrictions.length; i++){
          queryURL = queryURL + "&allowedDiet[]=" + dietaryRestrictions[i]
        }

        // add allergy restrictions to recipe query
        for (i = 0; i < allergyRestrictions.length; i++){
          queryURL = queryURL + "&allowedAllergy[]=" + allergyRestrictions[i]
        }

        // add excluded ingredient to recipe query
        if (excludedIngredient != "") {
          queryURL = queryURL + "&excludedIngredient[]=" + excludedIngredient
        }
        
        queryURL = queryURL + "&maxResult=" + maxNumberOfRecipesToReturn
        console.log(queryURL)

        var request = require('xhr-request');
	
        if (foundTopRecipesToDisplay == false && numberOfTries > 1) {
          //initiate yummly request
          request(queryURL, {
            method: 'GET',
            json: true
          }, function (err, data) {
            if (err) throw err
            console.log(data); 
            console.log(data["matches"].length)
            returnedRecipes = data["matches"]
            if (returnedRecipes.length >= 3){
              // determined the top recipe list
              // if more than 7 are returned, only utilize top seven
              findRecipes(allIngredients, numIngredients, maxNumberOfRecipesToReturn, true, returnedRecipes, 0, recipeUpdateRef)
            } else {
              // could not determine top recipe list. try again with top other
              findRecipes(allIngredients, numIngredients - 1, maxNumberOfRecipesToReturn, false, null, numberOfTries - 1, recipeUpdateRef)

            }
          });
        } else if (foundTopRecipesToDisplay == true) {
          console.log("found " +returnedRecipes.length + " recipes! here they are:")
          console.log(returnedRecipes)
          // SAVE NEW RECIPES TO DB
          recipeUpdateRef.set(returnedRecipes)

        } else {
          console.log("sorry, couldn't find any recipes with these ingredients with this number of tries")
        }
        

      }








//////////////////////////////////////////////////////////////////////////////////////////////////////////////



var bananas = {
  "name": "bananas",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fbananas.jpg?alt=media&token=fde85f0e-6232-438e-b0cc-b2dc71c6f1af",
  "expirationDate": 7
};

var chia_seeds = {
  "name": "chia seeds",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fchia_seeds.jpg?alt=media&token=d08fdc74-ba48-4b80-8368-d7a037213ca2",
  "expirationDate": 700
}

var dried_fig = {
  "name": "dried fig",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fdried_fig.jpg?alt=media&token=8fa588ca-03b0-4ba0-afd3-46924be4ac79",
  "expirationDate": 124
}

var frozen_peaches = {
  "name": "frozen peaches",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Ffrozen_peaches.JPG?alt=media&token=1bc37bb2-1292-4465-93f7-10c29832f1bc",
  "expirationDate": 240
}

var blueberries = {
  "name": "blueberries",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fblueberries.jpg?alt=media&token=28da9ba2-8efe-4034-b19c-3bb1d28097ee",
  "expirationDate": 5
}

var pumpkin_seeds = {
  "name": "pumpkin seeds",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fpumpkin_seeds.jpg?alt=media&token=050199c6-f2a0-4fa3-8f18-7ab5dffb566e",
  "expirationDate": 90
}

var cherry_tomatoes = {
  "name": "cherry tomatoes",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fcherry_tomatoes.jpg?alt=media&token=d3f78c82-6eca-4d37-a375-5a07c7ec65fe",
  "expirationDate": 90
}

var cucumber = {
  "name": "cucumber",
  "pic": "http://www.medicalnewstoday.com/content/images/articles/283/283006/sliced-cucumber.jpg",
  "expirationDate": 2
};

var sour_cream = {
  "name": "sour cream",
  "pic": "http://daisybrand.com/assets/images/products/sourcream-light.jpg",
  "expirationDate": 21,
};

var olive_oil = {
  "name": "Olive Oil",
  "pic": "http://www.medicalnewstoday.com/content/images/articles/266/266258/olive-oil-and-olives.jpg",
  "expirationDate": 180
}

var chocolate_chip_cookie_dough_ice_cream = {
  "name": "chocolate chip cookie dough ice cream",
  "pic": "https://vignette2.wikia.nocookie.net/icecream/images/7/76/Chocolatechip.png/revision/latest?cb=20110917093015",
  "expirationDate": 90
}

var parmesan_cheese = {
  "name": "parmesan cheese",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fparmesan_cheese.jpg?alt=media&token=afcb1f4c-8b77-4361-88c9-c3591b7c1ac2",
  "expirationDate": 60
}

var dried_apricot = {
  "name": "dried apricot",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2FDried%20Apricot-4.jpg?alt=media&token=5887c152-594a-4bd4-b98d-21f23ed82480",
  "expirationDate": 365
}

var pistachio_nuts = {
  "name": "pistachio nuts",
  "pic": "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/items%2Fpistachio.jpg?alt=media&token=a41c15f3-4c76-40fc-8a70-fef014756c6d",
  "expirationDate": 90
}

// returns final text from Image Url
function getTextFromLongUrl(longUrl, e) {
  api_url = "https://www.googleapis.com/urlshortener/v1/url";
  request_url = api_url + "?key=" + URLSHORTENERKEY;
  var request = require('xhr-request');
  var dataString = '{"longUrl": "' + longUrl + '"}';
  var header = {
      'Content-Type': 'application/json'
  };
  request(request_url, {
    method: 'POST',
    headers: header,
    body: dataString
  }, function (err, data) {
    if (err) throw err
    var objectifiedData = JSON.parse(data);
    var shortUrl = objectifiedData["id"];
    getTextFromShortUrl(shortUrl, e);
  });
}

// returns text from a receipt imageUrl
function getTextFromShortUrl(imageUrl, original) {
  var request = require('xhr-request');
  request_url = "https://api.ocr.space/parse/imageurl?apikey=" + OCRKEY + "&url=" + imageUrl;

  request(request_url, {
    method: 'GET',
    json: true
  }, function (err, data) {
    if (err) throw err
    text = data["ParsedResults"][0].ParsedText;

    var updates = {};
    var d = new Date();
    var itemsref = db.ref('/items/');
    var items = [];
    text = text.toLowerCase();

    // determines which receipt to use
    if (text.includes("ice cream")) {
      items = [chocolate_chip_cookie_dough_ice_cream, dried_apricot, pistachio_nuts, parmesan_cheese];
    } else if (text.includes("peach")) {
      items = [chia_seeds, dried_fig, frozen_peaches, blueberries, pumpkin_seeds, cherry_tomatoes, bananas];
    } else {
      items = [cucumber];
    }

    for (index = 0; index < items.length; ++index) {
      var newPostKey = itemsref.push().key;
      var item = items[index];
      item["creatorId"] = original.creatorId;
      item["dateAdded"] = "2017" + " " + ("0" + d.getMonth()).slice(-2).toString() + " " + ("0" + d.getDate()).slice(-2).toString();
      item["sharedWith"] = [];
      updates[newPostKey] = item;
    }
    console.log(updates);
    return itemsref.update(updates);
  });
}

// creates function to get text from receipt and save items
exports.getReceiptText = functions.database.ref('/receipts/{receiptId}/')
    .onWrite(event => {
        var image_url = event.data.val().pic;
        var original = event.data.val();
        getTextFromLongUrl(image_url, original);
});
