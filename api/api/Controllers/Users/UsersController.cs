using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using api.DTOs.TeslaAccounts;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Models;
using api.DTOs.Users;
using api.Services;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;


namespace api.Controllers.Users
{
    [Authorize]
    [Route("api/users")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IMapper _mapper;

        public UsersController(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // GET: api/users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDto>>> GetUsers()
        {
            var users = await _context.Users.ToListAsync();
            var userDtos = _mapper.Map<IEnumerable<UserDto>>(users);
            return Ok(userDtos);
        }

        // GET: api/users/5
        [HttpGet("{id}")]
        public async Task<ActionResult<UserDto>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            var userDto = _mapper.Map<UserDto>(user);
            return userDto;
        }

        // PUT: api/users/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, UpdateUserDto updateUserDto)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }
            
            _mapper.Map(updateUserDto, user);
            
            user.UpdatedAt = DateTime.UtcNow;

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/users
        [HttpPost]
        public async Task<ActionResult<User>> PostUser( CreateUserDto createUserDto)
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

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }
        
        // POST: api/users/{id}/tesla-account
        [HttpPost("{id}/tesla-account")]
        public async Task<ActionResult<TeslaAccountDto>> PostUserTeslaAccount(int id, CreateTeslaAccountDto createTeslaAccountDto)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
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
                UserId = id,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                AuthToken = authToken
            };
           
            
            _context.TeslaAccounts.Add(teslaAccount);
            await _context.SaveChangesAsync();

            return _mapper.Map<TeslaAccountDto>(teslaAccount);
        }

        // DELETE: api/uers/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserExists(int id)
        {
            return _context.Users.Any(e => e.Id == id);
        }
    }
}
