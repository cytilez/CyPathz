
string homePath = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
string cyPathFile = Path.Combine(homePath, ".cypathz");

if(args.Length < 1 || args.Length > 3)
{
    Console.WriteLine($"No such command or path");
    return;
}


string command = args[0];

string currentPath = Directory.GetCurrentDirectory();



if (args.Length == 1)
{

    if(command.Equals("pathz", StringComparison.OrdinalIgnoreCase))
    {
        ListPathz(cyPathFile);
        return;
    }
  
    string? target = FindCyPath(command, cyPathFile);

    if (target != null)
    {
        Console.WriteLine(target);
    }
    else
    {
        Console.WriteLine($"No such command or CyPath: {command}");
    }

    return;

}
else if(args.Length == 2)
{
    string name = args[1];
    string? pathExists = FindCyPath(name, cyPathFile);

    if(command.Equals("add", StringComparison.OrdinalIgnoreCase))

        if(pathExists == null)
        {
            SaveCyPath(name,currentPath,cyPathFile);   
        }
        else
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("CyPath already exists");
            Console.ResetColor();
        }

    else if(command.Equals("rm", StringComparison.OrdinalIgnoreCase))
{
    bool removed = RemoveCyPath(name, cyPathFile);

    if (removed)
    {
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.WriteLine($"Removed CyPath '{name}'");
        Console.ResetColor();
    }
    else
    {
        Console.WriteLine($"CyPath '{name}' does not exist");
    }
}
    else
    {
        Console.WriteLine($"Unknown command {args[0]} ");
        return;
    }

}
else if (args.Length == 3)
{
        string name = args[1];
        string path = args[2];
        string? pathExists = FindCyPath(name, cyPathFile);

        if(command.Equals("add", StringComparison.OrdinalIgnoreCase) && pathExists == null)
        {
            string targetPath;

            if (path.StartsWith("@"))
            {
                targetPath = path[1..];
            }
            else
            {
                targetPath = Path.GetFullPath(
                    Path.Combine(currentPath, path)
                );
            }

                SaveCyPath(name, targetPath, cyPathFile);
    }
    else
    {
        Console.WriteLine($"Unknown command {args[0]}, or CyPath Exists ");
        return;
    }

}

static void ListPathz(string cyPathFile)
{
    Console.ForegroundColor = ConsoleColor.Cyan;

    foreach (var path in File.ReadLines(cyPathFile))
    {
        string[] part = path.Split('=', 2);

        if(part.Length == 2)
        {
            Console.Write($"{part[0],-15}");
            Console.WriteLine($"{part[1]}");
            Console.WriteLine();
        }
        
    }

    Console.ResetColor();
}

static void SaveCyPath(string name, string path, string cyPathFile)
{
    string entry = $"{name}={path}{Environment.NewLine}";
    File.AppendAllText(cyPathFile, entry);
}

static string? FindCyPath(string name, string cyPathFile)
{
    if (!File.Exists(cyPathFile))
    {
        return null;
    }

    foreach (string line in File.ReadLines(cyPathFile))
    {
        string[] parts = line.Split('=', 2);

        if (parts.Length == 2 &&
            parts[0].Equals(name, StringComparison.OrdinalIgnoreCase))
        {
            return parts[1];
        }
    }

    return null;
}

static bool RemoveCyPath(string name, string cyPathFile)
{
    if (!File.Exists(cyPathFile))
    {
        return false;
    }

    string[] lines = File.ReadAllLines(cyPathFile);
    List<string> remainingLines = new();

    bool found = false;

    foreach (string line in lines)
    {
        string[] parts = line.Split('=', 2);

        if (parts.Length == 2 &&
            parts[0].Equals(name, StringComparison.OrdinalIgnoreCase))
        {
            found = true;
            continue;
        }

        remainingLines.Add(line);
    }

    if (!found)
    {
        return false;
    }

    File.WriteAllLines(cyPathFile, remainingLines);

    return true;
}