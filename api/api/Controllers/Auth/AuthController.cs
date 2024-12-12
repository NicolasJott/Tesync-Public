using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Models;
using api.DTOs.Users;
using api.DTOs.Auth;
using api.Services;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;

namespace api.Controllers.Auth;

[AllowAnonymous]
[Route("api/auth")]
[ApiController]
public class AuthController : ControllerBase
{

    private readonly AppDbContext _context;
    private readonly IMapper _mapper;
    private readonly TokenService _tokenService;
    
    public AuthController(AppDbContext context, IMapper mapper, TokenService tokenService)
    {
        _context = context;
        _mapper = mapper;
        _tokenService = tokenService;
    }
    
    // POST: api/auth/login
    
    [HttpPost("login")]
    public async Task<ActionResult<AuthTokenDto>> Login(LoginDto loginDto)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginDto.Email);
        if (user == null)
        {
            return NotFound();
        }

        if (!PasswordService.VerifyPassword(loginDto.Password, user.PasswordHash))
        {
            return Unauthorized();
        }
        
        var token = _tokenService.GenerateJwtToken(user);
        
        var authTokenDto = new AuthTokenDto
        {
            Token = token
        };

        
        return authTokenDto;
    }
    
    // POST: api/auth/register
    [HttpPost("register")]
    public async Task<ActionResult<AuthTokenDto>> PostUser(CreateUserDto createUserDto)
    {

        var user = new User
        {
            Email = createUserDto.Email,
            PasswordHash = PasswordService.HashPassword(createUserDto.Password),
            FirstName = createUserDto.FirstName,
            LastName = createUserDto.LastName,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
            
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token = _tokenService.GenerateJwtToken(user);
        
        var authTokenDto = new AuthTokenDto
        {
            Token = token
        };

        
        return authTokenDto;
    }
    
}