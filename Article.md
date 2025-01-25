The Basics

Constants and Variables
-    Must be declared before use
-    “let” is for constant, this value will not change
-    ”var” is for variables, this value will change
-    Can declare multiple constants or variables in one line
    o    var x = 0.0, y = 0.0, z = 0.0

Type Annotations
-    “:” means “…of type…”
    o    var welcomeMessage: String
    o    this means that the variable welcomeMessage can be = to any type string
    o    welcomeMessage = “Hello”
-    you can define multiple variables of the same type on a single line 
    o    var red, green, blue: Double

Printing Constants and Variables
-    you can print the value of a constant or variable
    o    say let friendlyWelcome = “Bonjour”
    o    print(friendlyWelcome) will print Bonjour
-    to have string print a statement and a var or constant do this
    o    print(“The current value of friendlyWelcome is \(friendlyWelcome)”)
    o    this prints “The current value of friendlyWelcome is Bonjour”

Semicolons
-    usually used to end a statement, not necessary in swift
-    semicolons in swift are used for multiple separate statements on a single line
    o    let cat = “meow”; print(cat)
    o    prints “meow”

Integer Bounds
-    you can access the minimum and maximum values of each integer type with its min and max properties
-    UInt8 is an 8bit unsigned integer meaning it can store whole numbers from 0 - 255
    o    let minValue = UInt8.min // minValue is equal to 0
    o    let maxValue = UInt8.max // maxValue is equal to 255

Floating-point Numbers
-    floating points are basically numbers that can be represent as a fraction
-    swift provides twto signed floating point number types:
    o    Double (64 bit floating point number) more decimals
    o    Float (32 bit floating point number) for lower memory usage

Type safety
-    let meaningOfLife = 42 // inferred to be of type Int
-    if you don’t specify a type for a floating point literal, swift infers that you want to create a Double
    o    let pi = 3.14159 // pi is inferred to be of type Double        

