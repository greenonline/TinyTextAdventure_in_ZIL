# TinyTextAdventure_in_ZIL
A tiny text adventure in ZIL

## Preamble

This is the code for the ZIL port of TinyTextAdventure, `tenline.zil`, as written by [Jason Compton](https://www.youtube.com/channel/UCgi9B58U9QWxuZV9Du6l5LQ) in the video [Tiny Text Adventure: From ZX81 to VIC-20 to Ultimate 64](https://www.youtube.com/watch?v=_d2g5BXdyfU).

As the ZIL code didn't seem to have been made available, I transcribed it and posted it here. Skip to the bottom of the page for the ZIL port code, if you want to avoid having to read about trying to get `zilf` working on a Mac running Catalina.

One point of note: Why [was it decided](https://rec.arts.int-fiction.narkive.com/WoLS9RmC/zilf-a-zil-compiler) to write ZILF in C# and .NET? It was rather frustrating trying to get a version of ZILF to run on macOS Catalina (10.15.8).

## Links

 - [Tiny Text Adventure: From ZX81 to VIC-20 to Ultimate 64](https://www.youtube.com/watch?v=_d2g5BXdyfU)
 - [ZIL Info Repo:ZIL_Resources](https://github.com/heasm66/ZIL-Resources/tree/master)


### Vaguely related

 - [Ten Liner Cave](https://www.sharpmz.no/forum/viewtopic.php?t=374)
 - [How should I parse user input in a text adventure game?](https://gamedev.stackexchange.com/q/27004/202187)


## Notes

### Getting started

How does one go about setting up on the Mac? What binaries are required?

Note: I placed all ZIL related files and directories in a directory named `ZILF/`, under my `~/Downloads/` directory, in order to keep all the files together.

#### ZILF source code

The readme of [zilf](https://github.com/taradinoc/zilf) was useful for getting started.

 - [Releases](https://foss.heptapod.net/zilf/zilf/-/releases) – [ZILF 0.11.1](https://foss.heptapod.net/zilf/zilf/-/releases/0.11.1)
   - Get the macOS version tarball of `zilf`
 - Unzip
 - `cd` into `bin/`
 - run `zilf yourfile.zil`

Unfortunately, only Apple Silicon builds of `zilf` are available, not Intel, so you'll have to compile the source, if you have an older Mac.

Therefore, I downloaded, from the **Assets** section of [ZILF 0.11.1](https://foss.heptapod.net/zilf/zilf/-/releases/0.11.1), the [Source code (zip)](https://foss.heptapod.net/zilf/zilf/-/archive/0.11.1/zilf-0.11.1.zip), expanded and changed directory.

```none
cd ../../zilf-0.11.1
```

#### `dotnet`

You'll also need [dotnet](https://dotnet.microsoft.com/en-us/download/dotnet/9.0). Luckily there is an x86 build of SDK 9.0.310. I downloaded the binaries not the package/installer. 

### How NOT to do it - The "double click" mistake

(Skip forward to the section **Using `gunzip` and `tar`** below, if you don't want to know what you ***shouldn't do***.)

Then uncompress *by double-clicking* the `.tar.gz` file. Drag the `dotnet` binary into the `zilf-0.11.1/` directory.

```none
% ./dotnet build Zilf.sln
Error: [/Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr] does not exist
Failed to resolve libhostfxr.dylib [not found]. Error code: 0x80008083
%
```

Dragging the `host` directory into the `zilf-0.11.1/` directory

```none
% ./dotnet build Zilf.sln
Failed to load /Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib, error: dlopen(/Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib, 1): Symbol not found: __ZNSt3__113basic_filebufIcNS_11char_traitsIcEEE4openEPKcj
  Referenced from: /Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib (which was built for Mac OS X 12.0)
  Expected in: /usr/lib/libc++.1.dylib

The library libhostfxr.dylib was found, but loading it from /Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib failed
  - Installing .NET prerequisites might help resolve this problem.
     https://go.microsoft.com/fwlink/?linkid=2063366
Failed to resolve libhostfxr.dylib [/Users/macbook/Downloads/ZILF/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib]. Error code: 0x80008082
%
```

I guess the installer for `dotnet` might be easier, as it should set the paths? However, the installer requires MacOS 12. Catalina just isn't good enough. So, I gave up. Ponitless!!!!

Trying 9.0.2, and 9.0.0 RC1, resulted in the same issue.

Following these intrructions from [install-macos.md](https://github.com/dotnet/core/blob/main/release-notes/9.0/install-macos.md)

```none
~# curl -Lo dotnet.tar.gz https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.308/dotnet-sdk-9.0.308-osx-x64.tar.gz
~# mkdir dotnet
~# tar -C dotnet -xf dotnet.tar.gz
~# rm dotnet.tar.gz
~# export DOTNET_ROOT=~/dotnet
~# export PATH=$PATH:~/dotnet
~# dotnet --version
```

Adjusting the env vars slightly

```none
~# export DOTNET_ROOT=~/downloads/ZILF/dotnet
~# export PATH=$PATH:~/dowloads/ZILF/dotnet
```

This ended up resulting in the same `libc++.1.dylib` error:

```
% dotnet --version
Failed to load /Users/macbook/dotnet/host/fxr/9.0.11/libhostfxr.dylib, error: dlopen(/Users/macbook/dotnet/host/fxr/9.0.11/libhostfxr.dylib, 1): Symbol not found: __ZNSt3__113basic_filebufIcNS_11char_traitsIcEEE4openEPKcj
  Referenced from: /Users/macbook/dotnet/host/fxr/9.0.11/libhostfxr.dylib (which was built for Mac OS X 12.0)
  Expected in: /usr/lib/libc++.1.dylib

The library libhostfxr.dylib was found, but loading it from /Users/macbook/dotnet/host/fxr/9.0.11/libhostfxr.dylib failed
  - Installing .NET prerequisites might help resolve this problem.
     https://go.microsoft.com/fwlink/?linkid=2063366
Failed to resolve libhostfxr.dylib [/Users/macbook/dotnet/host/fxr/9.0.11/libhostfxr.dylib]. Error code: 0x80008082
```

Then I came across this Github issue, [dotnet 9 fails on macOS Catalina due to a missing symbol in libc++ #45382](https://github.com/dotnet/sdk/issues/45382). This issue states that [dotnet 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) works on Catalina. 

I tried 8.0.417, which resulted in a new, but different, error:

```none
% ./dotnet --version
Failed to load /Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/shared/Microsoft.NETCore.App/8.0.23/libhostpolicy.dylib, error: dlopen(/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/shared/Microsoft.NETCore.App/8.0.23/libhostpolicy.dylib, 1): no suitable image found.  Did find:
	/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/shared/Microsoft.NETCore.App/8.0.23/libhostpolicy.dylib: code signature in (/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/shared/Microsoft.NETCore.App/8.0.23/libhostpolicy.dylib) not valid for use in process using Library Validation: library load disallowed by system policy
An error occurred while loading required library libhostpolicy.dylib from [/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/shared/Microsoft.NETCore.App/8.0.23]
```

Trying [dotnet 7](https://dotnet.microsoft.com/en-us/download/dotnet/7.0), resulted in a similar error:

```none
 % ./dotnet --version
Failed to load /Users/macbook/Downloads/ZILF/dotnet-sdk-7.0.410-osx-x64/shared/Microsoft.NETCore.App/7.0.20/libhostpolicy.dylib, error: dlopen(/Users/macbook/Downloads/ZILF/dotnet-sdk-7.0.410-osx-x64/shared/Microsoft.NETCore.App/7.0.20/libhostpolicy.dylib, 1): no suitable image found.  Did find:
	/Users/macbook/Downloads/ZILF/dotnet-sdk-7.0.410-osx-x64/shared/Microsoft.NETCore.App/7.0.20/libhostpolicy.dylib: code signature in (/Users/macbook/Downloads/ZILF/dotnet-sdk-7.0.410-osx-x64/shared/Microsoft.NETCore.App/7.0.20/libhostpolicy.dylib) not valid for use in process using Library Validation: library load disallowed by system policy
An error occurred while loading required library libhostpolicy.dylib from [/Users/macbook/Downloads/ZILF/dotnet-sdk-7.0.410-osx-x64/shared/Microsoft.NETCore.App/7.0.20]
```

Trying [v6](https://dotnet.microsoft.com/en-us/download/dotnet/6.0), likewise:

```none
 % ./dotnet --version
Failed to load /Users/macbook/Downloads/ZILF/dotnet-sdk-6.0.428-osx-x64/shared/Microsoft.NETCore.App/6.0.36/libhostpolicy.dylib, error: dlopen(/Users/macbook/Downloads/ZILF/dotnet-sdk-6.0.428-osx-x64/shared/Microsoft.NETCore.App/6.0.36/libhostpolicy.dylib, 1): no suitable image found.  Did find:
	/Users/macbook/Downloads/ZILF/dotnet-sdk-6.0.428-osx-x64/shared/Microsoft.NETCore.App/6.0.36/libhostpolicy.dylib: code signature in (/Users/macbook/Downloads/ZILF/dotnet-sdk-6.0.428-osx-x64/shared/Microsoft.NETCore.App/6.0.36/libhostpolicy.dylib) not valid for use in process using Library Validation: library load disallowed by system policy
An error occurred while loading required library libhostpolicy.dylib from [/Users/macbook/Downloads/ZILF/dotnet-sdk-6.0.428-osx-x64/shared/Microsoft.NETCore.App/6.0.36]
```

It should be noted that while `./dotnet` executes just fine, `./dotnet --version` causes the errors.

It should also be noted that v8, v7, and v6 also popped up a dialog saying the following.

```none
"Microsoft.NETCore.App.app" is damaged and can't be opened. You should move it to the Bin.
```

[![Microsoft Core damaged dialog][1]][1]

Is this corruption normal? It seems unlikely. Is the `.tar.gz` being corrrupted whilst being expanded? Maybe double clicking isn't a good idea and `gunzip` and `tar` should be used, instead..?

### Using `gunzip` and `tar`

[v5](https://dotnet.microsoft.com/en-us/download/dotnet/5.0) was the last version without an `Arm64` download. Extracted using `gunzip`/`tar` (and *not* by double clicking):

```none
% ./dotnet --version
5.0.408
```

It works! 

Is the file corruption issue, of the previous section, due to the double clicking and the Apple expansion/inflation? Retrying v6, but uncompressing using `gunzip` and `tar`, made it work this time:

```none
% gunzip dotnet-sdk-6.0.428-osx-x64.tar.gz
% mkdir dotnet-sdk-6.0.428-osx-x64
% mv dotnet-sdk-6.0.428-osx-x64.tar dotnet-sdk-6.0.428-osx-x64
% cd dotnet-sdk-6.0.428-osx-x64
% tar xvf dotnet-sdk-6.0.428-osx-x64.tar
% ./dotnet --version
6.0.428
```

Similarly for v7:

```none
% cd ../dotnet-sdk-7.0.410-osx-x64        
% gunzip dotnet-sdk-7.0.410-osx-x64.tar.gz
% tar xvf dotnet-sdk-7.0.410-osx-x64.tar
% ./dotnet --version
7.0.410
```

Similarly for v8:

```none
% gunzip dotnet-sdk-8.0.417-osx-x64.tar.gz                    
% mkdir dotnet-sdk-8.0.417-osx-x64                           
% mv dotnet-sdk-8.0.417-osx-x64.tar dotnet-sdk-8.0.417-osx-x64
% cd dotnet-sdk-8.0.417-osx-x64                               
% tar xvf dotnet-sdk-8.0.417-osx-x64.tar                      
% ./dotnet --version
8.0.417
% export DOTNET_ROOT=~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64
% export PATH=$PATH:~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64 
% dotnet --version
```

However, retrying for v9, as expected, is *still* broken (for Catalina):

```none
% ./dotnet --version
Failed to load /Users/macbook/Downloads/ZILF/dotnet-sdk-9.0.310-osx-x64/host/fxr/9.0.12/libhostfxr.dylib, error: dlopen(/Users/macbook/Downloads/ZILF/dotnet-sdk-9.0.310-osx-x64/host/fxr/9.0.12/libhostfxr.dylib, 1): Symbol not found: __ZNSt3__113basic_filebufIcNS_11char_traitsIcEEE4openEPKcj
  Referenced from: /Users/macbook/Downloads/ZILF/dotnet-sdk-9.0.310-osx-x64/host/fxr/9.0.12/libhostfxr.dylib (which was built for Mac OS X 12.0)
  Expected in: /usr/lib/libc++.1.dylib

The library libhostfxr.dylib was found, but loading it from /Users/macbook/Downloads/ZILF/dotnet-sdk-9.0.310-osx-x64/host/fxr/9.0.12/libhostfxr.dylib failed
  - Installing .NET prerequisites might help resolve this problem.
     https://go.microsoft.com/fwlink/?linkid=2063366
Failed to resolve libhostfxr.dylib [/Users/macbook/Downloads/ZILF/dotnet-sdk-9.0.310-osx-x64/host/fxr/9.0.12/libhostfxr.dylib]. Error code: 0x80008082
```

### Even earlier versions


Unfortunately, [v4](https://dotnet.microsoft.com/en-us/download/dotnet/4.0) seems to be missing.

Using [v3](https://dotnet.microsoft.com/en-us/download/dotnet/3.0)

```none
% gunzip dotnet-sdk-3.0.103-osx-x64.tar.gz
% tar xvf dotnet-sdk-3.0.103-osx-x64.tar
% ./dotnet --version
3.0.103
```

### `brew`

Attempting to install `dotnet` using `brew`:

```none
brew install dotnet
```

However, this, rather predictably, resulted in an error:

```none
GC: Failed to initialize GCToOSInterface
GC initialization failed with error 0x80004005
Failed to create CoreCLR, HRESULT: 0x80004005
```

Homebrew would probably have installed the latest (v9?) version anyway, which would have been incompatible. It seems better to continue with the "working" v8.

An alternative option might be to try `macports`, as it might have a Catalina compatible version of `dotnet`. However, as revealed below, I did not persue this option.

### Compiling Zilf!

Now that `dotnet` v8 is working, we can move on to finally compiling `zilf`, or at least try to.

First, ensure that your paths to `dotnet` are correct:

```none
% export DOTNET_ROOT=~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64
% export PATH=$PATH:~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64
```

Now build `zilf`, following the instructions in the README for `zilf`:

```none
% cd ../zilf-0.11.1
% dotnet build Zilf.sln
```

But `dotnet` v9 is required:

```none
/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/sdk/8.0.417/Sdks/Microsoft.NET.Sdk/targets/Microsoft.NET.TargetFrameworkInference.targets(166,5): error NETSDK1045: The current .NET SDK does not support targeting .NET 9.0.  Either target .NET 8.0 or lower, or use a version of the .NET SDK that supports .NET 9.0. Download the .NET SDK from https://aka.ms/dotnet/download [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Common/Zilf.Common.csproj]
```

There were a total of 14 errors.

#### Target incompatabilities

Is it possible to change the target? 

 - There is no mention of `9.0` in `Zilf.sln`.
 - There is no mention of `9.0` in `Zilf.sln.DotSettings`.

However, in each of the following files there is the line, `<TargetFramework>net9.0</TargetFramework>`:

 - `src/Analyzers/ZilfAnalyzers.Test/ZilfAnalyzers.Test.csproj`
 - `src/Analyzers/ZilfAnalyzers/ZilfAnalyzers.csproj`
 - `src/Zilf.Playground/Zilf.Playground.csproj`
   - Right click and select 'Show Package Contents'
 - `src/Zapf.Parsing/Zapf.Parsing.csproj`
 - `src/Zapf/Zapf.csproj`
 - `src/Dezapf/Dezapf.csproj`
 - `src/Zilf.Common/Zilf.Common.csproj`
 - `src/Zilf/Zilf.csproj`
 - `src/Zilf.Emit/Zilf.Emit.csproj`

After changing the `target` to `net8.0`, from `net9.0`, there are now just 6 build errors, in the `test` directory, rather that the `src/` diretory:

 - `test/Zilf.Tests/Zilf.Tests.csproj`
 - `test/Zilf.Emit.Tests/Zilf.Emit.Tests.csproj`
 - `test/Dezapf.Tests/Dezapf.Tests.csproj`
 - `test/Zilf.Tests.Integration/Zilf.Tests.Integration.csproj`
 - `test/Zilf.Common.Tests/Zilf.Common.Tests.csproj`
 - `test/Zapf.Tests/Zapf.Tests.csproj`
 
Now the build proceeds..!

#### More incompatability - `WebAssembly` and `WebUtilites`

```none
% dotnet build Zilf.sln
  Determining projects to restore...
  Restored /Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Emit/Zilf.Emit.csproj (in 4.66 sec).
...
```

but dies with 4 errors:

```none
/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Playground/Zilf.Playground.csproj : error NU1202: Package Microsoft.AspNetCore.Components.WebAssembly 9.0.9 is not compatible with net8.0 (.NETCoreApp,Version=v8.0). Package Microsoft.AspNetCore.Components.WebAssembly 9.0.9 supports: net9.0 (.NETCoreApp,Version=v9.0) [/Users/macbook/Downloads/ZILF/zilf-0.11.1/Zilf.sln]
/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Playground/Zilf.Playground.csproj : error NU1202: Package Microsoft.AspNetCore.WebUtilities 9.0.9 is not compatible with net8.0 (.NETCoreApp,Version=v8.0). Package Microsoft.AspNetCore.WebUtilities 9.0.9 supports: net9.0 (.NETCoreApp,Version=v9.0) [/Users/macbook/Downloads/ZILF/zilf-0.11.1/Zilf.sln]
/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Playground/Zilf.Playground.csproj : error NU1202: Package Microsoft.AspNetCore.Components.WebAssembly 9.0.9 is not compatible with net8.0 (.NETCoreApp,Version=v8.0) / browser-wasm. Package Microsoft.AspNetCore.Components.WebAssembly 9.0.9 supports: net9.0 (.NETCoreApp,Version=v9.0) [/Users/macbook/Downloads/ZILF/zilf-0.11.1/Zilf.sln]
/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Playground/Zilf.Playground.csproj : error NU1202: Package Microsoft.AspNetCore.WebUtilities 9.0.9 is not compatible with net8.0 (.NETCoreApp,Version=v8.0) / browser-wasm. Package Microsoft.AspNetCore.WebUtilities 9.0.9 supports: net9.0 (.NETCoreApp,Version=v9.0) [/Users/macbook/Downloads/ZILF/zilf-0.11.1/Zilf.sln]
    0 Warning(s)
    4 Error(s)
```

See also [Error After Upgrading the Blazor Project WASM to .Net 8 to .Net 9](https://learn.microsoft.com/en-us/answers/questions/2136286/error-after-upgrading-the-blazor-project-wasm-to-n)

We need to find the lines of the form:

```none
<PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly" Version="9.0.0" />
<PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly.DevServer" Version="9.0.0" PrivateAssets="all" />
```

In (right click and select 'Show Package Contents'):

 - `/src/Zilf.Playground/Zilf.Playground.csproj`

Changing

```none
    <PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly" Version="9.0.9" />
    <PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly.DevServer" Version="9.0.9" PrivateAssets="all" />
    <PackageReference Include="Microsoft.AspNetCore.WebUtilities" Version="9.0.9" />
    <PackageReference Include="System.Net.Http.Json" Version="9.0.9" />

```

to

```none
    <PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly" Version="8.0" />
    <PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly.DevServer" Version="8.0" PrivateAssets="all" />
    <PackageReference Include="Microsoft.AspNetCore.WebUtilities" Version="8.0" />
    <PackageReference Include="System.Net.Http.Json" Version="8.0" />
```

and rebuild.

#### `langversion` incompatabilities

The rebuild resulted in some new errors:

```none
% dotnet build Zilf.sln
...
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/test/Dezapf.Tests/Dezapf.Tests.csproj]
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zapf.Parsing/Zapf.Parsing.csproj]
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Zilf.Common/Zilf.Common.csproj]
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Analyzers/ZilfSourceGenerators/ZilfSourceGenerators.csproj]
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/Analyzers/ZilfAnalyzers/ZilfAnalyzers.csproj]
CSC : error CS1617: Invalid option '13' for /langversion. Use '/langversion:?' to list supported values. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/WindowsInstaller/WindowsInstaller.csproj]
    0 Warning(s)
    6 Error(s)
```

See [Compiler Error CS1617](https://learn.microsoft.com/en-us/dotnet/csharp/misc/cs1617)

Running 

```none
dotnet exec "~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64/sdk/8.0.417Roslyn/bincore/csc.dll" -langversion:?
```

did not work

I could not find any reference to `13` in:

 - `Dezapf.Tests.csproj`
 - `Zapf.Parsing.csproj`
 - `Zilf.Common.csproj`
 - `ZilfSourceGenerators.csproj`
 - `ZilfAnalyzers.csproj`
 - `WindowsInstaller.csproj`
 - Nor in:
   - `Zilf.sln`
   - `Zilf.sln.DotSettings`

However, there *was* a reference to `13` in `Directory.Build.props` (although, going by a recent modified time, this seems to be a build generated file):

```none
    <LangVersion>13</LangVersion>
```

changing to 

```none
    <LangVersion>13.0</LangVersion>
```

did not fix the issue. So where is it originating? Seeing as the `13.0` was not changed back to `13`, maybe an older language verson is required..? 

From [Compiler Error CS1617](https://learn.microsoft.com/en-us/dotnet/csharp/misc/cs1617), and looking at the valid values listed for "language", I changed `13.0` to `8.0`, but that was probably too far back, as 16 of these issues appeared:

```none
/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/WindowsInstaller/obj/Debug/net8.0-windows/WindowsInstaller.GlobalUsings.g.cs(10,1): error CS8400: Feature 'global using directive' is not available in C# 8.0. Please use language version 10.0 or greater. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/src/WindowsInstaller/WindowsInstaller.csproj]
```

Changing `8.0` to `10.0`, gave 10 errors:

```none
Feature 'collection expressions' is not available in C# 10.0. Please use language version 12.0 or greater. [/Users/macbook/Downloads/ZILF/zilf-0.11.1/test/Zapf.Tests/Zapf.Tests.csproj]
```

#### Success?

Changing `10.0` to `12.0` – which is probably the best version, as it is preceding the dotnet v9 correspondance to language 13.0 – resulted in success:

```none
% dotnet build Zilf.sln
  Determining projects to restore...
  All projects are up-to-date for restore.
  Dezapf.Tests -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Dezapf.Tests.dll
  Zilf.Common -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Common.dll
  WindowsInstaller -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0-windows/WindowsInstaller.dll
  Zapf.Parsing -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zapf.Parsing.dll
  ZilfAnalyzers -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/ZilfAnalyzers.dll
  ZilfSourceGenerators -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/netstandard2.0/ZilfSourceGenerators.dll
  Zilf.Emit -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Emit.dll
  Zilf.Common.Tests -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Common.Tests.dll
  Zilf.Emit.Tests -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Emit.Tests.dll
  Zapf -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/zapf.dll
  Successfully created package '/Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/ZilfAnalyzers.1.0.0.nupkg'.
  Dezapf -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Dezapf.dll
  Zapf.Tests -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zapf.Tests.dll
  ZilfAnalyzers.Test -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/ZilfAnalyzers.Test.dll
  Zilf -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/zilf.dll
  Zilf.Tests.Integration -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Tests.Integration.dll
  Zilf.Tests -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Tests.dll
  Zilf.Playground -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/Zilf.Playground.dll
  Zilf.Playground (Blazor output) -> /Users/macbook/Downloads/ZILF/zilf-0.11.1/bin/Debug/net8.0/wwwroot

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:01:25.79
```

However, does it work? The two UNIX binaries, `zilf` and `zapf`, are in `bin/debug/net8.0/` A lot of Microsoft and Windows binaries are also created. In all, around 108 MB of code was generated! Who said M\$ weren't sparing with their code?!?!

```none
% cp bin/Debug/net8.0/zilf /usr/local/bin
% cp bin/Debug/net8.0/zapf /usr/local/bin
% zilf
The application to execute does not exist: '/usr/local/bin/zilf.dll'.
% cp bin/Debug/net8.0/zilf.dll /usr/local/bin 
% zilf
A fatal error was encountered. The library 'libhostpolicy.dylib' required to execute the application was not found in '/Users/macbook/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64'.
Failed to run as a self-contained app.
  - The application was run as a self-contained app because '/usr/local/bin/zilf.runtimeconfig.json' was not found.
  - If this should be a framework-dependent app, add the '/usr/local/bin/zilf.runtimeconfig.json' file and specify the appropriate framework.
```

Hmmm, this could end up moving a lot of files around...

#### Moving everything?

Attempting to continue with the installation of `zilf` and moving over the remaining missing files to `/usr/local/bin`:

```none
% cp bin/Debug/net8.0/zilf.runtimeconfig.json /usr/local/bin
% cp bin/Debug/net8.0/Zilf.Common.dll /usr/local/bin
% cp bin/Debug/net8.0/ReadLine.dll /usr/local/bin 
```

results in a REPL:

```none
 % zilf
ZILF 0.11.1 built 08/02/2026 19:37:13
> 
```

However, trying to compile results in, yet another, missing file:

```none
% zilf tenline.zil 
ZILF 0.11.1 built 08/02/2026 19:37:13
file not found: Zilf.Emit, Version=0.11.1.0, Culture=neutral, PublicKeyToken=null
```
So, copying over to `/usr/local/bin/`:

```none
% cp bin/Debug/net8.0/Zilf.Emit.dll /usr/local/bin 
% zilf tenline.zil      
ZILF 0.11.1 built 08/02/2026 19:37:13
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/tenline.zil:27: INSERT-FILE: file not found: parser

1 error
```

Note: `parser.zil` is in `zillib/`.

##### Summary

You would need to move *at least* 7 files:

```none
% cp bin/Debug/net8.0/zilf /usr/local/bin
% cp bin/Debug/net8.0/zapf /usr/local/bin
% cp bin/Debug/net8.0/zilf.dll /usr/local/bin 
% cp bin/Debug/net8.0/zilf.runtimeconfig.json /usr/local/bin
% cp bin/Debug/net8.0/Zilf.Common.dll /usr/local/bin
% cp bin/Debug/net8.0/ReadLine.dll /usr/local/bin 
% cp bin/Debug/net8.0/Zilf.Emit.dll /usr/local/bin 
```

Note that `parser.zil` should be copied to your ZIL port source directory, i.e. the directory containing `tenline.zil`, and *not* `/usr/local/bin/` [Edit - This is actually incorrect as files from `zillib/` need to be placed in `/usr/local/bin/zillib/`, see below]. 

However, even then, you get many 'unassigned atom' and missing file errors:

```none
 % zilf tenline.zil
ZILF 0.11.1 built 08/02/2026 19:37:13
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:6: USE: file not found: QQ
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:7: USE: file not found: LIBMSG
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:8: USE: file not found: LIBMSG-DEFAULTS
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0128] /Users/macbook/Documents/TandT/ZIL/parser.zil:337: DEFMAC: arg 2: expected LIST
  in EVAL called at /Users/macbook/Documents/TandT/ZIL/parser.zil:337
  in MAPF called at /Users/macbook/Documents/TandT/ZIL/parser.zil:335
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:580: INSERT-FILE: file not found: orphan
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:583: INSERT-FILE: file not found: pseudo
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:586: INSERT-FILE: file not found: pronouns
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0200] /Users/macbook/Documents/TandT/ZIL/parser.zil:588: calling unassigned atom: PRONOUN
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0200] /Users/macbook/Documents/TandT/ZIL/parser.zil:594: calling unassigned atom: PRONOUN
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0200] /Users/macbook/Documents/TandT/ZIL/parser.zil:599: calling unassigned atom: PRONOUN
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0200] /Users/macbook/Documents/TandT/ZIL/parser.zil:605: calling unassigned atom: PRONOUN
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0200] /Users/macbook/Documents/TandT/ZIL/parser.zil:611: calling unassigned atom: FINISH-PRONOUNS
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:1681: INSERT-FILE: file not found: scope
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:3134: INSERT-FILE: file not found: events
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
[error MDL0604] /Users/macbook/Documents/TandT/ZIL/parser.zil:3136: INSERT-FILE: file not found: verbs
  in INSERT-FILE called at /Users/macbook/Documents/TandT/ZIL/tenline.zil:27
15 errors
```

For this reason, I stopped trying to move the files to `/usr/local/bin/`, and just used the `zilf` binary in place within the `bin/debug/net8.0/` directory, as is. 

However, in order to fix the errors above, you need to make a `zillib/` directory in `/usr/local/bin/`, and copy over all of the `.zil` files, and a `.mud` file, from the `zillib/` directory in the `zilf-0.11.1` source directory:

```none
mkdir -p /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/parser.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/verbs.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/scope.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/events.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/orphan.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/pseudo.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/pronouns.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/libmsg.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/libmsg-defaults.zil /usr/local/bin/zillib
cp /Users/macbook/Downloads/ZILF/zilf-0.11.1/zillib/qq.mud /usr/local/bin/zillib
```

Plese refer to the `Makefile` at the bottom of the page, for a list of all files that need to be copied to `/usr/local/bin`.


### Running `zilf` from its build directory

Running `zilf` from the `zilf-0.11.1/` directory yields much better results, and a REPL:

```none
% bin/debug/net8.0/zilf
ZILF 0.11.1 built 08/02/2026 19:37:13
> quit
QUIT
> exit
exit
> 
```

and finally compiling the TinyTextAdventure ZIL code:

```none
% ~/Downloads/ZILF/zilf-0.11.1/bin/debug/net8.0/zilf  tenline.zil 
ZILF 0.11.1 built 08/02/2026 19:37:13
```

This results in 

```none
% ls ten*
tenline.zap		tenline_data.zap	tenline_str.zap
tenline.zil		tenline_freq.zap
```

However, the [readme](https://github.com/taradinoc/zilf?tab=readme-ov-file) states that there should be a `.z3` file, which I do not have.

What that *readme* is missing, is the following step which is shown in [ZIL - Where to start - Quick Code Guide](https://www.youtube.com/watch?v=VMflK-xjyg0) @ [8:15](https://www.youtube.com/watch?v=VMflK-xjyg0&t=495),

```none
% zapf tenline.zap
The application to execute does not exist: '/usr/local/bin/zapf.dll'.
```

There seems to be a hardcoded path to `/usr/local/bin` as `zapf.dll` *is* in the `PATH`:

```none
 % echo $PATH
/usr/local/opt/llvm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/Apple/usr/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Users/macbook/.cargo/bin:/Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0:/Users/macbook/Downloads/ZILF/zilf/dotnet-sdk-8.0.417-osx-x64
% ls /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.*
zapf.dll                 zapf.runtimeconfig.json
zapf.deps.json           zapf.pdb      
```

That is rather unfortunate. Manually copying `zapf.dll` to `/usr/local/bin/`,

```none
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.dll /usr/local/bin
macbook@Macbooks-MacBook-Pro ZIL % zapf tenline.zap
A fatal error was encountered. The library 'libhostpolicy.dylib' required to execute the application was not found in '/Users/macbook/Downloads/ZILF/zilf/dotnet-sdk-8.0.417-osx-x64'.
Failed to run as a self-contained app.
  - The application was run as a self-contained app because '/usr/local/bin/zapf.runtimeconfig.json' was not found.
  - If this should be a framework-dependent app, add the '/usr/local/bin/zapf.runtimeconfig.json' file and specify the appropriate framework.
```

This really does seem rather unfortunate, especially as I had previously given up on trying to move everything to `/usr/local/bin`.

Nowevertheless, soldiering on, regardless,

```none
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.runtimeconfig.json /usr/local/bin
% zapf tenline.zap
Unhandled exception. System.IO.FileNotFoundException: Could not load file or assembly 'Zapf.Parsing, Version=0.11.1.0, Culture=neutral, PublicKeyToken=null'. The system cannot find the file specified.

File name: 'Zapf.Parsing, Version=0.11.1.0, Culture=neutral, PublicKeyToken=null'
zsh: abort      zapf tenline.zap
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zapf.Parsing.dll /usr/local/bin
% zapf tenline.zap
Unhandled exception. System.IO.FileNotFoundException: Could not load file or assembly 'Zilf.Common, Version=0.11.1.0, Culture=neutral, PublicKeyToken=null'. The system cannot find the file specified.

File name: 'Zilf.Common, Version=0.11.1.0, Culture=neutral, PublicKeyToken=null'
   at Zapf.Context..ctor()
   at Zapf.Program.TryParseArgs(IReadOnlyList`1 args, Context& ctx)
   at Zapf.Program.Main(String[] args)
zsh: abort      zapf tenline.zap
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zilf.Common.dll /usr/local/bin 
% zapf tenline.zap
ZAPF 0.11.1
Reading tenline.zap
Reading tenline_freq.zap
Reading tenline_data.zap
Reading tenline_str.zap
Measuring..
Assembling
Wrote 23074 bytes to tenline.z3
% ls ten*
tenline.z3		tenline.zil		tenline_freq.zap
tenline.zap		tenline_data.zap	tenline_str.zap
```

***Success!!!*** You can see the `.z3` file.

#### Summary

Even though you may be running `zilf` from the build directory, you will still need to copy the following files to `usr/local/bin/`, in order for `zapf` to work:

```none
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.dll /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.runtimeconfig.json /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zapf.Parsing.dll /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zilf.Common.dll /usr/local/bin
```


### Using the online toolchain

I tried installing an Ubuntu 24.04.3 LTS VM on VirtualBox, but my Mac slowed to a crawl.

Before I managed to get `dotnet` v8 working (see above), I ended up just using the online parser at [zilf.io - New Project](https://zilf.io/project/new), which works well. At least the code below is now typo free!

## Code

(If you have read everything this far, very well done!)

This is the ZIL port of the **TinyTextAdventure**, `tenline.zil`:


```none
"A reasonably faithful ZIL port of the impressively compact
TENLINER CAVE ADVENTURE by Einar Saukas, originally published
in ZX81 BASIC, later translated to BASIC 2.0 by Robin Harbron.
The 0/0 RUN bit is a throwback to the ZX81 experience. Some
efforts made to keep the game authentic, but modern conveniences
like being able to see the chest and corpse wothout searching
the room are allowed. The fanciest bit of coding by far
(thank you Jesse) is the DESCFCN used to suppress display of
the key, which is later cleared so that any item ut back on the 
corpse doesn't vanish from sight. I hope that you find this useful.
- Jason"

"Tenliner Cave Adventure main file"

<VERSION ZIP>
<CONSTANT RELEASED 1>

"Main loop"

<CONSTANT GAME-BANNER
"Tenliner Cave Adventure|
A ZILF learning experience in way more than 10 lines.|
Original game by Einar Saukas|
ZIL conversion by jcompton"
>

<INSERT-FILE "parser">

<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "0/0 RUN" CR CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,CAVE>
    <MOVE ,PLAYER ,HERE>
    <V-LOOK>
    <MAIN-LOOP>
>

"Objects"
   
<OBJECT SWORD
    (DESC "sword")
    (SYNONYM SWORD)
    (IN CHEST)
    (FLAGS TAKEBIT)>
    
<OBJECT CHEST
    (DESC "chest")
    (IN PIT)
    (SYNONYM CHEST)
    (ACTION CHEST-R)
    (FLAGS CONTBIT OPENABLEBIT LOCKEDBIT)>
    
<OBJECT KEY
    (DESC "key")
    (SYNONYM KEY)
    (IN CORPSE)
    (FLAGS TAKEBIT)
    (ACTION KEY-R)
    >
    
<OBJECT CORPSE
    (DESC "corpse")
    (IN LAKE)
    (SYNONYM CORPSE)
    (FLAGS SURFACEBIT CONTBIT OPENBIT)
    (DESCFCN CORPSE-DESC-F)>
    
<OBJECT DRAGON
    (DESC "dragon")
    (SYNONYM DRAGON)
    (IN HALL)
    (ACTION DRAGON-R)>
    
"Rooms. In the original BASIC room descriptions were constant, and minimlaist,
so let's replicate that behaviour. These do look weird in the status line if
you're an experienced player, but they get the point across."

<ROOM CAVE
    (DESC "you are in a cave.")
    (IN ROOMS)
    (NORTH TO HALL)
    (FLAGS LIGHTBIT)>
    
<ROOM HALL
    (DESC "You are in a hall.")
    (IN ROOMS)
    (SOUTH TO CAVE)
    (FLAGS LIGHTBIT)
    (EAST TO PIT)>
    
<ROOM PIT
    (DESC "You are in a pit.")
    (IN ROOMS)
    (WEST TO HALL)
    (NORTH TO LAKE)
    (FLAGS LIGHTBIT)>
    
<ROOM LAKE
    (DESC "You are in a lake.")
    (IN ROOMS)
    (SOUTH TO PIT)
    (FLAGS LIGHTBIT)>
    
"Routines. We have to do a few things to make it a game."

"You win by killing the dragon with the sword. If you  try killing him without, he kills you."

<ROUTINE DRAGON-R ()
    <COND (<VERB? ATTACK>
      <COND (<HELD? ,SWORD>
        <SETG SCORE <+ ,SCORE 10>>
        <TELL "You won." CR>
        <REMOVE ,DRAGON>
        <TELL "Your score is " N ,SCORE " of a possible 10, in " N ,MOVES " moves.">
          <V-QUIT>
        <TELL "Too bad." CR> <QUIT> <RFALSE>
            )
            (ELSE <JIGS-UP "You died.">
                  <TELL CR>
                  <V-QUIT>
            )
        >
    ) >   
>

"The key unlocks the chest, so we'll clear the lockedbit and get out of here."
    

<ROUTINE CHEST-R ()
        <COND (<VERB? OPEN>
               <COND (<HELD? ,KEY>
                      <FCLEAR , CHEST ,LOCKEDBIT>
                      <RFALSE>
                     )
                >
              )
        >
>

"In the original game, you had to LOOK in a room to notice the dragon, chest,
an the corpse and then you had to LOOK CORPSE to see the key and LOOK CHEST
after opeing it to notice tht it contins a sword. The default behaviouer of the ZILF libraries will display all of these objects as part of the room
description. I ecided that it was okay to display the dragon, chest, corpse,
and sword, but I wanted the key to stay hiden untuil the player expressly
exmined the corpse, while also allowing it to just be taken blindly, since the
BASIC game allowed that. To accomplish all this, we use a DESCFCN to force the 
game to only tell use that there's a corpse, even though it starts with a key
on it."

<ROUTINE CORPSE-DESC-F (ARG)
    <COND (<EQUAL? .ARG ,M-OBJDESC?> <RTRUE>)>
    <TELL "There is a corpse here." CR>
>

"When we get the key, we know the corpse can hold objects. So, let's stop
hiding objects with that DESCFCN by cleaing that property to False <>. Now
the game will decribe any objects we put back on the corpse."

<ROUTINE KEY-R ()
<COND (<VERB? TAKE>
<COND (<NOT <EQUAL? <GETP ,CORPSE ,P?DESCFCN> <> > >
<PUTP ,CORPSE ,P?DESCFCN <> >
<RFALSE>
) > ) > >

"And that's all there is to it."
```

## `zilf` for Catalina

### The working `zilf`

I made a compressed split tar file, of the built `zilf-0.11.1/bin/Debug/net8.0/` directory:

```none
tar cvzf - net8.0/ | split -b 20m - zilf_net8.0.tar.gz
```

To extract

```none
cat zilf_net8.0.tar.gz.* | tar xzvf -
```

However, the `zilf-0.11.1/zillib/` directory is also required. So...? There may be other files/directories required, so it is probably better to use the provided tools to create a package instead...

#### Reference

 - [Create a tar archive split into blocks of a maximum size](https://unix.stackexchange.com/q/61774/97255).

### Making a package

There is a PowerShell script `make-macos-package.ps1`, to create a Mac package. I installed `pwsh` via `brew` as this page recommends, [Install PowerShell on macOS](https://learn.microsoft.com/en-gb/powershell/scripting/install/install-powershell-on-macos?view=powershell-7.5)

Taking the code from `zilf-0.11.1/.github/workflows/build-packages.yml`:

```none
cd zilf-0.11.1
sudo gem install fpm
pwsh ./tools/package-all.ps1 -RuntimeIdentifiers osx-arm64 -Configuration Release
pwsh ./tools/make-macos-package.ps1 -Source Package/Release/Stage/zilf-$env:ZILF_LONG_VERSION-osx-arm64 -Destination Package/Release/Packages -Version $env:ZILF_LONG_VERSION -Arch arm64
```

However `pwsh` gives an error:

```none
Failed to load /usr/local/microsoft/powershell/7/libhostfxr.dylib, error: dlopen(/usr/local/microsoft/powershell/7/libhostfxr.dylib, 1): Symbol not found: __ZNSt3__113basic_filebufIcNS_11char_traitsIcEEE4openEPKcj
  Referenced from: /usr/local/microsoft/powershell/7/libhostfxr.dylib (which was built for Mac OS X 12.0)
  Expected in: /usr/lib/libc++.1.dylib

The library libhostfxr.dylib was found, but loading it from /usr/local/microsoft/powershell/7/libhostfxr.dylib failed
  - Installing .NET prerequisites might help resolve this problem.
     https://go.microsoft.com/fwlink/?linkid=2063366
Failed to resolve libhostfxr.dylib [/usr/local/microsoft/powershell/7/libhostfxr.dylib]. Error code: 0x80008082
```

It's the ol' "*built for macOS 12*" issue raising its ugly head, yet again. An earlier build of `pwsh` might work, instead of using the `brew` version. Or `macports` could provide a still supported version.

I gave up at this point. At least `zilf` is working and building `.zil` files.

### Fixed source code

The easiest solution seemed to be to just fix the source code, to make it compatible with `dotnet` v8, instead of v9.

I have placed this modified source code in [xtras/src](/xtras/src/).

You can unzip it and build it, using `dotnet` v8, with the following command:


```none
dotnet build Zilf.sln
```

You will still need to set the three environment variables first, though (as well as installing `dotnet`):

```none
% export DOTNET_ROOT=~/Downloads/ZILF/zilf/dotnet-sdk-8.0.417-osx-x64
% export PATH=$PATH:~/Downloads/ZILF/zilf/dotnet-sdk-8.0.417-osx-x64
% export PATH=$PATH:~/Downloads/ZILF/zilf/zilf-0.11.1/bin/debug/net8.0
```

### Makefile

This makefile installs, or removes, *all* of the required ZILF and ZAPF files to `/usr/local/bin`. It can also install `dotnet` in your home directory, `~/`:


```none
PROGRAM               = zilf

DOTNET                = dotnet

DOTNET_DIR            = ~/$(DOTNET)

SRCS                  = Zilf.sln

RM                    = rm

TAR                   = tar

MAKE                  = make

DEST                  = /usr/local/bin

ZILF_SRC_DIR          = /Users/macbook/Downloads/ZILF/zilf-0.11.1

DOTNET_BUILD          = $(ZILF_SRC_DIR)/bin/Debug/net8.0

ZILF_SRC_DIR_ZILLIB   = $(ZILF_SRC_DIR)/zillib

DEST_ZILLIB           = $(DEST)/zillib

all:            
		$(MAKE) install

$(PROGRAM):	$(SRCS)
		$(DOTNET) build $(SRCS)

install:         
		$(MAKE) install_zilf
		$(MAKE) install_zapf
		$(MAKE) install_common
		$(MAKE) install_zillib

clean:         
		$(MAKE) clean_zilf
		$(MAKE) clean_zapf
		$(MAKE) clean_common
		$(MAKE) clean_zillib

install_dotnet:
		curl -Lo $(DOTNET).tar.gz https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.417/dotnet-sdk-8.0.417-osx-x64.tar.gz
		mkdir -p $(DOTNET_DIR)
		$(TAR) -C $(DOTNET_DIR) -xf $(DOTNET).tar.gz
		$(RM) $(DOTNET).tar.gz
		export DOTNET_ROOT=$(DOTNET_DIR)
		export PATH=$$PATH:$(DOTNET_DIR)
		$(DOTNET) --version

clean_dotnet:
		$(RM) -rf $(DOTNET_DIR)

install_zilf:
		cp $(DOTNET_BUILD)/zilf $(DEST)
		cp $(DOTNET_BUILD)/zilf.dll $(DEST)
		cp $(DOTNET_BUILD)/zilf.runtimeconfig.json $(DEST)
		cp $(DOTNET_BUILD)/Zilf.Emit.dll $(DEST)
		cp $(DOTNET_BUILD)/ReadLine.dll $(DEST)

install_zapf:
		cp $(DOTNET_BUILD)/zapf $(DEST)
		cp $(DOTNET_BUILD)/zapf.dll $(DEST)
		cp $(DOTNET_BUILD)/zapf.runtimeconfig.json $(DEST)
		cp $(DOTNET_BUILD)/Zapf.Parsing.dll $(DEST)

install_common:
		cp $(DOTNET_BUILD)/Zilf.Common.dll $(DEST)

install_zillib:
		mkdir -p $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/parser.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/verbs.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/scope.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/events.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/orphan.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/pseudo.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/pronouns.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/libmsg.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/libmsg-defaults.zil $(DEST_ZILLIB)
		cp $(ZILF_SRC_DIR_ZILLIB)/qq.mud $(DEST_ZILLIB)

clean_zilf:
		rm $(DEST)/zilf
		rm $(DEST)/zilf.dll
		rm $(DEST)/zilf.runtimeconfig.json
		rm $(DEST)/Zilf.Emit.dll
		rm $(DEST)/ReadLine.dll

clean_zapf:
		rm $(DEST)/zapf
		rm $(DEST)/zapf.dll
		rm $(DEST)/zapf.runtimeconfig.json
		rm $(DEST)/Zapf.Parsing.dll

clean_common:
		rm $(DEST)/Zilf.Common.dll

clean_zillib:
		rm $(DEST_ZILLIB)/parser.zil
		rm $(DEST_ZILLIB)/verbs.zil
		rm $(DEST_ZILLIB)/scope.zil
		rm $(DEST_ZILLIB)/events.zil
		rm $(DEST_ZILLIB)/orphan.zil
		rm $(DEST_ZILLIB)/pseudo.zil
		rm $(DEST_ZILLIB)/pronouns.zil
		rm $(DEST_ZILLIB)/libmsg.zil
		rm $(DEST_ZILLIB)/libmsg-defaults.zil
		rm $(DEST_ZILLIB)/qq.mud
		rmdir $(DEST_ZILLIB)

```

To install, enter one of the folloewing lines:

```none
make
make all
make install
```

To remove:

```none
make clean
```

#### References

 - [How to set child process' environment variable in Makefile](https://stackoverflow.com/q/23843106/4424636)


## Gotchas and conclusion

Use [dotnet 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0), as it works on Catalina. I used version 8.0.417.

To expand the `dotnet` compressed file, do **not** double click the `.tar.gz` file for `dotnet`, i.e. `dotnet-sdk-8.0.417-osx-x64.tar.gz`, as it corrupts the contents. Use `gunzip` and `tar` instead. However, you *can* just double click the `zilf-0.11.1.zip` file, to expand it.

Remember to set the path to `dotnet` v8, if compiling, or just *using*, `zilf`:

```none
% export DOTNET_ROOT=~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64
% export PATH=$PATH:~/Downloads/ZILF/dotnet-sdk-8.0.417-osx-x64
```

Note: Even when compiled, you *still* have to set the path and root environment variables of `DOTNET`, in order to use `zilf`.

To use `zilf` in the directory where it was created, rather than `/usr/local/bin`, update the `PATH` environment variable:

```none
% export PATH=$PATH:~/Downloads/ZILF/zilf-0.11.1/bin/debug/net8.0
```

However, to finish off a build, by using `zapf`, you will need to copy some files to `/usr/local/bin/`:

```none
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.dll /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/zapf.runtimeconfig.json /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zapf.Parsing.dll /usr/local/bin
% cp /Users/macbook/Downloads/ZILF/zilf/zilf-0.11.1/bin/Debug/net8.0/Zilf.Common.dll /usr/local/bin
```




  [1]: xtras/images/MicroSoftCoreDamaged.png
