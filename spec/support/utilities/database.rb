def remove_all_databases(url:)
    powershell = <<-POWERSHELL
    $databases = Invoke-RestMethod -Method Get -Uri 'http://localhost:8081/databases'
    foreach($database in $databases)
    {
      Invoke-RestMethod -Method Delete -Uri "http://localhost:8081/admin/databases/$database"  
    }
   
    POWERSHELL
    # on(default, powershell(powershell))
    execute_powershell_script_on(default, powershell)
end