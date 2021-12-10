# Day 5: Rust

## Previous Experiences

I'd say I have pretty good experience with Rust through a lot of different small-ish projects.

## Notes

Doing this with Rust was pretty fun, although it was of course a lot more verbose than [Python yesterday](../04-python).

The syntax for updating a single element in `Vec`s is kind of weird though:

```rust
let test = vec![0; 3];
let ele = test.get_mut(1).unwrap();
*ele = 123;
```
