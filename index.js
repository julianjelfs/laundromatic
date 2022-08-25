import { Elm } from "./src/Main.elm";

import * as firebase from "firebase/app";

import "firebase/auth";
import "firebase/firestore";
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
dayjs.extend(relativeTime);

const firebaseConfig = {
  apiKey: "AIzaSyCTXei5G7r8CZZfqKcw_sHCgVza0qCxpVY",
  authDomain: "laundromatic.firebaseapp.com",
  databaseURL: "https://laundromatic.firebaseio.com",
  projectId: "laundromatic",
  storageBucket: "laundromatic.appspot.com",
  messagingSenderId: "587869683063",
  appId: "1:587869683063:web:1a985df43d2f0e495e3572",
};

firebase.initializeApp(firebaseConfig);

let elm;
firebase.auth().onAuthStateChanged((user) => {
  elm = Elm.Main.init({
    node: document.getElementById("root"),
    flags: { user: user },
    replace: false,
  });

  elm.ports.signIn.subscribe(([username, password]) => {
    firebase
      .auth()
      .signInWithEmailAndPassword(username, password)
      .catch((err) => {
        elm.ports.signInError.send(err.message);
      });
  });

  elm.ports.signOut.subscribe(() => {
    firebase.auth().signOut();
  });

  elm.ports.washItem.subscribe((item) => {
    const doc = db.collection(collection(user)).doc(item.id);
    doc
      .set(
        {
          lastWashed: +today(),
        },
        { merge: true }
      )
      .then(() => getData(user));
  });

  elm.ports.deleteItem.subscribe((item) => {
    db.collection(collection(user))
      .doc(item.id)
      .delete()
      .then(() => getData(user));
  });

  elm.ports.addNewItem.subscribe(([name, intervalInDays, lastWashedDays]) => {
    const now = today();
    const lastWashed = now.subtract(lastWashedDays, "day");
    db.collection(collection(user))
      .add({
        name,
        intervalInDays,
        lastWashed: +lastWashed,
      })
      .then(() => getData(user))
      .catch((err) => {
        elm.ports.addNewError.send(err.message);
      });
  });

  getData(user);
});

const db = firebase.firestore();

function getData(user) {
  if (!user) return;

  db.collection(collection(user))
    .get()
    .then((query) => {
      const items = [];
      const now = today();
      query.forEach((item) => {
        const data = item.data();
        const lw = dayjs(data.lastWashed);
        const dueOn = lw.add(data.intervalInDays, "day");
        const dueInDays = dueOn.diff(now, "day");
        items.push({
          id: item.id,
          ...item.data(),
          dueInDays,
        });
      });
      if (elm) {
        elm.ports.receivedItems.send(items);
      }
    });
}

function today() {
  return dayjs().hour(12).minute(0).second(0).millisecond(0);
}

function collection({ uid }) {
  return `${uid}_items`;
}
