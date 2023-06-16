# Experiments in unicode file name handling

## Context

Different OSes encode file names in different ways.

- Windows uses UTF-16 to encode file names
- Linux (and many others) use UTF-8
- Macos uses UFT-8, but with a differnt *normalization* than the others

Specifically, in Windows and most *nix systems, a non-ASCII character
is normally treated as a single code point.  For example, 'ü' is
Unicode 0x00FC. When we encode that to UTF-8, we get 0xC3 0xBC.
This is called NFC (Normalization Form C), and you might think of
the C meaning "composed".  When converting from UTF-8 to UTF-16 or
UTF-32, this yields 0x00FC.

Mac OS X uses NFD (Normalization Form D), where you can think of
the D as meaning "decomposed". In this normalization, our 'ü' is
encoded as 'u' (0x0075), followed by '◌̈' (0x0308). Think of it as
the 'u' followed by a character that looks like the accent mark
which will be drawn.

This repository was created from a linux machine, so the file names are
all in NFC form.

Background reading:
- [Unicode Normalization](https://www.win.tue.nl/~aeb/linux/uc/nfc_vs_nfd.html)
- [Unicode on macos](https://gist.github.com/JamesChevalier/8448512)
- [u with Diaeresis](https://www.compart.com/en/unicode/U+00FC)

## Lesson 1. cp and tar have different semantics

Try this on a mac.

```
mkdir u.cp
(cd utf8 ; cp -r . ../u.cp)

mkdir u.tar
(cd utf8 ; tar cf - . ) | (cd u.tar ; tar xf -)

diff -r u.cp u.tar
```
and you get
```
Only in u.tar: sübdir
Only in u.cp: sübdir
```

Dig further and we see that `u.cp` preserves the encoding syle,
even though it is not in NFD form.  It probably blindly reads the
file name as raw bytes and creates the copies from the same buffer.
That will work because the file names must bin in NFD form if they
are on a mac. Right? :-)

Meanwhile tar knows it might see things in NFC form from other
machines. It must do a conversion somewhere to NFD in the path.

```
$ ls -d u.cp/s*r | od -c
0000000    u   .   c   p   /   s   ü  **   b   d   i   r  \n
0000015
$ ls -d u.tar/s*r | od -c
0000000    u   .   t   a   r   /   s   u    ̈  **   b   d   i   r  \n
0000017
```

## Lesson 2. Creating tar files on different OSes does different things.

The `archives_by_os` directory contains tar and zip archives
of the `utf8` tree created on each of linux, macos, and windows.

Let's peer in and see how they encode things

```
$ od -c archives_by_os/utf8_linux.tar | grep 'b   d   i   r'
0012000    u   t   f   8   /   s   ü  **   b   d   i   r   /  \0  \0  \0
0013000    u   t   f   8   /   s   ü  **   b   d   i   r   /   2   -   λ
0015000    u   t   f   8   /   s   ü  **   b   d   i   r   /   h   e   l
$ od -c archives_by_os/utf8_win.tar | grep 'b   d   i   r'
0016020    ü  **   b   d   i   r  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0017020    b   d   i   r   /  \n   2   8       m   t   i   m   e   =   1
0020000    u   t   f   8   /   s   ü  **   b   d   i   r   /  \0  \0  \0
0021000    u   t   f   8   /   s   ü  **   b   d   i   r   /   P   a   x
0022020    b   d   i   r   /   2   -   λ  **  \n   2   8       m   t   i
0023000    u   t   f   8   /   s   ü  **   b   d   i   r   /   2   -   λ
0025000    u   t   f   8   /   s   ü  **   b   d   i   r   /   P   a   x
0026020    b   d   i   r   /   h   e   l   l   o  \n   2   8       m   t
0027000    u   t   f   8   /   s   ü  **   b   d   i   r   /   h   e   l
$ od -c archives_by_os/utf8_mac.tar | grep 'b   d   i   r'
0001020    ü  **   b   d   i   r  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0002020    b   d   i   r   /  \n   3   0       m   t   i   m   e   =   1
0003000    u   t   f   8   /   s   ü  **   b   d   i   r   /  \0  \0  \0
0021000    u   t   f   8   /   s   ü  **   b   d   i   r   /   P   a   x
0022020    b   d   i   r   /   h   e   l   l   o  \n   3   0       m   t
0023000    u   t   f   8   /   s   ü  **   b   d   i   r   /   h   e   l
0025000    u   t   f   8   /   s   ü  **   b   d   i   r   /   P   a   x
0026020    b   d   i   r   /   2   -   λ  **  \n   3   0       m   t   i
0027000    u   t   f   8   /   s   ü  **   b   d   i   r   /   2   -   λ
```
That looks like NFC all around. This is expected because we started
with files in NFC form, and on macos it probably just picked up the bytes
of the filename and blatzed them to the archive. Let's confirm that,
by using tar from macos on the directory having the known NFD filename
and see what it does.

```
$ tar cf - u.tar | od -c | grep 'b   d   i'
0001020    s   u    ̈  **   b   d   i   r  \0  \0  \0  \0  \0  \0  \0  \0
...
```
Bingo!
