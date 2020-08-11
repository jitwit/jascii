require 'graphics/pplatimg viewmat stats/bonsai math/fftw'
coinsert 'pplatimg'

NB. step one: improve this
downsample =: 4 : 0
window=. <. ($y) % x
(,:~ window) {.@, ;._3 y
)

pal0 =: ' .,-*?&@#'

dirascii=: '-/|\'
NB. grayscale/gaussian filter/sobel/direction partitioning
grayscale=: _8 (33 b.) 128 + 77 150 29&(+/ . *)"1

b55 =: 159 %~ _5 ]\ 2 4 5 4 2  4 9 12 9 4  5 12 15 12 5  4 9 12 9 4  2 4 5 4 2
sobel_y =: |: sobel_x =: 1 2 1 */ 1 0 _1

grad_i =: 3 3 (sobel_x&* j. & (+/@,) sobel_y&*) ;._3 ]
gauss_f =: 5 5 (+/ @ , @ (b55&*)) ;._3 ]

dirs =: 1r8p1 + 1r4p1 * i. 4
dir_ix33=: _4 (_2 <\ ])\  1 0  1 2   0 2  2 0   0 1  2 1   0 0  2 2
dir =: 4 | dirs I. 1p1 | 12 o. ]

NB. canny edge detection: grayscale => gauss smooth => sorel intensity gradient
NB.                   => keep maximums => threshold + hysteresis
NB. maximums checked based on direction of gradient.
suppress0=: 3 : 'z * *./ z (>: & |) y {~ dir_ix33 {~ dir z =. y {~ <1 1'
suppress_nonmax =: 3 3 suppress0 ;._3 ]
hysteresis=: 1 : '3 3 (*@:((4&{) * (2&e.))@:,) ;._3 u I. y'
canny=: 1 : 0
u hysteresis | suppress_nonmax grad_i gauss_f grayscale y
)

pad =: 0 ,.~ 0 ,~ 0 ,. 0 , ]

NB. m is threshold, n is target size, y image pixels
jascii =: 2 : 0
y0 =. n downsample grayscale y
ses =. m hysteresis | es =. suppress_nonmax grad_i gauss_f y0
(' ',dirascii) {~ (pad ses) * 1 + dir es
)

NB. hinou =: grayscale (3#256) #: readimg 'images/IMG_3026.jpg'
minou =: (3#256) #: readimg 'images/smaller.jpg'
ginou =: grayscale minou
vmg =: (0 0 0,:255 255 255)&viewmat

