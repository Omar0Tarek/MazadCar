const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.myFunction = functions.firestore.document("cars/{docId}")
    .onCreate((snapshot, context) => {
      let title = "New Ad:" + snapshot.data().make;
      title += " " + snapshot.data().model + " " + snapshot.data().year;
      const body = "Start Bidding Price: " + snapshot.data().startPrice;
      return admin.messaging().sendToTopic("New CarAd",
          {notification: {title: title,
            body: body}});
    });


// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
