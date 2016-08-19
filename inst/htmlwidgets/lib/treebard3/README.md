Block-a-Day #12. Update of [Treemap Bar Chart](https://bl.ocks.org/cmgiven/018fd027d443b177e18fffb9afcdb5bd) to enable zooming into a specific country on click.

**Data Sources:** [Census](https://www.census.gov/foreign-trade/balance/index.html)

**What I Learned:** In a bit of treemap implementation trivia, nodes without a parent value of zero (i.e. those in a different continent than the selected country) will have `NaN` for their position values, as a result of a divide by zero, while those with a parent value but no value of their own will have position values, although width and height of, obviously, zero. I was originally just catching the `NaN`s, but this resulted in nodes flying to two different positions, thus the checking of `d.value` to determine how to position the nodes.

**What I'd Do With More Time:** Might be interesting if the transition was to vertically expand and fade the non-selected countries, to reinforce the idea of zooming in.

## Block-a-Day

Just what it sounds like. For fifteen days, I will make a [D3.js v4](https://d3js.org) block every single day. Rules:

1. Ideas over implementation. Do something novel, don't sweat the details.
2. No more than two hours can be spent on coding (give or take).
3. Every. Single. Day.

### Previously

* [Map to Force-Directed Graph](https://bl.ocks.org/cmgiven/4cfa1a95f9b952622280a90138842b79)
* [Brushable Scatterplot/Choropleth](https://bl.ocks.org/cmgiven/abca90f6ba5f0a14c54d1eb952f8949c)
* [Treemap Bar Chart](https://bl.ocks.org/cmgiven/018fd027d443b177e18fffb9afcdb5bd)
* [Triangular Scatterplot](https://bl.ocks.org/cmgiven/a0f58034cea5331a814b30b74aacb8af)
* [Choropleth with Animated Stripes](http://bl.ocks.org/cmgiven/09140e2ac8119340048f62d1b241977e)
* [Collatz Conjecture](https://bl.ocks.org/cmgiven/231f779f9655025f38b5b4b828f3b7b0)
* [Bouncing Logo](https://bl.ocks.org/cmgiven/a325f14550a65dc8ff6898ef0f9feeb4)
* [Rectangular Collision Detection](https://bl.ocks.org/cmgiven/547658968d365bcc324f3e62e175709b)
* [Demers Catogram](https://bl.ocks.org/cmgiven/9d6bc46cf586738458c13dd2b5dadd84)
* [Gooey Exploding Scatterplot](https://bl.ocks.org/cmgiven/e5dfe0888968ee8c507f5469a4d62b6f)
* [Zoomable Choropleth](https://bl.ocks.org/cmgiven/d39ec773c4f063a463137748097ff52f)
