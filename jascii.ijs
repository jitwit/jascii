require 'graphics/pplatimg'
coinsert 'pplatimg'

grayscale=: 0.2126 0.7152 0.0722&(+/ . *)"1
NB. _8 (33 b.) 128 + 77 150 29&(+/ . *)"1

minou =: readimg 'images/smaller.jpg'

quantile=: 4 : 0
ws=. (%+/)"1 -. | xs -"0 1 is=. (<.,>.)"0 xs=. x * <:#y
ws (+/"1 @: *) is { /:~ y
)
percentile=: 1 : '((%~i.)u) quantile y'

pal0 =: ' .,-*?&@#'

NB. u is palette, x is target width/height, y is grayscaled pixel data
NB. index into u based on quantiles of grayscale
jascii0 =: 1 : 0
b =. <. ($ y) % x
z=. (,:~b) ({.@,) ;. _3 y
u {~ 0 >. <: z I.~ (#u) percentile , z
)

b55 =: 159 %~ _5 ]\ (|. , 5 12 15 12 5 , ]) 2 4 5 4 2  4 9 12 9 4
sobel_x=: _3 ]\ 1 0 _1 2 0 _2 1 0 _1
sobel_y=: |: sobel_x

dok =: 1 : '+/ , u * y'

atan2=: 12 o. j.
grad_I=: 3 : 0
gx =. (,~3) sobel_x dok ;._3 y
gy =. (,~3) sobel_y dok ;._3 y
gx + &. *: gy
NB. todo, atan2 round to nearest 0,45,90,135 (I. and half interval?)
)

jascii1 =: 1 : 0
y =. (,~ 5) (b55 dok);._3 y
b =. >. ($ y) % x
z=. (,:~b) ({.@,) ;. _3 y
u {~ 0 >. <: z I.~ (#u) percentile , z
)
