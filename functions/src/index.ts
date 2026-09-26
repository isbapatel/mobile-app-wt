import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import nodemailer from "nodemailer";

admin.initializeApp();

// Nodemailer Transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "wtwinds26@gmail.com",
    pass: "APP_PASSWORD_HERE",   // Replace with Gmail App Password
  },
});

export const sendWelcomeEmail = onDocumentCreated("users/{userId}", async (event) => {
  const data = event.data?.data() as any;  // <-- fixed line

  if (!data) return;

  const email = data.email;
  const name = data.name ?? "User";

  const mailOptions = {
    from: "WT Winds <wtwinds26@gmail.com>",
    to: email,
    subject: "Welcome to WTWinds!",
    text: `Hello ${name},

You have successfully been registered with us. We are excited to welcome you to our team!
Please join the below WhatsApp group for better communication:

https://chat.whatsapp.com/KCI2tUmUpyMHkqqIuUbuTY

Regards,
Team WTWinds`,
  };

  try {
    await transporter.sendMail(mailOptions);
    logger.info("Email sent to: " + email);
  } catch (error) {
    logger.error("Error sending email:", error);
  }
});