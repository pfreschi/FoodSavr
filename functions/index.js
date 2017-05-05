// load the firebase-functions and firebase-admin modules,
// and initialize an admin app instance from which Realtime Database changes can be made.
const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var db = admin.database();
var ref = db.ref("/receipts/");

exports.getReceiptText = functions.database.ref('/receipts/{receiptId}/pic')
    .onWrite(event => {
      // Only edit data when it is first created.
      if (event.data.previous.exists()) {
        console.log("receipt was added");
        return;
      }
      // Exit when the data is deleted.
      if (!event.data.exists()) {
        console.log("receitp was deleted");
      }
    });


// // create the request_url
// API_KEY = APIKEY
// image_url = "https://firebasestorage.googleapis.com/v0/b/foodsavr-1347f.appspot.com/o/receipts%2Fg2rrAida7mUczgUb4Qwn9uCiVd32%2F513484257067.jpg?alt=media&token=7239ee08-ed37-4e20-af2c-95f33268ec2a";
// request_url = "https://api.ocr.space/parse/imageurl?apikey=" + API_KEY + "&url=" + image_url;
//
// // sending request
// var xhr = new XMLHttpRequest();
// xhr.open('GET', request_url, true);
// xhr.send();
//
// // returns text from image
// function getReceiptText(e) {
//     if (xhr.readyState == 4 && xhr.status == 200) {
//       var response = JSON.parse(xhr.responseText);
//       return response.ParsedResults[0].ParsedText;
//
//     }
// }
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
