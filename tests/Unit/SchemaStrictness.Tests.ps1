Describe 'Settings example and schema' {
    It 'settings.example.json is valid JSON' {
        $path = Join-Path $PSScriptRoot '..\..\config\settings.example.json'
        $content = Get-Content -Path $path -Raw
        { $null = $content | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'schema requires top-level keys and example follows schema shape' {
        $s = Join-Path $PSScriptRoot '..\..\config\settings.example.json'
        $schema = Join-Path $PSScriptRoot '..\..\config\settings.schema.json'
        $schemaObj = Get-Content -Path $schema -Raw | ConvertFrom-Json
        # Schema must require global and roles
        $schemaObj.required | Should -Contain 'global'
        $schemaObj.required | Should -Contain 'roles'

        # Example must contain the top-level keys
        $ex = Get-Content -Path $s -Raw | ConvertFrom-Json
        $ex.PSObject.Properties.Name | Should -Contain 'global'
        $ex.PSObject.Properties.Name | Should -Contain 'roles'
        # roles must be an array with at least one element and each entry has id and parameters
        $ex.roles | Should -Not -BeNullOrEmpty
        $first = $ex.roles[0]
        $first.PSObject.Properties.Name | Should -Contain 'id'
        $first.PSObject.Properties.Name | Should -Contain 'parameters'
    }
}
