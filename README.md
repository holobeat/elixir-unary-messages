# UnaryMessages

A solution for generating unary messages using Chuck Norris' method, implemented in Elixir. Resulting encoded message contains only zeros and spaces. The processing pipe is as follows:


- convert characters to binary representations (7-bit aligned)
- join the binaries
- encode the leading sequence for each block of ones and zeros
  - "1" becomes "0 ", so the block of "111" becomes "0 000"
  - "0" becomes "00 ", so the block of "000" becomes "00 000"

##### Example:

Run `iex -S mix` (or `iex.bat -S mix` on Windows) in the project folder.
```
iex(1)> UnaryMessages.send("Hi")
"0 0 00 00 0 0 00 000 0 00 00 0 0 0 00 00 0 0"
iex(2)> UnaryMessages.receive("0 0 00 00 0 0 00 000 0 00 00 0 0 0 00 00 0 0")
"Hi"
```

##### Tests:

Test cases are included. Run `mix test` in the project folder.
