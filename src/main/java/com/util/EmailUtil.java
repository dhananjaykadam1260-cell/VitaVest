package com.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    public static void sendEmail(String toEmail, String subject, String messageText) {

        final String fromEmail = "elitehp27@gmail.com"; // sender
        final String password = "ttje rzis jwae sgxy";    // Gmail App Password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            }
        );

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageText);

            Transport.send(message);
      

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
