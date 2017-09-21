module Accessibility
    exposing
        ( Html
        , a
        , abbr
        , address
        , article
        , aside
        , audio
        , b
        , bdi
        , bdo
        , blockquote
        , body
        , br
        , button
        , canvas
        , caption
        , checkbox
        , cite
        , code
        , col
        , colgroup
        , datalist
        , dd
        , decorativeImg
        , del
        , details
        , dfn
        , div
        , dl
        , dt
        , em
        , embed
        , fieldset
        , figcaption
        , figure
        , footer
        , form
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , header
        , hr
        , i
        , iframe
        , img
        , inputText
        , ins
        , kbd
        , keygen
        , label
        , labelAfter
        , labelBefore
        , labelHidden
        , legend
        , li
        , main_
        , mark
        , math
        , menu
        , menuitem
        , meter
        , nav
        , object
        , ol
        , optgroup
        , option
        , output
        , p
        , param
        , pre
        , progress
        , q
        , radio
        , rp
        , rt
        , ruby
        , s
        , samp
        , section
        , select
        , small
        , source
        , span
        , strong
        , sub
        , summary
        , sup
        , tab
        , tabList
        , tabPanel
        , table
        , tbody
        , td
        , text
        , textarea
        , tfoot
        , th
        , thead
        , time
        , tr
        , track
        , u
        , ul
        , var
        , video
        , wbr
        )

{-|


## Labels

@docs labelBefore, labelAfter, labelHidden


## Inputs

Right now, this library only supports a few input types. Many more input types exist.
See [MDN's input information](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) for
more options.

@docs inputText, radio, checkbox


## Tabs

Together, `tabList`, `tab`, and `tabPanel` describe the pieces of a tab component view.

    import Accessibility exposing (Html, tab, tabList, tabPanel, text)
    import Accessibility.Widget exposing (controls, hidden, labelledBy, selected)
    import Html.Attributes exposing (id)

    view : Html msg
    view =
        tabList
            [ id "tab-list" ]
            [ tab
                [ id "tab-1"
                , selected True
                , controls "panel-1"
                ]
                [ text "Tab One" ]
            , tab
                [ id "tab-2"
                , selected False
                , controls "panel-1"
                ]
                [ text "Tab Two" ]
            , tabPanel
                [ id "panel-1"
                , labelledBy "tab-1"
                , hidden False
                , Html.Attributes.hidden False
                ]
                [ text "Panel One Content" ]
            , tabPanel
                [ id "panel-2"
                , labelledBy "tab-2"
                , hidden True
                , Html.Attributes.hidden True
                ]
                [ text "Panel Two Content" ]
            ]

For a more fully-fledged example using these helpers check out [elm-tabs](http://package.elm-lang.org/packages/tesk9/elm-tabs/latest).

@docs tabList, tab, tabPanel


## Images

@docs img, decorativeImg, figure


## From Html

@docs Html, text

@docs button, textarea, select

@docs h1, h2, h3, h4, h5, h6
@docs div, p, hr, pre, blockquote
@docs span, a, code, em, strong, i, b, u, sub, sup, br
@docs ol, ul, li, dl, dt, dd
@docs img, iframe, canvas, math
@docs form, option
@docs section, nav, article, aside, header, footer, address, main_, body
@docs figure, figcaption
@docs table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th
@docs fieldset, legend, label, datalist, optgroup, keygen, output, progress, meter
@docs audio, video, source, track
@docs embed, object, param
@docs ins, del
@docs small, cite, dfn, abbr, time, var, samp, kbd, s, q
@docs mark, ruby, rt, rp, bdi, bdo, wbr
@docs details, summary, menuitem, menu

-}

import Accessibility.Role as Role
import Accessibility.Style as Style
import Accessibility.Utils exposing (nonInteractive)
import Accessibility.Widget as Widget
import Html
import Html.Attributes


{-| All inputs must be associated with a `<label>` tag. Here is an example
that creates a text input for first names:

    firstNameInput : String -> Html msg
    firstNameInput name =
        labelBefore
            [ class "data-entry" ]
            (text "First Name:")
            (input [ type_ "text" ] name)

Now if you said `firstNameInput "Tom"` you would get HTML like this:

```html
<label class="data-entry">
  First Name:
  <input type="text" value="Tom"></input>
</label>
```

-}
labelBefore : List (Html.Attribute Never) -> Html Never -> Html msg -> Html msg
labelBefore attributes labelContent input =
    label attributes [ Html.map Basics.never labelContent, input ]


{-| All inputs must be associated with a `<label>` tag. Here is an example
that creates a text input for first names:

    firstNameInput : String -> Html msg
    firstNameInput name =
        labelAfter
            [ class "data-entry" ]
            (text "First Name:")
            (input [ type_ "text" ] name)

Now if you said `firstNameInput "Tom"` you would get HTML like this:

```html
<label class="data-entry">
  <input type="text" value="Tom"></input>
  First Name:
</label>
```

-}
labelAfter : List (Html.Attribute Never) -> Html Never -> Html msg -> Html msg
labelAfter attributes labelContent input =
    label attributes [ input, Html.map Basics.never labelContent ]


{-| All inputs must be associated with a `<label>` tag. Here is an example
that creates a text input for first names:

    firstNameInput : String -> Html msg
    firstNameInput name =
        labelHidden
            "name-input"
            [ class "data-entry" ]
            (text "First Name:")
            (input [ type_ "text", id "name-input" ] name)

Now if you said `firstNameInput "Tom"` you would get HTML like this:

```html
<span>
    <label for="name-input" class="data-entry" style="[styles hiding the input]">
        First Name:
    </label>
    <input id="name-input" type="text" value="Tom"></input>
</span>
```

-}
labelHidden : String -> List (Html.Attribute Never) -> Html Never -> Html msg -> Html msg
labelHidden id attributes labelContent input =
    span []
        [ label (Html.Attributes.for id :: Style.invisible :: attributes)
            [ Html.map Basics.never labelContent ]
        , input
        ]



{- *** Inputs *** -}


{-| Constructs an input of type "text". Use in conjunction with one of the label
helpers (`labelBefore`, `labelAfter`, `labelHidden`).

    firstNameInput : String -> Html Msg
    firstNameInput name =
        labelHidden
            "name-input"
            [ class "data-entry" ]
            (text "First Name:")
            (inputText name [ onBlur FirstName ])

-}
inputText : String -> List (Html.Attribute msg) -> Html msg
inputText value_ attributes =
    Html.input
        ([ Html.Attributes.type_ "text"
         , Html.Attributes.value value_
         ]
            ++ attributes
        )
        []


{-| Constructs an input of type "radio". Use in conjunction with one of the label
helpers (`labelBefore`, `labelAfter`, `labelHidden`).

    elementaryGradeInput : String -> Html Msg
    elementaryGradeInput name =
        labelAfter
            []
            (text "Elementary School")
            (radio "school-radio-group" "Elementary" True [])

-}
radio : String -> String -> Bool -> List (Html.Attribute msg) -> Html msg
radio name_ value_ checked_ attributes =
    Html.input
        ([ Html.Attributes.type_ "radio"
         , Html.Attributes.name name_
         , Html.Attributes.value value_
         , Html.Attributes.checked checked_
         ]
            ++ attributes
        )
        []


{-| Constructs an input of type "checkbox". Use in conjunction with one of the label
helpers (`labelBefore`, `labelAfter`, `labelHidden`).
Checkboxes may be checked, unchecked, or indeterminate.

    filterResultsInput : Maybe Bool -> Html Msg
    filterResultsInput checked =
        labelBefore
            []
            (text "Filter Results")
            (checkbox "No filter" Nothing [])

-}
checkbox : String -> Maybe Bool -> List (Html.Attribute msg) -> Html msg
checkbox value_ maybeChecked attributes =
    Html.input
        ([ Html.Attributes.type_ "checkbox"
         , Html.Attributes.value value_
         , Maybe.withDefault Widget.indeterminate (Maybe.map Html.Attributes.checked maybeChecked)
         ]
            ++ attributes
        )
        []



{- *** Tabs *** -}


{-| Create a tablist. This is the outer container for a list of tabs.
-}
tabList : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tabList attributes =
    Html.div (Role.tabList :: attributes)


{-| Create a tab. This is the part that you select in order to change panel views.
You'll want to listen for click events **and** for keyboard events: when users hit
the right and left keys on their keyboards, they expect for the selected tab to change.
-}
tab : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tab attributes =
    Html.div (Role.tab :: Html.Attributes.tabindex 0 :: attributes)


{-| Create a tab panel.
-}
tabPanel : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tabPanel attributes =
    Html.div (Role.tabPanel :: attributes)



{- *** Images *** -}


{-| Use this tag when the image provides information not expressed in the text of the page.
When images are used to express the purpose of a button or link, aim for alternative text that encapsulates the function of the image.

Read through [the w3 informative image tutorial](https://www.w3.org/WAI/tutorials/images/informative/) and the [the w3 functional image tutorial](https://www.w3.org/WAI/tutorials/images/functional/) to learn more.

For graphs and diagrams, see `figure` and `longDesc`.

    img "Bear rubbing back on tree" [ src "bear.png" ]

-}
img : String -> List (Html.Attribute msg) -> Html msg
img alt_ attributes =
    Html.img (Html.Attributes.alt alt_ :: attributes) []


{-| Use this tag when the image is decorative or provides redundant information. Read through [the w3 decorative image tutorial](https://www.w3.org/WAI/tutorials/images/decorative/) to learn more.

    decorativeImg [ src "smiling_family.jpg" ]

-}
decorativeImg : List (Html.Attribute msg) -> Html msg
decorativeImg attributes =
    Html.img (Html.Attributes.alt "" :: Role.presentation :: attributes) []


{-| Adds the group role to a figure.
-}
figure : List (Html.Attribute msg) -> List (Html msg) -> Html msg
figure attributes =
    Html.figure (Role.group :: attributes)



{- *** Aliasing Html Elements *** -}


{-| -}
type alias Html msg =
    Html.Html msg


{-| -}
text : String -> Html.Html msg
text =
    Html.text



-- INTERACTABLE


{-| -}
select : List (Html.Attribute msg) -> List (Html msg) -> Html msg
select =
    Html.select


{-| -}
button : List (Html.Attribute msg) -> List (Html msg) -> Html msg
button =
    Html.button


{-| -}
textarea : List (Html.Attribute msg) -> List (Html msg) -> Html msg
textarea =
    Html.textarea



-- NOT INTERACTABLE


{-| `body` should generally not have event listeners.
-}
body : List (Html.Attribute Never) -> List (Html msg) -> Html msg
body attributes =
    Html.body (nonInteractive attributes)


{-| `section` should generally not have event listeners.
-}
section : List (Html.Attribute Never) -> List (Html msg) -> Html msg
section attributes =
    Html.section (nonInteractive attributes)


{-| `nav` should generally not have event listeners.
-}
nav : List (Html.Attribute Never) -> List (Html msg) -> Html msg
nav attributes =
    Html.nav (nonInteractive attributes)


{-| `article` should generally not have event listeners.
-}
article : List (Html.Attribute Never) -> List (Html msg) -> Html msg
article attributes =
    Html.article (nonInteractive attributes)


{-| `aside` should generally not have event listeners.
-}
aside : List (Html.Attribute Never) -> List (Html msg) -> Html msg
aside attributes =
    Html.aside (nonInteractive attributes)


{-| `h1` should generally not have event listeners.
-}
h1 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h1 attributes =
    Html.h1 (nonInteractive attributes)


{-| `h2` should generally not have event listeners.
-}
h2 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h2 attributes =
    Html.h2 (nonInteractive attributes)


{-| `h3` should generally not have event listeners.
-}
h3 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h3 attributes =
    Html.h3 (nonInteractive attributes)


{-| `h4` should generally not have event listeners.
-}
h4 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h4 attributes =
    Html.h4 (nonInteractive attributes)


{-| `h5` should generally not have event listeners.
-}
h5 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h5 attributes =
    Html.h5 (nonInteractive attributes)


{-| `h6` should generally not have event listeners.
-}
h6 : List (Html.Attribute Never) -> List (Html msg) -> Html msg
h6 attributes =
    Html.h6 (nonInteractive attributes)


{-| `header` should generally not have event listeners.
-}
header : List (Html.Attribute Never) -> List (Html msg) -> Html msg
header attributes =
    Html.header (nonInteractive attributes)


{-| `footer` should generally not have event listeners.
-}
footer : List (Html.Attribute Never) -> List (Html msg) -> Html msg
footer attributes =
    Html.footer (nonInteractive attributes)


{-| `address` should generally not have event listeners.
-}
address : List (Html.Attribute Never) -> List (Html msg) -> Html msg
address attributes =
    Html.address (nonInteractive attributes)


{-| `main_` should generally not have event listeners.
-}
main_ : List (Html.Attribute Never) -> List (Html msg) -> Html msg
main_ attributes =
    Html.main_ (nonInteractive attributes)



-- GROUPING CONTENT


{-| `p` should generally not have event listeners.
-}
p : List (Html.Attribute Never) -> List (Html msg) -> Html msg
p attributes =
    Html.p (nonInteractive attributes)


{-| `hr` should generally not have event listeners.
-}
hr : List (Html.Attribute Never) -> List (Html msg) -> Html msg
hr attributes =
    Html.hr (nonInteractive attributes)


{-| `pre` should generally not have event listeners.
-}
pre : List (Html.Attribute Never) -> List (Html msg) -> Html msg
pre attributes =
    Html.pre (nonInteractive attributes)


{-| `blockquote` should generally not have event listeners.
-}
blockquote : List (Html.Attribute Never) -> List (Html msg) -> Html msg
blockquote attributes =
    Html.blockquote (nonInteractive attributes)


{-| `ol` should generally not have event listeners.
-}
ol : List (Html.Attribute Never) -> List (Html msg) -> Html msg
ol attributes =
    Html.ol (nonInteractive attributes)


{-| `ul` should generally not have event listeners.
-}
ul : List (Html.Attribute Never) -> List (Html msg) -> Html msg
ul attributes =
    Html.ul (nonInteractive attributes)


{-| `li` should generally not have event listeners.
-}
li : List (Html.Attribute Never) -> List (Html msg) -> Html msg
li attributes =
    Html.li (nonInteractive attributes)


{-| `dl` should generally not have event listeners.
-}
dl : List (Html.Attribute Never) -> List (Html msg) -> Html msg
dl attributes =
    Html.dl (nonInteractive attributes)


{-| `dt` should generally not have event listeners.
-}
dt : List (Html.Attribute Never) -> List (Html msg) -> Html msg
dt attributes =
    Html.dt (nonInteractive attributes)


{-| `dd` should generally not have event listeners.
-}
dd : List (Html.Attribute Never) -> List (Html msg) -> Html msg
dd attributes =
    Html.dd (nonInteractive attributes)


{-| `figcaption` should generally not have event listeners.
-}
figcaption : List (Html.Attribute Never) -> List (Html msg) -> Html msg
figcaption attributes =
    Html.figcaption (nonInteractive attributes)


{-| `div` should generally not have event listeners.
-}
div : List (Html.Attribute Never) -> List (Html msg) -> Html msg
div attributes =
    Html.div (nonInteractive attributes)



-- TEXT LEVEL SEMANTIC


{-| `:` should generally not have event listeners.
-}
a : List (Html.Attribute Never) -> List (Html msg) -> Html msg
a attributes =
    Html.a (nonInteractive attributes)


{-| `em` should generally not have event listeners.
-}
em : List (Html.Attribute Never) -> List (Html msg) -> Html msg
em attributes =
    Html.em (nonInteractive attributes)


{-| `strong` should generally not have event listeners.
-}
strong : List (Html.Attribute Never) -> List (Html msg) -> Html msg
strong attributes =
    Html.strong (nonInteractive attributes)


{-| `small` should generally not have event listeners.
-}
small : List (Html.Attribute Never) -> List (Html msg) -> Html msg
small attributes =
    Html.small (nonInteractive attributes)


{-| `s` should generally not have event listeners.
-}
s : List (Html.Attribute Never) -> List (Html msg) -> Html msg
s attributes =
    Html.s (nonInteractive attributes)


{-| `cite` should generally not have event listeners.
-}
cite : List (Html.Attribute Never) -> List (Html msg) -> Html msg
cite attributes =
    Html.cite (nonInteractive attributes)


{-| `q` should generally not have event listeners.
-}
q : List (Html.Attribute Never) -> List (Html msg) -> Html msg
q attributes =
    Html.q (nonInteractive attributes)


{-| `dfn` should generally not have event listeners.
-}
dfn : List (Html.Attribute Never) -> List (Html msg) -> Html msg
dfn attributes =
    Html.dfn (nonInteractive attributes)


{-| `abbr` should generally not have event listeners.
-}
abbr : List (Html.Attribute Never) -> List (Html msg) -> Html msg
abbr attributes =
    Html.abbr (nonInteractive attributes)


{-| `time` should generally not have event listeners.
-}
time : List (Html.Attribute Never) -> List (Html msg) -> Html msg
time attributes =
    Html.time (nonInteractive attributes)


{-| `code` should generally not have event listeners.
-}
code : List (Html.Attribute Never) -> List (Html msg) -> Html msg
code attributes =
    Html.code (nonInteractive attributes)


{-| `var` should generally not have event listeners.
-}
var : List (Html.Attribute Never) -> List (Html msg) -> Html msg
var attributes =
    Html.var (nonInteractive attributes)


{-| `samp` should generally not have event listeners.
-}
samp : List (Html.Attribute Never) -> List (Html msg) -> Html msg
samp attributes =
    Html.samp (nonInteractive attributes)


{-| `kbd` should generally not have event listeners.
-}
kbd : List (Html.Attribute Never) -> List (Html msg) -> Html msg
kbd attributes =
    Html.kbd (nonInteractive attributes)


{-| `sub` should generally not have event listeners.
-}
sub : List (Html.Attribute Never) -> List (Html msg) -> Html msg
sub attributes =
    Html.sub (nonInteractive attributes)


{-| `sup` should generally not have event listeners.
-}
sup : List (Html.Attribute Never) -> List (Html msg) -> Html msg
sup attributes =
    Html.sup (nonInteractive attributes)


{-| `i` should generally not have event listeners.
-}
i : List (Html.Attribute Never) -> List (Html msg) -> Html msg
i attributes =
    Html.i (nonInteractive attributes)


{-| `b` should generally not have event listeners.
-}
b : List (Html.Attribute Never) -> List (Html msg) -> Html msg
b attributes =
    Html.b (nonInteractive attributes)


{-| `u` should generally not have event listeners.
-}
u : List (Html.Attribute Never) -> List (Html msg) -> Html msg
u attributes =
    Html.u (nonInteractive attributes)


{-| `mark` should generally not have event listeners.
-}
mark : List (Html.Attribute Never) -> List (Html msg) -> Html msg
mark attributes =
    Html.mark (nonInteractive attributes)


{-| `ruby` should generally not have event listeners.
-}
ruby : List (Html.Attribute Never) -> List (Html msg) -> Html msg
ruby attributes =
    Html.ruby (nonInteractive attributes)


{-| `rt` should generally not have event listeners.
-}
rt : List (Html.Attribute Never) -> List (Html msg) -> Html msg
rt attributes =
    Html.rt (nonInteractive attributes)


{-| `rp` should generally not have event listeners.
-}
rp : List (Html.Attribute Never) -> List (Html msg) -> Html msg
rp attributes =
    Html.rp (nonInteractive attributes)


{-| `bdi` should generally not have event listeners.
-}
bdi : List (Html.Attribute Never) -> List (Html msg) -> Html msg
bdi attributes =
    Html.bdi (nonInteractive attributes)


{-| `bdo` should generally not have event listeners.
-}
bdo : List (Html.Attribute Never) -> List (Html msg) -> Html msg
bdo attributes =
    Html.bdo (nonInteractive attributes)


{-| `span` should generally not have event listeners.
-}
span : List (Html.Attribute Never) -> List (Html msg) -> Html msg
span attributes =
    Html.span (nonInteractive attributes)


{-| `br` should generally not have event listeners.
-}
br : List (Html.Attribute Never) -> Html Never
br attributes =
    Html.br (nonInteractive attributes) []


{-| `wbr` should generally not have event listeners.
-}
wbr : List (Html.Attribute Never) -> List (Html msg) -> Html msg
wbr attributes =
    Html.wbr (nonInteractive attributes)


{-| `ins` should generally not have event listeners.
-}
ins : List (Html.Attribute Never) -> List (Html msg) -> Html msg
ins attributes =
    Html.ins (nonInteractive attributes)


{-| `del` should generally not have event listeners.
-}
del : List (Html.Attribute Never) -> List (Html msg) -> Html msg
del attributes =
    Html.del (nonInteractive attributes)


{-| `iframe` should generally not have event listeners.
-}
iframe : List (Html.Attribute Never) -> List (Html msg) -> Html msg
iframe attributes =
    Html.iframe (nonInteractive attributes)


{-| `embed` should generally not have event listeners.
-}
embed : List (Html.Attribute Never) -> List (Html msg) -> Html msg
embed attributes =
    Html.embed (nonInteractive attributes)


{-| `object` should generally not have event listeners.
-}
object : List (Html.Attribute Never) -> List (Html msg) -> Html msg
object attributes =
    Html.object (nonInteractive attributes)


{-| `param` should generally not have event listeners.
-}
param : List (Html.Attribute Never) -> List (Html msg) -> Html msg
param attributes =
    Html.param (nonInteractive attributes)


{-| `video` should generally not have event listeners.
-}
video : List (Html.Attribute Never) -> List (Html msg) -> Html msg
video attributes =
    Html.video (nonInteractive attributes)


{-| `audio` should generally not have event listeners.
-}
audio : List (Html.Attribute Never) -> List (Html msg) -> Html msg
audio attributes =
    Html.audio (nonInteractive attributes)


{-| `source` should generally not have event listeners.
-}
source : List (Html.Attribute Never) -> List (Html msg) -> Html msg
source attributes =
    Html.source (nonInteractive attributes)


{-| `track` should generally not have event listeners.
-}
track : List (Html.Attribute Never) -> List (Html msg) -> Html msg
track attributes =
    Html.track (nonInteractive attributes)


{-| `canvas` should generally not have event listeners.
-}
canvas : List (Html.Attribute Never) -> List (Html msg) -> Html msg
canvas attributes =
    Html.canvas (nonInteractive attributes)


{-| `math` should generally not have event listeners.
-}
math : List (Html.Attribute Never) -> List (Html msg) -> Html msg
math attributes =
    Html.math (nonInteractive attributes)


{-| `table` should generally not have event listeners.
-}
table : List (Html.Attribute Never) -> List (Html msg) -> Html msg
table attributes =
    Html.table (nonInteractive attributes)


{-| `caption` should generally not have event listeners.
-}
caption : List (Html.Attribute Never) -> List (Html msg) -> Html msg
caption attributes =
    Html.caption (nonInteractive attributes)


{-| `colgroup` should generally not have event listeners.
-}
colgroup : List (Html.Attribute Never) -> List (Html msg) -> Html msg
colgroup attributes =
    Html.colgroup (nonInteractive attributes)


{-| `col` should generally not have event listeners.
-}
col : List (Html.Attribute Never) -> List (Html msg) -> Html msg
col attributes =
    Html.col (nonInteractive attributes)


{-| `tbody` should generally not have event listeners.
-}
tbody : List (Html.Attribute Never) -> List (Html msg) -> Html msg
tbody attributes =
    Html.tbody (nonInteractive attributes)


{-| `thead` should generally not have event listeners.
-}
thead : List (Html.Attribute Never) -> List (Html msg) -> Html msg
thead attributes =
    Html.thead (nonInteractive attributes)


{-| `tfoot` should generally not have event listeners.
-}
tfoot : List (Html.Attribute Never) -> List (Html msg) -> Html msg
tfoot attributes =
    Html.tfoot (nonInteractive attributes)


{-| `tr` should generally not have event listeners.
-}
tr : List (Html.Attribute Never) -> List (Html msg) -> Html msg
tr attributes =
    Html.tr (nonInteractive attributes)


{-| `td` should generally not have event listeners.
-}
td : List (Html.Attribute Never) -> List (Html msg) -> Html msg
td attributes =
    Html.td (nonInteractive attributes)


{-| `th` should generally not have event listeners.
-}
th : List (Html.Attribute Never) -> List (Html msg) -> Html msg
th attributes =
    Html.th (nonInteractive attributes)


{-| `form` should generally not have event listeners.
-}
form : List (Html.Attribute Never) -> List (Html msg) -> Html msg
form attributes =
    Html.form (nonInteractive attributes)


{-| `fieldset` should generally not have event listeners.
-}
fieldset : List (Html.Attribute Never) -> List (Html msg) -> Html msg
fieldset attributes =
    Html.fieldset (nonInteractive attributes)


{-| `legend` should generally not have event listeners.
-}
legend : List (Html.Attribute Never) -> List (Html msg) -> Html msg
legend attributes =
    Html.legend (nonInteractive attributes)


{-| `label` should generally not have event listeners.
-}
label : List (Html.Attribute Never) -> List (Html msg) -> Html msg
label attributes =
    Html.label (nonInteractive attributes)


{-| `datalist` should generally not have event listeners.
-}
datalist : List (Html.Attribute Never) -> List (Html msg) -> Html msg
datalist attributes =
    Html.datalist (nonInteractive attributes)


{-| `optgroup` should generally not have event listeners.
-}
optgroup : List (Html.Attribute Never) -> List (Html msg) -> Html msg
optgroup attributes =
    Html.optgroup (nonInteractive attributes)


{-| `option` should generally not have event listeners.
-}
option : List (Html.Attribute Never) -> List (Html msg) -> Html msg
option attributes =
    Html.option (nonInteractive attributes)


{-| `keygen` should generally not have event listeners.
-}
keygen : List (Html.Attribute Never) -> List (Html msg) -> Html msg
keygen attributes =
    Html.keygen (nonInteractive attributes)


{-| `output` should generally not have event listeners.
-}
output : List (Html.Attribute Never) -> List (Html msg) -> Html msg
output attributes =
    Html.output (nonInteractive attributes)


{-| `progress` should generally not have event listeners.
-}
progress : List (Html.Attribute Never) -> List (Html msg) -> Html msg
progress attributes =
    Html.progress (nonInteractive attributes)


{-| `meter` should generally not have event listeners.
-}
meter : List (Html.Attribute Never) -> List (Html msg) -> Html msg
meter attributes =
    Html.meter (nonInteractive attributes)


{-| `details` should generally not have event listeners.
-}
details : List (Html.Attribute Never) -> List (Html msg) -> Html msg
details attributes =
    Html.details (nonInteractive attributes)


{-| `summary` should generally not have event listeners.
-}
summary : List (Html.Attribute Never) -> List (Html msg) -> Html msg
summary attributes =
    Html.summary (nonInteractive attributes)


{-| `menuitem` should generally not have event listeners.
-}
menuitem : List (Html.Attribute Never) -> List (Html msg) -> Html msg
menuitem attributes =
    Html.menuitem (nonInteractive attributes)


{-| `menu` should generally not have event listeners.
-}
menu : List (Html.Attribute Never) -> List (Html msg) -> Html msg
menu attributes =
    Html.menu (nonInteractive attributes)
