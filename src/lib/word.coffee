
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

        @width = @constructor.widthByStr @str

        @isAlphaNumeric = !!(@str.match /\w$/) # 半角英数で終わっているか

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

        @isAlphaNumeric = false

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


    ###*
    文字列の幅を計算
    現時点ではASCIIおよび半角カタカナ以外の半角は認識できない

    @method widthByStr
    @private
    @static
    ###
    @widthByStr: (str = '') ->

        fullWidths = (c for c in str when not c.match @halfWidthRegex).length
        return fullWidths + str.length


    ###*
    ASCII文字と半角カタカナにマッチする正規表現

    @property {RegExp} halfWidthRegex
    @private
    @static
    ###
    @halfWidthRegex: new RegExp('[ -~\uFF61-\uFF64\uFF65-\uFF9F]')


module.exports = Word
