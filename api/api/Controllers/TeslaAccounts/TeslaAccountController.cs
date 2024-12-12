using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api.Models;

namespace api.Controllers
{
    [Route("api/tesla-accounts")]
    [ApiController]
    public class TeslaAccountController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TeslaAccountController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/TeslaAccount
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TeslaAccount>>> GetTeslaAccounts()
        {
            return await _context.TeslaAccounts.ToListAsync();
        }

        // GET: api/TeslaAccount/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TeslaAccount>> GetTeslaAccount(int id)
        {
            var teslaAccount = await _context.TeslaAccounts.FindAsync(id);

            if (teslaAccount == null)
            {
                return NotFound();
            }

            return teslaAccount;
        }

        // PUT: api/TeslaAccount/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTeslaAccount(int id, TeslaAccount teslaAccount)
        {
            if (id != teslaAccount.Id)
            {
                return BadRequest();
            }

            _context.Entry(teslaAccount).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TeslaAccountExists(id))
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

        // POST: api/TeslaAccount
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TeslaAccount>> PostTeslaAccount(TeslaAccount teslaAccount)
        {
            _context.TeslaAccounts.Add(teslaAccount);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTeslaAccount", new { id = teslaAccount.Id }, teslaAccount);
        }

        // DELETE: api/TeslaAccount/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTeslaAccount(int id)
        {
            var teslaAccount = await _context.TeslaAccounts.FindAsync(id);
            if (teslaAccount == null)
            {
                return NotFound();
            }

            _context.TeslaAccounts.Remove(teslaAccount);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TeslaAccountExists(int id)
        {
            return _context.TeslaAccounts.Any(e => e.Id == id);
        }
    }
}
