using System.Security.Claims;
using System.Text.Json;
using api.DTOs.TeslaAccounts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Models;
using api.DTOs.Users;
using api.Enums;
using api.Services;
using AutoMapper;
using Azure.Core;
using Microsoft.AspNetCore.Authorization;
using Newtonsoft.Json.Linq;

namespace api.Controllers.Profile;

[Authorize]
[Route("api/profile")]
[ApiController]
public class ProfileController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IMapper _mapper;
    
    public ProfileController(AppDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }
    
    // GET: api/profile
    [HttpGet()]
    public async Task<ActionResult<UserDto>> GetProfile()
    {
        var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        var user = await _context.Users
            .Include(u => u.TeslaAccount) 
            .FirstOrDefaultAsync(u => u.Id == int.Parse(id));


        if (user == null)
        {
            return NotFound();
        }

        var userDto = _mapper.Map<UserDto>(user);
        return userDto;
    }
    
    [HttpPost("tesla-account")]
    public async Task<ActionResult<TeslaAuthToken>> PostUserTeslaAccount(CreateTeslaAccountDto createTeslaAccountDto)
    {
        var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        var user = await _context.Users
            .Include(u => u.TeslaAccount) 
            .FirstOrDefaultAsync(u => u.Id == int.Parse(id));

        if (user == null)
        {
            return NotFound();
        }
        
        if (user.TeslaAccount != null)
        {
            return BadRequest("Tesla account already exists");
        }
            
        var authToken = new TeslaAuthToken
        {
            AccessToken = createTeslaAccountDto.AccessToken,
            TokenType = createTeslaAccountDto.TokenType,
            CreatedAt = createTeslaAccountDto.CreatedAt,
            ExpiresIn = createTeslaAccountDto.ExpiresIn,
            RefreshToken = createTeslaAccountDto.RefreshToken,
            IdToken = createTeslaAccountDto.IdToken
        };
            
        var teslaAccount = new TeslaAccount
        {
            UserId = user.Id,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            AuthToken = authToken
        };
           
            
        _context.TeslaAccounts.Add(teslaAccount);
        await _context.SaveChangesAsync();

        return _mapper.Map<TeslaAuthToken>(teslaAccount.AuthToken);
    }

    [HttpPut("tesla-account")]
    public async Task<ActionResult<TeslaAccountDto>> PutUserTeslaAccount(CreateTeslaAccountDto updateTeslaAccountDto)
    {
        var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        var user = await _context.Users
            .Include(u => u.TeslaAccount) 
            .FirstOrDefaultAsync(u => u.Id == int.Parse(id));

        if (user == null)
        {
            return NotFound();
        }
        
        if (user.TeslaAccount == null)
        {
            return BadRequest("Tesla account does not exist");
        }
        
        var authToken = new TeslaAuthToken
        {
            AccessToken = updateTeslaAccountDto.AccessToken,
            TokenType = updateTeslaAccountDto.TokenType,
            CreatedAt = updateTeslaAccountDto.CreatedAt,
            ExpiresIn = updateTeslaAccountDto.ExpiresIn,
            RefreshToken = updateTeslaAccountDto.RefreshToken,
            IdToken = updateTeslaAccountDto.IdToken
        };
        
        user.TeslaAccount.AuthToken = authToken;
        
        await _context.SaveChangesAsync();
        
        return _mapper.Map<TeslaAccountDto>(user.TeslaAccount);
    }
    
    [HttpPost("command")]
    public async Task<string> FlashLightsAsync(string vehicleVin, VehicleCommand vehicleCommand, [FromBody] JsonElement body)
    {
        var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        var user = await _context.Users
            .Include(u => u.TeslaAccount) 
            .FirstOrDefaultAsync(u => u.Id == int.Parse(id));

        if (user == null)
        {
            return "User not found";
        }
        
        if (user.TeslaAccount == null)
        {
            return "Tesla account does not exist";
        }
  
        var vehicleCommandsService = new VehicleCommandsService();
        var response =  vehicleCommandsService.FlashLights(vehicleVin, user.TeslaAccount.AuthToken.AccessToken, vehicleCommand, body);
        
        return response;
    }
    
}