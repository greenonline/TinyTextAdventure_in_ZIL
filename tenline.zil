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
