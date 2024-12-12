using api.Models;

namespace api.DTOs.TeslaAccounts;

public class TeslaAccountDto
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public TeslaAuthToken? AuthToken { get; set; } 
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}