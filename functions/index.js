
// initializes firebase connection
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var db = admin.database();
var ref = db.ref();


function getReceiptText(e) {
    if (xhr.readyState == 4 && xhr.status == 200) {
      var response = JSON.parse(xhr.responseText);
      return response.ParsedResults[0].ParsedText;

    }
}

// creates function to get text from receipt and save items
exports.getReceiptText1 = functions.database.ref('/receipts/{receiptId}/')
    .onWrite(event => {
      	console.log("write event occured");
        const original = event.data.val();
        var itemsref = db.ref('/items/').child(original.creatorId);
        var items = ["bananas", "apples", "broccoli", "milk", "flour"];
        var d = new Date();
        var updates = {};

    		for (index = 0; index < items.length; ++index) {
    			// generate itemId
    			var newPostKey = itemsref.push().key;
    		    console.log(items[index]);

        API_KEY = "2c6009920c88957";
        image_url = "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/receipts%2Fg2rrAida7mUczgUb4Qwn9uCiVd32%2F513484257067.jpg?alt=media&token=7239ee08-ed37-4e20-af2c-95f33268ec2a";
        request_url = "https://api.ocr.space/parse/imageurl?apikey=" + API_KEY + "&url=" + image_url;

        var xhr = new XMLHttpRequest();
        xhr.open('GET', request_url, true);
        xhr.send();

        
  			var postData = {
  			    creatorId: original.creatorId,
  			    dateAdded: (d.getFullyear().toString() + " " + ("0" + d.getMonth()).slice(-2).toString() + " " + ("0" + d.getDate()).slice(-2).toString(),
  			    deleted: false,
  			    disposed: false,
  			    expirationDate: "08, 25, 2017",
  			    name: items[index]
  			};

    	  updates[newPostKey] = postData;
    		}
  		  console.log(updates);
  		  // return itemsref.update(updates);
    });


https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/receipts%2Fg2rrAida7mUczgUb4Qwn9uCiVd32%2F513831376827.jpg?alt=media&token=f651b07a-343d-4f75-860d-da131182f201



// // create the request_url
API_KEY = "2c6009920c88957";
image_url = "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/receipts%2Fg2rrAida7mUczgUb4Qwn9uCiVd32%2F513484257067.jpg?alt=media&token=7239ee08-ed37-4e20-af2c-95f33268ec2a";
request_url = "https://api.ocr.space/parse/imageurl?apikey=" + API_KEY + "&url=" + image_url;
//
// // sending request
var xhr = new XMLHttpRequest();
xhr.open('GET', request_url, true);
xhr.send();
//
// // returns text from image
function getReceiptText(e) {
    if (xhr.readyState == 4 && xhr.status == 200) {
      var response = JSON.parse(xhr.responseText);
      return response.ParsedResults[0].ParsedText;

    }
}
//
// // when the state changes calls the function to submit request
// xhr.onreadystatechange = getReceiptText;
//
// // Moderates messages by lowering all uppercase messages and removing swearwords.
// exports.getReceiptText = functions.database
//     .ref('/receipts/{receiptId}').onWrite(event => {
//       const receipt_pic = event.data;
//
//       if (message && !message.sanitized) {
//         // Retrieved the message values.
//         console.log('Retrieved message content: ', message);
//
//         // Run moderation checks on on the message and moderate if needed.
//         const moderatedMessage = moderateMessage(message.text);
//
//         // Update the Firebase DB with checked message.
//         console.log('Message has been moderated. Saving to DB: ', moderatedMessage);
//         return event.data.adminRef.update({
//           text: moderatedMessage,
//           sanitized: true,
//           moderated: message.text !== moderatedMessage
//         });
//       }
//     });
