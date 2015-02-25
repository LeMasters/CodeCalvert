### How Processing's IDE deals with code:

Typically, Processing will create a folder ("Processing") within the MyDocuments or the Documents folder of the current user;

All programs are save (as plaintext .PDE files) within the Processing folder.

Each individual program -- regardless of how many seperate files comprise the source -- is saved in a subfolder whose name is _EXACTLY_ like the name of that program's primary .pde file.

So:
<code>
_Documents <folder>
|_Processing <folder>
 |_wallbasher99 <folder>
  |_wallbasher99.pde
  |_soundeffects.pde
 |_brickbreaker <folder>
  |_brickbreaker.pde
  |_brickobjects.pde
  |_readme.txt
</code>
etc.

