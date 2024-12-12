using Microsoft.EntityFrameworkCore;

namespace api.Models;

public class AppDbContext : DbContext
{
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<TeslaAccount> TeslaAccounts { get; set; } = null!;
    
    private readonly IConfiguration _configuration;

    public AppDbContext(IConfiguration configuration)
    {
        _configuration = configuration;
    }
    
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(_configuration.GetConnectionString("DefaultConnection"));
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>()
            .HasOne(user => user.TeslaAccount)
            .WithOne(teslaAccount => teslaAccount.User)
            .HasForeignKey<TeslaAccount>(teslaAccount => teslaAccount.UserId);
        
        modelBuilder.Entity<TeslaAccount>()
            .OwnsOne(teslaAccount => teslaAccount.AuthToken, builder =>
            {
                builder.ToJson(); 
            });
    }

}