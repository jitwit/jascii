require 'graphics/pplatimg'
coinsert 'pplatimg'

grayscale=: _8 (33 b.) 128 + 77 150 29&(+/ . *)"1

minou =: grayscale (3#256) #: readimg 'images/IMG_3026.jpg'

quantile=: 4 : 0
ws=. (%+/)"1 -. | xs -"0 1 is=. (<.,>.)"0 xs=. x * <:#y
ws (+/"1 @: *) is { /:~ y
)

pal =: |. ' .,:;-*+oO?&%@#'

NB. u is palette, x is target width, y is pixel data
jascii =: 1 : 0
b =. <. ({. $ ninou) % x
z=. (,:~,~b) (+/@,) ;. _3 y
u {~ 0 >. <: z I.~ ((%~ i.)<:#u) quantile , z
)
