require 'graphics/pplatimg viewmat stats/bonsai'
coinsert 'pplatimg'

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

NB. grayscale/gaussian filter/sobel/direction partitioning
grayscale=: _8 (33 b.) 128 + 77 150 29&(+/ . *)"1

b55 =: 159 %~ _5 ]\ 2 4 5 4 2  4 9 12 9 4  5 12 15 12 5  4 9 12 9 4  2 4 5 4 2
sobel_y =: |: sobel_x =: 1 2 1 */ 1 0 _1

grad_i =: 3 3 (sobel_x&* j. & (+/@,) sobel_y&*) ;._3 ]
gauss_f =: 5 5 (+/ @ , @ (b55&*)) ;._3 ]

dirs =: 1r8p1 + 1r4p1 * i. 4
dir_ix=: _4 (_2 <\ ])\  1 0  1 2   0 2  2 0   0 1  2 1   0 0  2 2
dir =: dir_ix {~ 4 | dirs&I.

NB. canny edge detection: grayscale => gauss smooth => sorel intensity gradient
NB.                   => keep maximums => threshold + hysteresis
NB. maximums checked based on direction of gradient.
suppress_nonmax=: 3 : 'z * *./ z (>: & |) y {~ dir 1p1 | 12 o. z =. y {~ <1 1'
hysteresis=: 1 : '* 3 3 (4&{ * 2&e.)@:,;._3 u I. y'
canny=: 1 : 'u hysteresis | 3 3 suppress_nonmax ;._3 grad_i gauss_f grayscale y'

