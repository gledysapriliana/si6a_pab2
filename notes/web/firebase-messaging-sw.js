importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js",
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js",
);

// Gunakan konfigurasi web dari firebase_options.dart Anda
firebase.initializeApp({
  apiKey: "AIzaSyC0il4o6dZ5PlLc2cBWqN408YeeFYOHDyk",
  authDomain: "notes-925af.firebaseapp.com",
  projectId: "notes-925af",
  storageBucket: "notes-925af.firebasestorage.app",
  messagingSenderId: "389276304056",
  appId: "1:389276304056:web:27e8be672dceafe848aa4d",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/favicon.png",
  };
  return self.registration.showNotification(
    notificationTitle,
    notificationOptions,
  );
});
