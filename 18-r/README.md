# Day 18: R

## Previous Experiences

None.

## Notes

I heard good things about R of people using it for some university related projects.

But I can't confirm that.

One of the biggest flaws of R is that it is only call-by-value.
There is literally no simple call-by-reference.

Another thing that comes on top is the whole fuckup that R's lists are.
Not only you have to index them with `[[i]]` instead of `[i]` (because that gives you a singleton list, for some reason),
being a key feature of R they're missing a lot of functionality.

For example there is no simple way to insert to a list. There just isn't.
There exist hacky workarounds with sorting and some indexing magic and there are literally libraries for this but this should really be a core feature.

The whole file inclusion system is just bad and feels on one layer with that of C.
And we all know how we hated C for `#include`.

R feels like a giant fuckup.
There might be some useful stuff in it but if you try to do anything that isn't exactly intended by the authors,
then you'll have to rely on external libraries or prepare for writing lots of utility stuff.
It feels like a functional language (like Haskell) but without all the stuff that makes functional programming fun.

This was the worst language so far. And yes, this tops Chef.
