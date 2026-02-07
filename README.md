# TinyTextAdventure_in_ZIL
A tiny adventure in ZIL

## Preamble

This is the code for the ZIL port, as written by [Jason Compton](https://www.youtube.com/channel/UCgi9B58U9QWxuZV9Du6l5LQ) in the video [Tiny Text Adventure: From ZX81 to VIC-20 to Ultimate 64](https://www.youtube.com/watch?v=_d2g5BXdyfU).

As the ZIL code didn't seem to have been made available, I transcribed it and posted it here.

## Links

 - [Tiny Text Adventure: From ZX81 to VIC-20 to Ultimate 64](https://www.youtube.com/watch?v=_d2g5BXdyfU)
 - [ZIL Info Repo:ZIL_Resources](https://github.com/heasm66/ZIL-Resources/tree/master)


### Vaguely related

 - [Ten Liner Cave](https://www.sharpmz.no/forum/viewtopic.php?t=374)
 - [How should I parse user input in a text adventure game?](https://gamedev.stackexchange.com/q/27004/202187)


## Notes

### Getting started

How does one go about setting up on the Mac? What binaries are required?

This page, [https://github.com/taradinoc/zilf](https://github.com/taradinoc/zilf) was useful for getting started.

 - [Releses](https://foss.heptapod.net/zilf/zilf/-/releases)
   - Get the macOS version tarball
 - Unzip
 - `cd` into `bin/`
 - run `zilf yourfile.zil`

Unfortunately, ony Apple Silicon build are available, not Intel, so you'll have to compile the source, if you have an older Mac.

```none
cd ../../zilf-0.11.1
```

You'll need [dotnet](https://dotnet.microsoft.com/en-us/download/dotnet/9.0). Luckily there is an x86 build of SDK 9.0.310. I downloaded the binaries not the pckage/installer. Then uncompress. Drag the `dotnet` binary into the `zilf-0.11.1/` directory.

```none
% ./dotnet build Zilf.sln
Error: [/Users/macbook/Downloads/zilf-0.11.1/host/fxr] does not exist
Failed to resolve libhostfxr.dylib [not found]. Error code: 0x80008083
%
```

Dragging the `host` directory into the `zilf-0.11.1/` directory

```none
% ./dotnet build Zilf.sln
Failed to load /Users/macbook/Downloads/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib, error: dlopen(/Users/macbook/Downloads/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib, 1): Symbol not found: __ZNSt3__113basic_filebufIcNS_11char_traitsIcEEE4openEPKcj
  Referenced from: /Users/macbook/Downloads/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib (which was built for Mac OS X 12.0)
  Expected in: /usr/lib/libc++.1.dylib

The library libhostfxr.dylib was found, but loading it from /Users/macbook/Downloads/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib failed
  - Installing .NET prerequisites might help resolve this problem.
     https://go.microsoft.com/fwlink/?linkid=2063366
Failed to resolve libhostfxr.dylib [/Users/macbook/Downloads/zilf-0.11.1/host/fxr/9.0.12/libhostfxr.dylib]. Error code: 0x80008082
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

I tried up installing an Ubuntu 24.04.3 LTS VM on VirtualBox, but my Mac slowed to a crawl.

I ended up just using the online parser at [zilf.io - New Project](https://zilf.io/project/new). At least the code below is now typo free!

## Code


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





