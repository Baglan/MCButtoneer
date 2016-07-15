# MCButtoneer

Make any UIView into a button

## Motivation

What is an app? Perhaps it can be thought of as a vial of magic that you can ... no no no, we are all civilized people here, use this carefully considered UI to just tap tap tap your way to the precious functionality.

The thing you tap on can be, generally, considered a button. As a part a library of standard components, Apple provides developers with the *UIButton* and siblings that are ... mostly good. But what if you want something crazy with balloons and fireworks? Please step down to *UITapGestureRecognizer* or, perhaps, do something with *touchesBegan/Moved/Ended/Canceled* – most annoying, there should be a better way!

## Solution

Let me introduce you to MCButtoneer! What does it do? It turns any kind of UIView to a tappable button, together with default but customizable press and release handlers and oh-so-popular these days blocks, closures or whatever you want to call them.

Here's a primer:

```swift
let sampleButtoneer = MCButtoneer()

...

sampleButtoneer.view = sampleButtonView

sampleButtoneer.action = { buttoneer in
    ...
}

sampleButtoneer.onPress = { buttoneer in
	...
}

sampleButtoneer.onRelease = { buttoneer in
	...
}
```

Irresistible, admit it!

(And available under a very permissive MIT license!) 