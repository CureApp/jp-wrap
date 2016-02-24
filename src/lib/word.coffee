
###*
文字 str とその幅 width を持つオブジェクト

@class Word
@module jp-wrap
###
class Word

    ###*
    @constructor
    @param {String} str
    @param {Boolean} [options.sameWidth] 全角文字と半角文字の幅を両方とも2として計算する
    @param {Object} [options.regexs] 幅の計算方法を正規表現で指定する
    ###
    constructor: (@str = '', options = {}) ->

        @sameWidth = !! options.sameWidth
        @regexs = (options.regexs ? [])

        @width = @constructor.widthByStr(@str, {sameWidth: @sameWidth, regexs: @regexs})

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
    頭のスペースを取り除く 全角文字も取り除く場合は第1引数をtrueに

    @method ltrim
    @param {Boolean} fullWidths 全角スペースも取り除く
    @return {Word} this
    ###
    ltrim: (fullWidthSpace = false) ->

        regex = if fullWidthSpace then /^([\s\u3000]+)/ else /^( +)/

        if matched = @str.match regex
            @str = @str.slice(matched[1].length)
            #@width -= @constructor.widthByStr(matched[1], {sameWidth: @sameWidth, regexs: @regexs})
            @width -= @constructor.widthByStr(matched[1], @sameWidth)

        return @


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
    全角文字と半角文字の幅を両方とも2として計算する場合はsameWidthオプションをtrueに
    正規表現で指定した文字の幅を指定して計算する場合はregexsオプションにpatternとwidthを持ったオブジェクトの配列を渡す

    @method widthByStr
    @private
    @static
    ###
    @widthByStr: (str = '', options = {}) ->

        sameWidth = !! options.sameWidth
        regexs = options.regexs ? []

        if sameWidth

            return str.length * 2

        else if Array.isArray(regexs) and regexs.length > 0

            length = 0

            for c in str
                matched = false

                for regexInfo in regexs

                    if c.match(regexInfo.pattern)
                        length += regexInfo.width
                        matched = true
                        break

                length += 2 if not matched

            return length

        else

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
