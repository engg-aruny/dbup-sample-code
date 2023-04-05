using Microsoft.EntityFrameworkCore;

namespace dbup_sample_code.Models
{
    public class SchoolDbContext : DbContext
    {
        public SchoolDbContext(DbContextOptions options) : base(options)
        {
        }
    }
}