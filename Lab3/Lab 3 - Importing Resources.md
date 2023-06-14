# How to convert deployed resources into Terraform Files.

In this lab, we are going to export the Hub resourece group created in Lab 2 and compare the exported file against the original deployment

1. Download aztfexport from:

    - [Aztf export Github Releases Page](https://github.com/Azure/aztfexport/releases)

Extract the zip file in an accesible place, for example **'C:\aztfexport'**. Optionally, you can add aztfexport folder to the path.

2. Go into the Aztfexport directory an create a new folder **'hub'**

3. Open a powershell, and navigate to  folder. Connect to Azure with Azure Cli

    ```
    cd c:\aztfexport\hub
    az login
    ```

4. Run Aztfexport for exporting the Hub Resource group

    ```
    c:\aztfexport\aztfexport.exe rg --non-interactive hub
    ```

5. Open the generated main.tf file and observe the differences against the original file.

[Back to Index](/README.md)

