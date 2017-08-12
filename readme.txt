1. INTRODUCTION


Galaga is a remake of the classic 1981 arcade game using The App Game Kit. Once compiled, it works on Windows, macOS, Linux, iOS and Android.  I have tested it on all of those devices.


2. CURRENT STATUS


This is a work in progress.  Here's a minor breakdown of where things are roughly at:

a) The hardware startup sequence is complete - it's a trimmed down version of the original as that took too long when you just wanted to play a quick game.  To turn it off completely, comment out the line StartupSequence() in main.agc.

b) The demo-attract sequence is blocked in but is not functional past the initial reveal.

c) The gameplay is the furthest along.  There are still many issues and it's still incomplete.  These basic behaviours are there.
c.1) The regular attack stages all work.
c.2) The challenging stages work for the first 3 or so (that's as far as I can play the original.  I need to play to there to record the patterns and I haven't gotten further).
c.3) The bees are pretty complete.  The butterflies could use a bit of tuning
c.4) The bosses are where I am at now - incl. the capture.  The bosses use the butterfly flight logic.  The capture sequence is incomplete.
c.5) the 1 and 2 player support is complete.

d) The post-game flow with high-score taking, etc. is complete or quite complete.

e) Touch support is currently done through the AGK virtual buttons.  This can be improved on and is totally untuned, but works.


3. KEYS and JOYSTICK


On a desktop ENTER is the coin drop, 1 and 2 selects 1 or 2 players.  The CTRL key is the fire key and the left/right buttons move the player left and right

I have added support for a joy-pad.  I have not tested this with any other joystic than a NES like joypad through USB.  Select is coin-drop and Start starts a 1 player game.


4. TO DO


Everything called out in CURRENT STATUS as not done.  Also, in the code there are comments like this:
// TODO: <...>
Whatever is called out as <...> still needs to be done, fixed or worked on.


5. THE FILES


* attract.agc - This is the demo attract sequence code.  Very incomplete and rough.

* background.agc - a very small amount of code to make the scrolling background.  This is how this whole project started - I wrote that code to see how nice it would look and how easy it would be to do in AGK.

* globals.agc - a very large file with constants, text, Object definitions, screen layouts, motion paths, all the global variables, etc.

* input.agc - keyboard and joystick handling.

* main.agc - includes the other modules and has setup and main loop.

* misc.agc - contains a few utility functions.  State management stuff, making ranges of things visible, etc.

* play.agc - the largest file of all and contains pretty much all the game code.

* setup.agc - 1st time setup, as well as some helpers called for setting up every game.

* spawn.agc - the code that gets the enemies coming in waves.

* startup.agc - the fake hardware test sequence code.


6. WHY'S THIS UP HERE?


Making this game turned out to be more work than I thought.  It's really quite a complicated little shooter.  I have spent more time than I thought I would and I simply don't have the time right now to complete it.  

I decided I would just get this document done and put it on GitHub.  If anyone has any interest in working on it, at least it's there.


7. ABOUT THE APP GAME KIT (or AGK or AGK2)


Credit where it's due.  I started coding on a Commodore 64 and using the App Game Kit has been the closest I have come to having that thrill again.  It's not that the code is Basic (which it is, in this case - referred to as Tier 1), it's that the iteration time is so amazingly fast!

Using the App Game Kit is honestly the must fun you can have with your pants on.  I am in now way affiliated with these guys, but they have done an amazing job.  If you haven't checked it out, do.  It's awesome!  The speed with which you get to see your code run on a mobile device or other platform (using their broadcast and player model) is phenomenal.

There are also libraries to use this from C++ (referred to as Tier 2).

8. CONTACT


Feel free to contact me at swessels@email.com if you have thoughts or suggestions, or you want to work on this.  I have a tiny tool that I use to make the splines - that could be useful if anyone is better than me at the game for recording challenging stages beyond the 3rd.


Thank you
Stefan Wessels

UPDATE HISTORY

12 Aug 2017 - Initial Revision
