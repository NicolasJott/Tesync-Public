using System.Text.Json.Serialization;

namespace api.Models;

public class TeslaAccount
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public TeslaAuthToken? AuthToken { get; set; } 
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    [JsonIgnore]
    public User? User { get; set; }
    

}

public class TeslaAuthToken
{
    public string? AccessToken { get; set; } 
    public string? TokenType { get; set; } = null!;
    public double? CreatedAt { get; set; }
    public int? ExpiresIn { get; set; }
    public string? RefreshToken { get; set; } = null!;
    public string? IdToken { get; set; } = null!;
}