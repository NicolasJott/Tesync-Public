namespace api.Services;

public class PasswordService
{
    // Function to hash the password using BCrypt
    public static string HashPassword(string password)
    {
        // Use BCrypt to generate a hashed password
        return BCrypt.Net.BCrypt.HashPassword(password);
    }

    // Function to compare a plain text password with a hashed password
    public static bool VerifyPassword(string plainTextPassword, string hashedPassword)
    {
        // Use BCrypt to compare the plain text password with the hashed password
        return BCrypt.Net.BCrypt.Verify(plainTextPassword, hashedPassword);
    }
    
}