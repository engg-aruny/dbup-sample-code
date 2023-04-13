### What is Dbup Migration?
**DbUp** Migration is a free tool for .NET that simplifies the process of deploying and upgrading databases for SQL Server, MySQL, PostgreSQL, Oracle, and SQLite. It automates the management of database schema and data changes by applying scripts to your target database.

### How do **Code First Migration** and **Dbup Migration** compare with each other?
Code First Migration and DbUp Migration are both tools used for managing database schema and data changes in .NET applications, but they have different approaches and features. 

**Code First Migration** is a feature of Entity Framework, an ORM tool for .NET. It enables you to define database changes using C# code, which can then be used to generate SQL scripts. This approach is helpful for developers who prefer working with C# code and want to use Entity Framework's features, such as data modeling and querying. Learn [Beginners: Code First Database Migration in Entity Framework](https://www.arunyadav.in/codehacks/blogs/post/39/beginners-code-first-database-migration-in-entity-framework) from the previous article.

**DbUp Migration** is a standalone migration tool that allows you to define database changes using SQL scripts. It's a more flexible tool that supports multiple database platforms and allows you to write plain SQL scripts to define database changes. Additionally, DbUp Migration offers advanced features such as transactional migrations, conditional scripts, and pre-processing scripts.

### How can **Dbup Migration** be implemented?

> The [source code](https://github.com/engg-aruny/dbup-sample-code/archive/refs/heads/master.zip) for this article can be found on GitHub. 

> This article is based on .Net Core 6

#### A step-by-step guide to implementing Dbup Migration Migration

1. Add NuGet Package

```bash
install-package DBup
```

> `install-package` needs to run in Visual Studio and open the Package Manager Console from Tools

2. Add Required classes and pieces, before dbup implementation 

```json
{
 "ConnectionStrings": {
        "SchoolDb": "Server=localhost;Database=DPSSchoolDb;Trusted_Connection=SSPI;Encrypt=false;TrustServerCertificate=true"
    }
}
```

**Program.cs**

```csharp
var connectionString = builder.Configuration.GetConnectionString("SchoolDb");

builder.Services.AddDbContextPool<SchoolDbContext>(option =>
{
    option.UseSqlServer(connectionString);
});
```

**SchoolDbContext.cs**

```csharp
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
```

3. Register Dbup in program.cs

```csharp
static void RunMigration(string? connectionString)
{
    var upgrader =
            DeployChanges.To
                .SqlDatabase(connectionString)
                .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                .LogToConsole()
                .Build();

    var result = upgrader.PerformUpgrade();

    if (!result.Successful)
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine(result.Error);
        Console.ResetColor();
    }
    Console.ForegroundColor = ConsoleColor.Green;
    Console.WriteLine("Success!");
    Console.ResetColor();
}
```

4. Add-Migration Scripts: You can group scripts in any fashion, here grouping is based on `month (04) and script number (001-[ScriptName])`. See the following snapshot. 

![Add-Migration Scripts](https://www.dropbox.com/s/h38pxfqs4a1x91f/Add_Migrations_Scripts.jpg?raw=1 "Add-Migration Scripts")

> All `one-time scripts` should include checking for existing data and resources and making sure data or resource is not duplicated on the SQL Server side. These scripts are run exactly once per database, and never again. Think of things like creating table... statements. You can't create a table twice so any attempt to run the script second-time results in an error. 

Make sure to enable `Embedded resource` and `Copy always` from file properties, see the snapshot below.

![Embedded resource](https://www.dropbox.com/s/a3rcwai7qddr46y/Copy_always_option.jpg?raw=1 "Embedded resource")

### Output Window - Notice all scripts ran successfully with no issues.

![Output Window](https://www.dropbox.com/s/ew72309hz0n27wl/output_migrations.jpg?raw=1 "Output Window")

### SQL Server View - Tables are created through automatic migration
![SQL Server View](https://www.dropbox.com/s/cth6yrt8e2enc7j/database_after_migration.jpg?raw=1 "SQL Server View")

> `SchemaVersions` is a table that DBUp uses to keep track of the version of the database schema as it changes over time through migrations. It helps to ensure that the database schema is up-to-date and provides a history of the changes made to the schema.

> DbUp Migration also offers the ability to run migrations from a command line or from within a CI/CD pipeline, which can streamline the deployment process. 
 
### What benefits does **Dbup Migration** offer?
DbUp Migration is an excellent tool for managing database schema and data changes in .NET applications. It offers many benefits, including:

1. **Simplified deployment**: With DbUp Migration, you can define database changes using plain SQL scripts, which makes deploying changes much simpler. It also ensures that changes are applied consistently across all environments.
2. **Multi-platform support:**  DbUp Migration supports multiple database platforms, including SQL Server, MySQL, PostgreSQL, Oracle, and SQLite. 
3. **Version control:** DbUp Migration lets you store your SQL scripts in version control. This ensures that changes are properly tested and reviewed before they are applied to production environments.
4. **Advanced features:** such as transactional migrations, conditional scripts, post-deployment scripts, and pre-processing scripts
5. Open-source: DbUp Migration is an open-source tool, which means it is free to use and can be customized as per need.

> The [source code](https://github.com/engg-aruny/dbup-sample-code/archive/refs/heads/master.zip) for this article can be found on GitHub. 

### Summary
In summary, DbUp Migration is a free and open-source tool for .NET that simplifies the process of deploying and upgrading databases. It allows you to define database changes using plain SQL scripts and supports multiple database platforms. DbUp Migration offers advanced features such as transactional migrations, conditional scripts, post-deployment scripts, and pre-processing scripts. It is highly extensible and customizable and can be run from the command line or within a CI/CD pipeline. Overall, DbUp Migration can streamline the database deployment process and make it easier to manage schema and data changes.
