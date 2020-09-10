import { Elm } from "./src/Main.elm";

import * as firebase from "firebase/app";

import "firebase/auth";
import "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyCTXei5G7r8CZZfqKcw_sHCgVza0qCxpVY",
  authDomain: "laundromatic.firebaseapp.com",
  databaseURL: "https://laundromatic.firebaseio.com",
  projectId: "laundromatic",
  storageBucket: "laundromatic.appspot.com",
  messagingSenderId: "587869683063",
  appId: "1:587869683063:web:1a985df43d2f0e495e3572"
};

firebase.initializeApp(firebaseConfig);

let elm; 
firebase.auth().onAuthStateChanged((user) => {
    elm = Elm.Main.init({
      node: document.getElementById('root'),
      flags: { user: user },
      replace: false,
    });

    elm.ports.signIn.subscribe(([username, password]) => {
      firebase.auth().signInWithEmailAndPassword(username, password).catch(err => { 
        elm.ports.signInError.send(err.message);
      });
    });

    elm.ports.signOut.subscribe(() => {
      firebase.auth().signOut();
    });

    elm.ports.washItem.subscribe((item) => {
      const doc = db.collection('items').doc(item.id);
      doc.set({
        lastWashed: +new Date()
      }, { merge: true}).then(getData)
    });

    elm.ports.deleteItem.subscribe((item) => {
      db.collection('items').doc(item.id).delete().then(getData)
    });

    elm.ports.addNewItem.subscribe(([name, intervalInDays, lastWashedDays]) => {
      const now = +new Date();
      const diff = lastWashedDays * 24 * 60 * 60 * 1000;
      db.collection('items').add({
        name, 
        intervalInDays,
        lastWashed: now - diff,
      }).then(getData).catch(err => {
        elm.ports.addNewError.send(err.message);
      })
    });

    if(user) {
      getData();
    }
})


const db = firebase.firestore();

function getData() {
  db.collection('items').get().then(query => {
    const items = [];
    query.forEach(item => {
      items.push({
        id: item.id,
        ...item.data(),
      })
    })
    if (elm) {
      elm.ports.receivedItems.send(items);
    }
  })
}