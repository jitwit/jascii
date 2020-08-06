require 'graphics/pplatimg viewmat stats/bonsai'
coinsert 'pplatimg'

grayscale=: _8 (33 b.) 128 + 77 150 29&(+/ . *)"1

minou =: (3#256) #: readimg 'images/smaller.jpg'

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
sobel_y =: |: sobel_x =: 1 2 1 */ 1 0 _1
dok =: 1 : '+/ , u * y'

NB. intensity gradient
grad_i =: 3 3 (sobel_x&* j. & (+/@,) sobel_y&*) ;._3 ]
gauss_f =: 5 5 (+/ @ , @ (b55&*)) ;._3 ]

directions =: 1r8p1 + 1r4p1 * i. 4
dir_indices=: _4 (_2 <\ ])\  1 0  1 2   0 2  2 0   0 1  2 1   0 0  2 2
direction =: dir_indices {~ 4 | directions&I.
tlo =: 100
thi =: 200

NB. non maximum suppression => keep maximums
NB. 3x3 slices
suppress_nonmax=: 3 : 0
z * *./ z (>: & |) y {~ direction 1p1 | 12 o. z =. y {~ <1 1
)

NB. u has thresholds low and high. We classify edges from the
NB. thresholds and further suppress pixels who aren't near "strong"
NB. pixels
hysteresis=: 1 : 0
3 3 ((<1 1)&{ * 2 e. ,) ;. _3 u I. y
)

NB. after getting intensity gradients, we look for pixels that have
NB. maximal gradient relative to neighbors whose gradient has
NB. approximately the same direction.
canny=: 1 : 0
dy=. grad_i gauss_f y
u hysteresis | 3 3 suppress_nonmax ;._3 dy
)

jascii1 =: 1 : 0
y =. (,~ 5) (b55 dok);._3 y
b =. >. ($ y) % x
z=. (,:~b) ({.@,) ;. _3 y
u {~ 0 >. <: z I.~ (#u) percentile , z
)
