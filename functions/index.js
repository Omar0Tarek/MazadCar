const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Sends a notifications to all users when a new message is posted.
exports.sendChatNotifications = functions.firestore.document('chats/{chatId}/messages/{messageId}').onCreate(
  async (snapshot, context) => {
    functions.logger.log('Started Execution.');
    // Notification details.
    const text = snapshot.data().content;
    const payload = {
      notification: {
        title: `${snapshot.data().senderName} sent you a message!`,
        body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
        // icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
        // click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
      }
    };

    functions.logger.log(`Text: ${text}`);
    functions.logger.log(`Payload: ${text}`);

    const chatId = context.params.chatId;
    const chat = await admin.firestore().collection("chats").doc(chatId).get();
    const buyerId = chat.data()?.buyerID;
    const sellerId = chat.data()?.sellerID;
    const senderId = snapshot.data().senderID;

    const recieverId = senderId == buyerId ? sellerId : buyerId;


    functions.logger.log(`chatId: ${chatId}`);
    functions.logger.log(`chat: ${JSON.stringify(chat)}`);
    functions.logger.log(`buyerId: ${buyerId}`);
    functions.logger.log(`sellerId: ${sellerId}`);
    functions.logger.log(`senderId: ${senderId}`);
    functions.logger.log(`recieverId: ${recieverId}`);
    

    const reciever = await admin.firestore().collection("users").doc(recieverId).get();
    const tokens = reciever.data()?.tokens;

    functions.logger.log(`tokens: ${tokens}`);

    if (tokens.length > 0) {
      // Send notifications to all tokens.
      const response = await admin.messaging().sendToDevice(tokens, payload).then((response) => {
        console.log("Notification Sent successfully");
        console.log(response);
      });
      await cleanupTokens(response, tokens);
      functions.logger.log('Notifications have been sent and tokens cleaned up.');
    }
  }
);

// Cleans up the tokens that are no longer valid.
function cleanupTokens(response, tokens) {
  // For each notification we check if there was an error.
  const tokensDelete = [];
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
      functions.logger.error('Failure sending notification to', tokens[index], error);
      // Cleanup the tokens that are not registered anymore.
      if (error.code === 'messaging/invalid-registration-token' ||
          error.code === 'messaging/registration-token-not-registered') {
        const deleteTask = admin.firestore().collection('fcmTokens').doc(tokens[index]).delete();
        tokensDelete.push(deleteTask);
      }
    }
  });
  return Promise.all(tokensDelete);
 }


// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
