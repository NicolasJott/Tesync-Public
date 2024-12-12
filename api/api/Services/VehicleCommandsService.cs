using System.Diagnostics;
using System.Text.Json;
using api.Enums;
using api.Extensions;

namespace api.Services;

public class VehicleCommandsService
{
    public string FlashLights(string vehicleVin, string bearerToken, VehicleCommand vehicleCommand, JsonElement body)
    {
        var command = vehicleCommand.ToApiPath();

        var jsonBody = JsonSerializer.Serialize(body);

        var escapedBody = jsonBody.Replace("'", "'\\''");
        
        // Build the curl command
        // Build the curl command
        var curlCommand = $@"
                curl --cacert cert.pem \
                     -H 'Content-Type: application/json' \
                     -H 'Authorization: Bearer {bearerToken}' \
                     --data '{escapedBody}' \
                     -X POST \
                     -i https://localhost:4443/api/1/vehicles/{vehicleVin}/command/{command}
                ";


        return ExecuteCurlCommandWithArgumentList(curlCommand);
    }

    private string ExecuteCurlCommandWithArgumentList(string command)
    {
        var processInfo = new ProcessStartInfo("bash")
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        // Tokenize the curl command manually (ensure proper escaping)
        processInfo.ArgumentList.Add("-c");
        processInfo.ArgumentList.Add(command);

        try
        {
            using (var process = Process.Start(processInfo))
            {
                var output = process.StandardOutput.ReadToEnd();
                var error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                if (!string.IsNullOrEmpty(error))
                {
                    throw new Exception($"Curl execution failed: {error}");
                }

                return output;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
            throw;
        }
    }

}