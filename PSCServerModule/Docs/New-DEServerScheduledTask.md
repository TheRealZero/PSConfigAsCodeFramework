---
external help file: PSCServerModule-help.xml
Module Name: PSCServerModule
online version:
schema: 2.0.0
---

# New-PSCServerScheduledTask

## SYNOPSIS
Creates a new scheduled task on a server

## SYNTAX

```
New-PSCServerScheduledTask [-ConfigFilePath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script creates a new scheduled task on a server using the parameters in a config file

## EXAMPLES

### EXAMPLE 1
```
New-PSCServerScheduledTask -ConfigFilePath "C:\Scripts\TaskConfig.psd1"
```

## PARAMETERS

### -ConfigFilePath
The path to the config file containing the parameters for the scheduled task

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
