package com.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public static boolean checkPassword(String plain, String hashed) {
        return BCrypt.checkpw(plain, hashed);
    }
}
