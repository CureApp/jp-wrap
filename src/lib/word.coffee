
###*
文字 str とその幅 width を持つオブジェクト

@class JpWrap
@module jp-wrap
###
class Word

    ###*
    @constructor
    @param {String} str
    ###
    constructor: (@str = '') ->

        zenkakus = (c for c in @str when not c.match /[ -~]/).length

        @width = zenkakus + @str.length

        @isAlphaNumeric = !!(@str.match /[a-zA-Z0-9]$/) # 半角英数で終わっているか

        @lbStr = null


    ###*
    最後の文字を取得

    @method last
    @return {String} lastChar
    ###
    last: ->

        @str[@str.length - 1]


    ###*
    与えられたWordを末尾に追加

    @method append
    @public
    @param {Word} word
    @return {Word} this
    ###
    append: (word) ->

        if @hasLineBreak()
            throw new Error 'hasLineBreak'

        @str += word.str
        @width += word.width
        @isAlphaNumeric = word.isAlphaNumeric
        @lbStr = word.lbStr

        return @


    ###*
    与えられた文字列を末尾に追加

    @method append
    @public
    @param {String} str
    @return {Word} this
    ###
    appendText: (str) ->

        @append new Word(str)


    ###*
    改行文字を末尾に追加

    @method appendLineBreak
    @return {Word} this
    ###
    appendLineBreak: (@lbStr) ->

        return @


    ###*
    文字を含むかどうか

    @method hasStr
    @public
    @return {Boolean}
    ###
    hasStr: ->

        @str.length > 0


    ###*
    改行文字を(末尾に)含むかどうか

    @method hasLineBreak
    @public
    @return {Boolean}
    ###
    hasLineBreak: ->

        @lbStr?


module.exports = Word
